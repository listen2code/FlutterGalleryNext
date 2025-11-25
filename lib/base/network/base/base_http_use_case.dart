import 'package:dio/dio.dart';
import 'package:flutter_gallery_next/base/network/base/base_api_use_case.dart';
import 'package:flutter_gallery_next/base/network/repository/api_data_store.dart';

abstract class BaseHttpUseCase<T, R extends IRequest>
    extends BaseAPIUseCase<T, R> {
  @override
  Dio getDio() {
    // todo BaseUrl と DIO の 1 対 1
    return APIDataStore.httpDio;
  }

  @override
  void setBaseUrl() {
    apiRepository.init(
      APIDataStore.httpDio,
      baseUrl: getBaseUrl(),
      addHeaders: addHeaders(),
    );
  }

  String getBaseUrl();
}
