import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_libs/utils/logger_util.dart';
import 'package:plugin_native/proxy/proxy_util.dart';

import '../interceptor/base_api_interceptor.dart';

class ApiManager {
  static final ApiManager _instance = ApiManager._internal();

  factory ApiManager() => _instance;

  static late final Dio apiDio;
  static late final Dio loginDio;
  static late final Dio retryDio;
  final CancelToken _cancelToken = CancelToken();

  static const int maxConnection = 100;

  static int tasksCount = 0;

  ApiManager._internal() {
    apiDio = Dio(BaseOptions());
    apiDio.interceptors.add(BaseApiInterceptor());

    loginDio = Dio(BaseOptions());
    loginDio.interceptors.add(BaseApiInterceptor());

    retryDio = Dio(BaseOptions());
    retryDio.interceptors.add(BaseApiInterceptor());
  }

  void init(
    Dio dio, {
    String? baseUrl,
    Map<String, dynamic>? headers,
  }) {
    int connectTimeout = int.parse(dotenv.env['CONNECT_TIMEOUT'] ?? '30');
    int receiveTimeout = int.parse(dotenv.env['RECEIVE_TIMEOUT'] ?? '30');
    dio.options = dio.options.copyWith(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: connectTimeout),
      receiveTimeout: Duration(seconds: receiveTimeout),
      headers: headers,
    );
  }

  void cancelRequests({required CancelToken token}) {
    token.cancel("cancelled");
    log("cancel request", type: LoggerType.easy);
  }

  void taskBegin() {
    log("通信開始で通信中件数：$tasksCount", type: LoggerType.easy);
    tasksCount += 1;
  }

  void taskEnd() {
    tasksCount -= 1;
    log("通信完了で通信中件数：$tasksCount", type: LoggerType.easy);
  }

  Map<String, dynamic>? getAuthorizationHeader() {
    return null;
  }

  Future get(
    Dio dio,
    String path, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    bool refresh = false,
    bool noCache = true,
    String? cacheKey,
    bool cacheDisk = false,
  }) async {
    if (enableConnection() == false) {
      return Response(requestOptions: RequestOptions());
    }
    try {
      taskBegin();
      Options requestOptions = options ?? Options();
      requestOptions = requestOptions.copyWith(extra: {
        "refresh": refresh,
        "noCache": noCache,
        "cacheKey": cacheKey,
        "cacheDisk": cacheDisk,
      });
      Map<String, dynamic>? authorization = getAuthorizationHeader();
      if (authorization != null) {
        requestOptions = requestOptions.copyWith(headers: authorization);
      }
      await ProxyUtil.instance.findProxyAsync(Uri.parse(dio.options.baseUrl));
      return await dio.get(
        path,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken,
      );
    } catch (e) {
      LoggerUtil.error("DioException e=$e");
      rethrow;
    } finally {
      taskEnd();
    }
  }

  Future post(
    Dio dio,
    String path, {
    Map<String, dynamic>? params,
    Object? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    if (enableConnection() == false) {
      return Response(requestOptions: RequestOptions());
    }
    try {
      taskBegin();
      Options requestOptions = options ?? Options();
      Map<String, dynamic>? authorization = getAuthorizationHeader();
      if (authorization != null) {
        requestOptions = requestOptions.copyWith(headers: authorization);
      }
      await ProxyUtil.instance.findProxyAsync(Uri.parse(dio.options.baseUrl));
      return await dio.post(
        path,
        data: data,
        queryParameters: params,
        options: requestOptions,
        cancelToken: cancelToken ?? _cancelToken,
      );
    } catch (e) {
      LoggerUtil.error("DioException e=$e");
      rethrow;
    } finally {
      taskEnd();
    }
  }

  Future request(
    Dio dio,
    String path, {
    Object? data,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      taskBegin();
      Options requestOptions = options ?? Options();

      Map<String, dynamic>? authorization = getAuthorizationHeader();
      if (authorization != null) {
        requestOptions = requestOptions.copyWith(headers: authorization);
      }
      await ProxyUtil.instance.findProxyAsync(Uri.parse(dio.options.baseUrl));
      return await dio.request(
        path,
        data: data,
        queryParameters: params,
        cancelToken: cancelToken ?? _cancelToken,
        options: requestOptions,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      LoggerUtil.error("DioException e=$e");
      rethrow;
    } finally {
      taskEnd();
    }
  }

  bool enableConnection() {
    return tasksCount < maxConnection;
  }
}
