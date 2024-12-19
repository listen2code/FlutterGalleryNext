import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'api_data_store.dart';

class APIRepository {
  APIRepository() {
    APIDataStore();
  }

  void init(
    Dio dio, {
    required String baseUrl,
    Map<String, dynamic>? addHeaders,
  }) {
    int connectTimeout = int.parse(dotenv.env['CONNECT_TIMEOUT'] ?? '30');
    int receiveTimeout = int.parse(dotenv.env['RECEIVE_TIMEOUT'] ?? '30');
    APIDataStore().init(
      dio,
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: connectTimeout),
      receiveTimeout: Duration(seconds: receiveTimeout),
      headers: _setHeaders(addHeaders),
    );
  }

  Map<String, dynamic> _setHeaders(Map<String, dynamic>? addHeaders) {
    Map<String, dynamic> headers = {};
    if (addHeaders != null) {
      headers.addAll(addHeaders);
    }
    return headers;
  }

  void cancelRequests({required CancelToken token}) {
    APIDataStore().cancelRequests(token: token);
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
    try {
      if (APIDataStore().enableConnection() == false) {
        return Response(requestOptions: RequestOptions());
      }
      return await APIDataStore().get(
        dio,
        path,
        params: params,
        options: options,
        cancelToken: cancelToken,
        refresh: refresh,
        noCache: noCache,
        cacheKey: cacheKey,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future post(
    Dio dio,
    String path, {
    Object? data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      if (APIDataStore().enableConnection() == false) {
        return Response(requestOptions: RequestOptions());
      }
      return await APIDataStore().post(
        dio,
        path,
        data: data,
        params: params,
        options: options,
        cancelToken: cancelToken,
      );
    } catch (e) {
      rethrow;
    }
  }
}
