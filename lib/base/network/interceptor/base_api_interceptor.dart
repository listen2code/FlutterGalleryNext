import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gallery_next/base/common/event_bus/event_bus.dart';
import 'package:flutter_gallery_next/base/common/event_bus/event_bus_key.dart';
import 'package:flutter_gallery_next/base/network/base/session_info.dart';
import 'package:flutter_gallery_next/base/network/base_network.dart';
import 'package:flutter_gallery_next/base/network/interceptor/base_interceptor.dart';
import 'package:flutter_gallery_next/base/utils/login_util.dart';
import 'package:flutter_gallery_next/base/widget/base/global_navigation.dart';
import 'package:flutter_gallery_next/base/widget/dialog/common_dialog.dart';
import 'package:flutter_gallery_next/biz/login/vm/service/use_case/login_api_use_case.dart';
import 'package:flutter_gallery_next/biz/login/vm/service/use_case/visitor_api_use_case.dart';
import 'package:package_libs/utils/connectivity_util.dart';
import 'package:package_libs/utils/http_util.dart';
import 'package:package_libs/utils/logger_util.dart';
import 'package:plugin_native/device/device_util.dart';

class BaseApiInterceptor extends QueuedInterceptor {
  /// avoid repeat request
  bool _isRetryCancel = false;

  static const List<String> noNeedSessionCheckApiList = ["/v1/login", "/v1/visitor", "/v1/logout"];

  static const List<String> needSessionApiList = ["/v1/login", "/v1/visitor"];

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    _isRetryCancel = false;
    if (await ConnectivityUtil.instance().isConnected() == false) {
      handler.reject(
        DioException(requestOptions: options, type: DioExceptionType.unknown, message: HttpUtil.noInternetConnection),
      );
    }
    RequestOptions newOptions = options.copyWith(headers: await _createHeaders(options));
    if (_isNeedSessionCheck(newOptions) && SessionInfo().isEmpty()) {
      if (await LoginUtil.isAutoLogin()) {
        await LoginAPIUseCase().autoLogin();
      } else {
        await VisitorAPIUseCase().login();
      }
      newOptions = newOptions.copyWith(headers: await _createHeaders(newOptions));
    }
    InterceptorLogger.requestLog(newOptions);
    handler.next(newOptions);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    InterceptorLogger.responseLog(response);
    try {
      if (_isRetryCancel) {
        handler.next(response);
      } else {
        _setSessionId(response);
        var apiResult = _convertToApiResult(response);
        if (SessionInfo().isMember() && apiResult == APIResult.sessionTimeout) {
          bool autoLogin = await LoginUtil.isAutoLogin();
          APIResult loginResult = APIResult.empty;
          String? newSessionId = _getSessionIdFromCookie(response);
          bool isSessionChanged = SessionInfo().isSessionChanged(newSessionId);
          if (autoLogin && isSessionChanged == false) {
            var entity = await LoginAPIUseCase().autoLogin();
            loginResult = entity.result;
            if (loginResult == APIResult.success) {
              GlobalDialog.showToast("auto login success");
            }
          }
          if (autoLogin && (loginResult == APIResult.success || isSessionChanged == true)) {
            // auto login
            if (_isNeedRetry(response.requestOptions)) {
              RequestOptions newOptions =
                  response.requestOptions.copyWith(headers: await _createHeaders(response.requestOptions));
              handler.next(await _retry(newOptions));
            } else {
              _isRetryCancel = false;
              handler.next(response);
            }
          } else {
            // manual login
            GlobalDialog.dismissLoading();
            var isRetry = _isNeedRetry(response.requestOptions);
            var loginResult = false;
            if (isSessionChanged == false) {
              Navigator.of(GlobalNavigation.currentContext!).pushNamed("login");
            }

            if (loginResult == true || isSessionChanged == true) {
              if (isRetry) {
                RequestOptions newOptions = response.requestOptions.copyWith(
                  headers: await _createHeaders(response.requestOptions),
                );
                handler.next(await _retry(newOptions));
              } else {
                _isRetryCancel = false;
                handler.next(response);
              }
            } else {
              SessionInfo().clearSessionInfo();
              await VisitorAPIUseCase().login();
              EventBus.defaultBus().post<String>(event: EventBusKeys.logout, key: EventBusKeys.logout);
              _isRetryCancel = false;
              handler.next(response);
            }
          }
        } else {
          handler.next(response);
        }
      }
    } catch (e, t) {
      handler.reject(DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: "onResponse exception: $e \nt=$t \nresponse:${response.data} ",
      ));
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    InterceptorLogger.errorLog(err);
    handler.next(err);
  }

  bool _isNeedSessionCheck(RequestOptions newOptions) {
    return noNeedSessionCheckApiList.contains(newOptions.path) == false;
  }

  Future<Map<String, dynamic>> _createHeaders(RequestOptions requestOptions) async {
    Map<String, dynamic> headers = {};
    headers["Accept"] = 'application/json';
    headers["Accept-Encoding"] = "gzip,deflate,br";
    headers["Cookie"] = _createCookie(requestOptions);
    headers["User-Agent"] = await DeviceUtil.instance().getUserAgent();
    log("_createHeaders: $headers");
    return headers;
  }

  String _createCookie(RequestOptions requestOptions) {
    String result = "";
    getCookies()?.forEach((key, value) {
      result += "$key=$value; ";
    });
    if (needSessionApiList.contains(requestOptions.path) == false) {
      var sessionId = SessionInfo().sessionId;
      if (sessionId != null) {
        result += "sessionId=$sessionId; ";
      }
    }
    log("_createCookie: $result");
    return result;
  }

  Map<String, dynamic>? getCookies() {
    return null;
  }

  bool _isNeedRetry(RequestOptions requestOptions) {
    return requestOptions.headers["retry_after"] ?? false;
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    try {
      if (ApiManager().enableConnection() == false) {
        return Response(requestOptions: RequestOptions());
      }
      ApiManager.retryDio.interceptors
        ..clear()
        ..add(BaseApiInterceptor());
      return await ApiManager().request(ApiManager.retryDio, requestOptions.path,
          data: requestOptions.data,
          params: requestOptions.queryParameters,
          cancelToken: requestOptions.cancelToken,
          options: Options(
            method: requestOptions.method,
            sendTimeout: requestOptions.sendTimeout,
            receiveTimeout: requestOptions.receiveTimeout,
            extra: requestOptions.extra,
            headers: requestOptions.headers,
            preserveHeaderCase: requestOptions.preserveHeaderCase,
            responseType: requestOptions.responseType,
            contentType: requestOptions.contentType,
            validateStatus: requestOptions.validateStatus,
            receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
            followRedirects: requestOptions.followRedirects,
            maxRedirects: requestOptions.maxRedirects,
            persistentConnection: requestOptions.persistentConnection,
            requestEncoder: requestOptions.requestEncoder,
            responseDecoder: requestOptions.responseDecoder,
            listFormat: requestOptions.listFormat,
          ),
          onSendProgress: requestOptions.onSendProgress,
          onReceiveProgress: requestOptions.onReceiveProgress);
    } catch (e) {
      LoggerUtil.error("retry: $e");
      rethrow;
    }
  }

  void _setSessionId(Response resp) {
    if (needSessionApiList.contains(resp.requestOptions.path)) {
      String? sessionId = _getSessionIdFromCookie(resp);
      if (sessionId != null) {
        SessionInfo().sessionId = sessionId;
      }
    }
  }

  String? _getSessionIdFromCookie(Response resp) {
    List<String> cookies = resp.headers["set-cookie"] ?? [];
    log(cookies, type: LoggerType.easy);
    for (var element in cookies) {
      var parts = element.split(";");
      for (var part in parts) {
        var values = part.split("=");
        log(values, type: LoggerType.easy);
        if (values[0].trim() == "JSESSIONID") {
          return values[1].trim();
        }
      }
    }
    return null;
  }

  APIResult _convertToApiResult(Response response) {
    APIResult result = APIResult.empty;
    var data = response.data;
    if (data != null && data != "") {
      if (data['result'] != null && data['result'] != "") {
        result = APIResultExtension.fromCode(response.data["result"]);
      }
    }
    return result;
  }
}
