import 'package:flutter_gallery_next/base/network/base/base.dart';

class LogoutAPIUseCase extends BaseAPIUseCase<void, LogoutRequest> {
  @override
  String getPath(LogoutRequest? request) {
    return "/v1/logout";
  }

  @override
  bool retryAfter() => true;
}

class LogoutRequest implements BaseRequest {
  @override
  Map<String, dynamic>? getParameters() {
    return null;
  }
}
