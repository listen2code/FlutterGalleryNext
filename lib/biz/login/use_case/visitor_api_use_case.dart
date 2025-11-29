import 'package:flutter_gallery_next/base/network/base/base.dart';

class VisitorAPIUseCase extends BaseLoginUseCase<void, VisitorRequest> {
  @override
  String getPath(VisitorRequest? request) {
    return "/v1/visitor";
  }
}

class VisitorRequest implements BaseRequest {
  String version;

  VisitorRequest(this.version);

  @override
  Map<String, dynamic>? getParameters() {
    Map<String, dynamic> result = {
      "version": version,
    };
    return result;
  }
}
