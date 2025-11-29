import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gallery_next/base/network/base_network.dart';
import 'package:intl/intl.dart';
import 'package:package_libs/utils/http_util.dart';

abstract class BaseAPIUseCase<T, R extends BaseRequest> {
  final CancelToken _cancelToken = CancelToken();

  Dio getDio() {
    return ApiManager.apiDio;
  }

  BaseAPIUseCase() {
    setBaseUrl();
  }

  String getPath(R? request) {
    return "";
  }

  R? request;

  void setBaseUrl() {
    ApiManager().init(
      getDio(),
      baseUrl: dotenv.env['API_SERVER'] ?? '',
      headers: addHeaders(),
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

  bool isNoCache() {
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
      resp = await ApiManager().get(
        getDio(),
        getPath(request),
        noCache: isNoCache(),
        params: parameters,
        options: getRequestOptions(),
        cancelToken: _cancelToken,
      );
      if (HttpUtil.isSuccess(resp.statusCode)) {
        return xCreateModel(resp);
      } else {
        throw ApiResultException(resp.statusCode, resp.statusMessage);
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
      resp = await ApiManager().post(
        getDio(),
        getPath(request),
        options: getOptions(),
        data: xCreateRequest(request),
        cancelToken: _cancelToken,
      );
      if (HttpUtil.isSuccess(resp.statusCode)) {
        return xCreateModel(resp);
      } else {
        throw ApiResultException(resp.statusCode, resp.statusMessage);
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
    ApiManager().cancelRequests(token: _cancelToken);
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
      } on Exception {
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
