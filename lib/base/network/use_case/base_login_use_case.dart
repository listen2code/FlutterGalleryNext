import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gallery_next/base/network/base_network.dart';

abstract class BaseLoginUseCase<T, R extends BaseRequest> extends BaseAPIUseCase<T, R> {
  @override
  Dio getDio() {
    // todo BaseUrl と DIO の 1 対 1
    return APIDataStore.loginDio;
  }

  @override
  void setBaseUrl() {
    APIDataStore().init(
      APIDataStore.loginDio,
      baseUrl: dotenv.env['API_SERVER'] ?? '',
      headers: addHeaders(),
    );
  }
}
