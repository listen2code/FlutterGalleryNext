import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_gallery_next/base/common/event_bus/event_bus.dart';
import 'package:flutter_gallery_next/base/common/event_bus/event_bus_key.dart';
import 'package:flutter_gallery_next/base/network/base/base_api_use_case.dart';
import 'package:flutter_gallery_next/base/network/base/session_info.dart';
import 'package:flutter_gallery_next/base/network/repository/api_data_store.dart';
import 'package:flutter_gallery_next/base/utils/login_util.dart';
import 'package:flutter_gallery_next/base/widget/dialog/common_dialog.dart';
import 'package:flutter_gallery_next/biz/login/model/login_entity.dart';
import 'package:flutter_gallery_next/biz/login/use_case/login_api_use_case.dart';
import 'package:flutter_gallery_next/biz/login/use_case/visitor_api_use_case.dart';
import 'package:package_libs/utils/http_util.dart';
import 'package:package_libs/utils/logger_util.dart';
import 'package:plugin_native/device/device_util.dart';

class CommonInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    DioInterceptorLogger.requestLog(options);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    DioInterceptorLogger.responseLog(response);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    DioInterceptorLogger.errorLog(err);
    super.onError(err, handler);
  }
}

class BaseApiInterceptor extends QueuedInterceptor {
  static const String headerSessionId = "sessionId";

  static const List<String> noSessionCheckList = [
    "/v1/login",
    "/v1/visitor",
    "/v1/logout",
  ];

  static const List<String> setSessionIdList = [
    "/v1/login",
    "/v1/visitor",
  ];

  bool _isRetryCancel = false;

  bool getIsRetryCancel() {
    return _isRetryCancel;
  }

  void setIsRetryCancel(bool isRetryCancel) {
    _isRetryCancel = isRetryCancel;
  }

  /// ネットワークチェック
  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    Map<String, dynamic> logInfo = {"Connectivity": connectivityResult};
    log(logInfo, type: LoggerType.easy);
    return connectivityResult.first != ConnectivityResult.none;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    DioInterceptorLogger.requestLog(options);
    setIsRetryCancel(false);
    bool isCon = await isConnected();
    if (isCon == false) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          message: HttpUtil.noInternetConnection,
        ),
      );
    }
    RequestOptions newOptions =
        options.copyWith(headers: await createHeaders(options));
    if (isSessionCheckRequired(newOptions.path)) {
      if (SessionInfo().jSessionId?.isEmpty ?? true) {
        var autoLogin = await LoginUtil.isAutoLogin();
        if (autoLogin) {
          await executeAutoLogin();
        } else {
          await visitorLogin();
        }
        newOptions =
            newOptions.copyWith(headers: await createHeaders(newOptions));
      }
    }
    DioInterceptorLogger.requestLog(newOptions);
    handler.next(newOptions);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    DioInterceptorLogger.responseLog(response);
    try {
      if (getIsRetryCancel()) {
        // avoid repeat request
        handler.next(response);
      } else {
        // member login
        setSessionId(response);
        var apiResult = getApiResult(response);
        if (SessionInfo().isMember() && apiResult == APIResult.sessionTimeout) {
          bool autoLogin = await LoginUtil.isAutoLogin();
          APIResult loginResult = APIResult.empty;
          String newSessionId =
              response.requestOptions.headers[headerSessionId];
          bool isSessionChanged = SessionInfo().isSessionChanged(newSessionId);
          if (autoLogin && isSessionChanged == false) {
            var entity = await executeAutoLogin();
            loginResult = entity.result;
            if (loginResult == APIResult.success) {
              GlobalDialog.showToast("auto login success");
            }
          }
          if (autoLogin &&
              (loginResult == APIResult.success || isSessionChanged == true)) {
            // auto login
            if (needRetry(response.requestOptions)) {
              RequestOptions newOptions = response.requestOptions.copyWith(
                  headers: await createHeaders(response.requestOptions));
              var retryResponse = await retry(newOptions);
              handler.next(retryResponse);
            } else {
              setIsRetryCancel(true);
              handler.next(response);
            }
          } else {
            // manual login
            GlobalDialog.dismissLoading();
            var isRetry = needRetry(response.requestOptions);
            var loginResult = false;
            if (isSessionChanged == false) {
              // todo
              // var reLogin = await Get.toLogin();
              // if(reLogin) {
              //   loginResult = true;
              // }
            }

            if (loginResult == true || isSessionChanged == true) {
              if (isRetry) {
                RequestOptions newOptions = response.requestOptions.copyWith(
                    headers: await createHeaders(response.requestOptions));
                var retryResponse = await retry(newOptions);
                handler.next(retryResponse);
              } else {
                setIsRetryCancel(true);
                handler.next(response);
              }
            } else {
              SessionInfo().clearSessionInfo();
              await visitorLogin();
              logoutEventBus();
              setIsRetryCancel(true);
              handler.next(response);
            }
          }
        } else {
          // visitor login
          if (apiResult == APIResult.sessionTimeout) {
            APIResult loginResult = APIResult.empty;
            String newSessionId =
                response.requestOptions.headers[headerSessionId];
            bool isSessionChanged =
                SessionInfo().isSessionChanged(newSessionId);
            if (isSessionChanged == false) {
              ResponseEntity<void> visitorLoginResult = await visitorLogin();
              loginResult = visitorLoginResult.result;
            }
            if (loginResult == APIResult.success || isSessionChanged == true) {
              if (needRetry(response.requestOptions)) {
                RequestOptions newOptions = response.requestOptions.copyWith(
                    headers: await createHeaders(response.requestOptions));
                var retryResponse = await retry(newOptions);
                handler.next(retryResponse);
              } else {
                handler.next(response);
              }
            } else {
              setIsRetryCancel(true);
              handler.next(response);
            }
          } else {
            handler.next(response);
          }
        }
      }
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: "response.data:${response.data}",
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    DioInterceptorLogger.errorLog(err);
    handler.next(err);
  }

  bool isSessionCheckRequired(String key) {
    if (noSessionCheckList.contains(key)) {
      return false;
    } else {
      return true;
    }
  }

  Future<Map<String, dynamic>> createHeaders(
      RequestOptions requestOptions) async {
    Map<String, dynamic> headers = {};
    headers["Accept"] = 'application/json';
    headers["Accept-Encoding"] = "gzip,deflate,br";
    headers["Cookie"] = _createCookie(requestOptions);
    headers["User-Agent"] = await _getUserAgent();
    return headers;
  }

  Future<String> _getUserAgent() async {
    String agent = await DeviceUtil.instance().getUserAgent();
    log("_getUserAgent: $agent");
    return agent;
  }

  String _createCookie(RequestOptions requestOptions) {
    String result = "";
    getCookies()?.forEach((key, value) {
      result += "$key=$value; ";
    });
    if (setSessionIdList.contains(requestOptions.path) == false) {
      var sessionId = SessionInfo().jSessionId;
      if (sessionId != null) {
        result += "$headerSessionId=$sessionId; ";
      }
    }
    log("_createCookie: $result");
    return result;
  }

  Map<String, dynamic>? getCookies() {
    return null;
  }

  void logoutEventBus() {
    EventBus.defaultBus()
        .post<String>(event: EventBusKeys.logout, key: EventBusKeys.logout);
  }

  bool needRetry(RequestOptions requestOptions) {
    bool result = requestOptions.headers["retry_after"] ?? false;
    return result;
  }

  Future<ResponseEntity<LoginEntity>> executeAutoLogin() async {
    var loginUseCase = LoginAPIUseCase();
    return loginUseCase.autoLogin();
  }

  Future<ResponseEntity<void>> visitorLogin() async {
    var loginUseCase = VisitorAPIUseCase();
    String version = await getAppVersion();
    return loginUseCase.post(VisitorRequest(version));
  }

  Future<String> getAppVersion() async {
    await DeviceUtil.instance().init();
    return DeviceUtil.instance().getAppVersionName() ?? "";
  }

  Future<Response> retry(RequestOptions requestOptions) async {
    try {
      if (APIDataStore().enableConnection() == false) {
        return Response(requestOptions: RequestOptions());
      }
      APIDataStore.retryDio.interceptors
        ..clear()
        ..add(BaseApiInterceptor());
      return await APIDataStore().request(
          APIDataStore.retryDio, requestOptions.path,
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
              receiveDataWhenStatusError:
                  requestOptions.receiveDataWhenStatusError,
              followRedirects: requestOptions.followRedirects,
              maxRedirects: requestOptions.maxRedirects,
              persistentConnection: requestOptions.persistentConnection,
              requestEncoder: requestOptions.requestEncoder,
              responseDecoder: requestOptions.responseDecoder,
              listFormat: requestOptions.listFormat),
          onSendProgress: requestOptions.onSendProgress,
          onReceiveProgress: requestOptions.onReceiveProgress);
    } catch (e) {
      log("retry: $e", type: LoggerType.error);
      rethrow;
    }
  }

  void setSessionId(Response resp) {
    if (setSessionIdList.contains(resp.requestOptions.path)) {
      String? sessionId = analysisSessionId(resp);
      if (sessionId != null) {
        SessionInfo().jSessionId = sessionId;
      }
    }
  }

  String? analysisSessionId(Response resp) {
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
}

APIResult getApiResult(Response response) {
  APIResult result = APIResult.empty;
  var data = response.data;
  if (data != null && data != "") {
    if (data['result'] != null && data['result'] != "") {
      result = APIResultExtension.fromCode(response.data["result"]);
    }
  }
  return result;
}

class DioInterceptorLogger {
  static void requestLog(RequestOptions options) {
    Map<String, dynamic> logInfo = {
      "baseUrl": options.baseUrl,
      "path": options.path,
      "uri": options.uri,
      "headers": options.headers,
      "contentType": options.contentType,
      "method": options.method,
      "queryParameters": options.queryParameters,
      "connectTimeout": options.connectTimeout,
      "sendTimeout": options.sendTimeout,
      "receiveTimeout": options.receiveTimeout,
      "onReceiveProgress": options.onReceiveProgress,
      "onSendProgress": options.onSendProgress,
      "data": options.data,
    };
    log(logInfo, type: LoggerType.debug);
  }

  static void responseLog(Response resp) {
    Map<String, dynamic> logInfo = {
      "requestUri": resp.requestOptions.uri,
      "statusCode": resp.statusCode,
      "statusMessage": resp.statusMessage,
      "headers": resp.headers,
      "isRedirect": resp.isRedirect,
      "data": resp.data,
    };
    log(logInfo, type: LoggerType.debug);
  }

  static void errorLog(DioException err) {
    Map<String, dynamic> logInfo = {
      "message": err.message,
      "error": err.error,
      "type": err.type,
    };
    log(logInfo, type: LoggerType.error);
  }
}
