import 'package:dio/dio.dart';
import 'package:package_libs/utils/logger_util.dart';

extension APIDioException on DioException {
  String? checkRequestResult() {
    final DioException error = this;
    switch (error.type) {
      case DioExceptionType.cancel:
        log("cancel", type: LoggerType.error);
        return error.message;
      case DioExceptionType.connectionTimeout:
        log("connectionTimeout", type: LoggerType.error);
        return error.message;
      case DioExceptionType.sendTimeout:
        log("sendTimeout", type: LoggerType.error);
        return error.message;
      case DioExceptionType.receiveTimeout:
        log("receiveTimeout", type: LoggerType.error);
        return error.message;
      case DioExceptionType.connectionError:
        log("connectionError", type: LoggerType.error);
        return error.message;
      case DioExceptionType.badResponse:
        try {
          int errCode = error.response?.statusCode ?? -1;
          switch (errCode) {
            case 400:
              log("badResponse 400", type: LoggerType.error);
              return error.message;
            case 401:
              log("badResponse 401", type: LoggerType.error);
              return error.message;
            case 403:
              log("badResponse 403", type: LoggerType.error);
              return error.message;
            case 404:
              log("badResponse 404", type: LoggerType.error);
              return error.message;
            case 405:
              log("badResponse 405", type: LoggerType.error);
              return error.message;
            case 500:
              log("badResponse 500", type: LoggerType.error);
              return error.message;
            case 502:
              log("badResponse 502", type: LoggerType.error);
              return error.message;
            case 503:
              log("badResponse 503", type: LoggerType.error);
              return error.message;
            case 505:
              log("badResponse 505", type: LoggerType.error);
              return error.message;
            default:
              log("badResponse unknown errCode", type: LoggerType.error);
              return error.message;
          }
        } on Exception catch (_) {
          log("badResponse unknown error.type", type: LoggerType.error);
          return error.message;
        }
      default:
        log("DioException unknown", type: LoggerType.error);
        return error.message;
    }
  }
}

class ApiResultException implements Exception {
  final int? code;
  final String? messages;

  ApiResultException(this.code, this.messages);

  @override
  String toString() {
    return "Code:$code, Messages:$messages";
  }
}
