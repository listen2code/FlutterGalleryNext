import 'package:flutter_gallery_next/base/network/base/base_api_use_case.dart';

class BaseService {
  final List<BaseAPIUseCase> _useCaseList = <BaseAPIUseCase>[];

  U createUseCase<U extends BaseAPIUseCase>(U useCase) {
    addToUseCaseList(useCase);
    return useCase;
  }

  void addToUseCaseList(BaseAPIUseCase useCase) {
    _useCaseList.add(useCase);
  }

  void cancelUseCase(BaseAPIUseCase useCase) {
    useCase.cancel();
    _useCaseList.remove(useCase);
  }

  void cancelAllUseCase() {
    for (var it in _useCaseList) {
      it.cancel();
    }
    _useCaseList.clear();
  }

  Future<ResponseEntity<T>> getNewDataFromNet<T, R extends IRequest>(
      BaseAPIUseCase<T, R> apiUseCase, R? request,
      {HttpMethod? method}) {
    addToUseCaseList(apiUseCase);
    switch (method) {
      case null:
      case HttpMethod.get:
        return apiUseCase.get(request);
      case HttpMethod.post:
        return apiUseCase.post(request);
    }
  }
}

enum HttpMethod { get, post }
