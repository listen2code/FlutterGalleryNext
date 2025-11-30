import 'package:dio/dio.dart';
import 'package:package_libs/utils/logger_util.dart';

class BaseInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    InterceptorLogger.requestLog(options);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    InterceptorLogger.responseLog(response);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    InterceptorLogger.errorLog(err);
    super.onError(err, handler);
  }
}

class InterceptorLogger {
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
