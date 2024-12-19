import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gallery_next/base/network/repository/api_data_store.dart';
import 'package:flutter_gallery_next/base/network/repository/api_exception.dart';
import 'package:flutter_gallery_next/base/network/repository/api_repository.dart';
import 'package:flutter_gallery_next/generated/json/base/json_convert_content.dart';
import 'package:intl/intl.dart';
import 'package:package_libs/utils/http_util.dart';

abstract class BaseAPIUseCase<T, R extends IRequest> {
  // 通信リポジトリ
  final APIRepository apiRepository = APIRepository();

  // 取消トークン
  final CancelToken _cancelToken = CancelToken();

  Dio getDio() {
    return APIDataStore.apiDio;
  }

  BaseAPIUseCase() {
    setBaseUrl();
  }

  String getPath(R? request) {
    return "";
  }

  R? request;

  void setBaseUrl() {
    apiRepository.init(
      APIDataStore.apiDio,
      baseUrl: dotenv.env['API_SERVER'] ?? '',
      addHeaders: addHeaders(),
    );
  }

  Map<String, dynamic> addHeaders() {
    Map<String, dynamic> headers = {};
    headers["retry_after"] = retryAfter();
    return headers;
  }

  bool retryAfter() {
    return false;
  }

  bool cacheFlag() {
    return true;
  }

  Future<ResponseEntity<T>> get([R? request]) async {
    Response resp;
    try {
      this.request = request;
      var parameters = xCreateRequest(request);
      parameters?.removeWhere((key, value) {
        return value == null;
      });
      resp = await apiRepository.get(
        getDio(),
        getPath(request),
        noCache: cacheFlag(),
        params: parameters,
        options: getRequestOptions(),
        cancelToken: _cancelToken,
      );
      if (HttpUtil.isSuccess(resp.statusCode) == false) {
        // 請求結果が200以外
        throw ApiResultException(resp.statusCode, resp.statusMessage);
      } else {
        // 上記以外
        return xCreateModel(resp);
      }
    } on DioException catch (e) {
      return xCreateDioError(e);
    } on ApiResultException catch (e) {
      return xCreateError(e, code: e.code);
    } on Exception catch (e) {
      return xCreateError(e);
    }
  }

  Future<ResponseEntity<T>> post([R? request]) async {
    Response resp;
    try {
      resp = await apiRepository.post(
        getDio(),
        getPath(request),
        options: getOptions(),
        data: xCreateRequest(request),
        cancelToken: _cancelToken,
      );
      if (HttpUtil.isSuccess(resp.statusCode) == false) {
        // 請求結果が200以外
        throw ApiResultException(resp.statusCode, resp.statusMessage);
      } else {
        // 上記以外
        return xCreateModel(resp);
      }
    } on DioException catch (e) {
      return xCreateDioError(e);
    } on ApiResultException catch (e) {
      return xCreateError(e, code: e.code);
    } on Exception catch (e) {
      return xCreateError(e);
    }
  }

  void cancel() {
    apiRepository.cancelRequests(token: _cancelToken);
  }

  Map<String, dynamic>? xCreateRequest(R? request) {
    return request?.getParameters();
  }

  ResponseEntity<T> xCreateModel(Response resp) {
    try {
      ResponseEntity<T> apiResult = ResponseEntity<T>();
      if (resp.data is Map<String, dynamic>) {
        apiResult = ResponseEntity<T>.fromJson(resp.data);
      }
      apiResult.serverTime = getServerTime(resp);
      return apiResult;
    } catch (e) {
      rethrow;
    }
  }

  DateTime getServerTime(Response? resp) {
    if (resp == null) {
      return DateTime.now();
    }

    var timeObj = resp.headers["server-time"];
    if (timeObj != null) {
      DateTime dateTime;
      try {
        List<String> time = timeObj;
        DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss", "ja_JP");
        dateTime = format.parse(time[0]);
      } on Exception catch (e) {
        dateTime = DateTime.now();
      }
      return dateTime;
    } else {
      return DateTime.now();
    }
  }

  ResponseEntity<T> xCreateDioError(DioException e, {int? code}) {
    ResponseEntity<T> result = ResponseEntity<T>();
    switch (e.type) {
      case DioExceptionType.cancel:
        // キャッセール異常は処理しない
        result.setError(code: code, msg: e.message, apiResult: APIResult.empty);
      default:
        result.setError(code: code, msg: e.message);
    }
    return result;
  }

  ResponseEntity<T> xCreateError(Exception e, {int? code}) {
    ResponseEntity<T> result = ResponseEntity<T>();
    result.setError(code: code, msg: e.toString());
    return result;
  }

  Options? getOptions() {
    return Options(
      contentType: "application/json",
      extra: createExtra(),
    );
  }

  Options? getRequestOptions() {
    return Options(
      extra: createExtra(),
    );
  }

  Map<String, dynamic> createExtra() {
    Map<String, dynamic> extra = {};
    if (isConcurrent()) {
      extra["isConcurrent"] = "on";
    }
    return extra;
  }

  bool isConcurrent() {
    return false;
  }
}

class ResponseEntity<T> {
  T? body;
  int? code;
  String? msg;
  String? messageId;
  String? message;

  DateTime? serverTime;

  APIResult result = APIResult.loading;

  void setError({
    int? code,
    String? msg,
    APIResult apiResult = APIResult.networkError,
  }) {
    result = apiResult;
    this.code = code ?? -1;
    this.msg = msg ?? "";
  }

  ResponseEntity();

  factory ResponseEntity.fromJson(Map<String, dynamic> json) => _$BaseEntityFromJson(json);

  factory ResponseEntity.error({int? code, String? msg, APIResult? result}) =>
      _$BaseEntityFromError(msg: msg, code: code, result: result);

  Map<String, dynamic> toJson() => _$BaseEntityToJson(this);
}

ResponseEntity<T> _$BaseEntityFromJson<T>(Map<String, dynamic> json) {
  final ResponseEntity<T> baseEntity = ResponseEntity();
  T? body;
  if (json['body'] != null) {
    body = JsonConvert.fromJsonAsT<T>(json['body']);
  }
  if (body != null) {
    baseEntity.body = body;
  }
  final String? messageId = jsonConvert.convert<String>(json['messageId']);
  if (messageId != null) {
    baseEntity.messageId = messageId;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    baseEntity.message = message;
  }
  final String? result = jsonConvert.convert<String>(json['result']);
  if (result != null) {
    baseEntity.result = APIResultExtension.fromCode(result);
  }
  return baseEntity;
}

ResponseEntity<T> _$BaseEntityFromError<T>({int? code, String? msg, APIResult? result}) {
  final ResponseEntity<T> baseEntity = ResponseEntity();
  if (code != null) {
    baseEntity.code = code;
  }
  if (msg != null) {
    baseEntity.msg = msg;
  }
  if (result != null) {
    baseEntity.result = result;
  }
  return baseEntity;
}

Map<String, dynamic> _$BaseEntityToJson(ResponseEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['body'] = entity.body?.toJson();
  data['messageId'] = entity.messageId;
  data['message'] = entity.message;
  data['result'] = entity.result;
  return data;
}

extension BaseEntityExtension<T> on ResponseEntity<T> {
  ResponseEntity<T> copyWith({
    T? body,
    String? messageId,
    String? message,
    APIResult? result,
  }) {
    return ResponseEntity()
      ..body = body ?? this.body
      ..messageId = messageId ?? this.messageId
      ..message = message ?? this.message
      ..result = result ?? this.result;
  }

  Widget observe(
    final Widget Function(T body) widget, {
    final Widget Function(String? error)? onError,
    final Widget Function(String? error)? onSystemError,
    final Widget Function(String? error)? onSessionTimeout,
    final Widget Function(String? error)? onNetworkError,
    final Widget? onLoading,
    final Widget? onEmpty,
    final bool autoEmpty = false,
  }) {
    return switch (result) {
      APIResult.success => autoEmpty && (T is List) && ((body as List?)?.isEmpty ?? true)
          ? onEmpty ??
              Container(
                height: 1,
              )
          : widget(body as T),
      APIResult.loading => onLoading ??
          FutureBuilder(
            future: Future.delayed(const Duration(milliseconds: 1000)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
      APIResult.generalError => onError != null
          ? onError(message)
          : Container(
              height: 1,
            ),
      APIResult.systemError => onSystemError != null
          ? onSystemError(message)
          : Container(
              height: 1,
            ),
      APIResult.sessionTimeout => onSessionTimeout != null
          ? onSessionTimeout(message)
          : Container(
              height: 1,
            ),
      APIResult.networkError => onNetworkError != null
          ? onNetworkError(message)
          : Container(
              height: 1,
            ),
      APIResult.empty => onEmpty ??
          Container(
            height: 1,
          ),
    };
  }
}

abstract class IRequest {
  Map<String, dynamic>? getParameters();
}
