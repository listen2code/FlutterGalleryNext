import 'package:flutter_gallery_next/base/network/base/base_api_use_case.dart';

class LogoutAPIUseCase extends BaseAPIUseCase<void, LogoutRequest> {
  @override
  String getPath(LogoutRequest? request) {
    return "/v1/logout";
  }

  @override
  bool retryAfter() => true;
}

class LogoutRequest implements IRequest {
  @override
  Map<String, dynamic>? getParameters() {
    return null;
  }
}
