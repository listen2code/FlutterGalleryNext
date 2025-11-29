import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gallery_next/base/network/base/base.dart';
import 'package:flutter_gallery_next/base/network/repository/api_data_store.dart';

abstract class BaseLoginUseCase<T, R extends BaseRequest>
    extends BaseAPIUseCase<T, R> {
  @override
  Dio getDio() {
    // todo BaseUrl と DIO の 1 対 1
    return APIDataStore.loginDio;
  }

  @override
  void setBaseUrl() {
    apiRepository.init(
      APIDataStore.loginDio,
      baseUrl: dotenv.env['API_SERVER'] ?? '',
      addHeaders: addHeaders(),
    );
  }
}
