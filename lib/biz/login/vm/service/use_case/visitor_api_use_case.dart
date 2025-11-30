import 'package:flutter_gallery_next/base/network/base_network.dart';
import 'package:plugin_native/device/device_util.dart';

class VisitorAPIUseCase extends BaseLoginUseCase<void, VisitorRequest> {
  @override
  String getPath(VisitorRequest? request) {
    return "/v1/visitor";
  }

  Future<ResponseEntity<void>> login() async {
    await DeviceUtil.instance().init();
    String version = DeviceUtil.instance().getAppVersionName() ?? "";
    return post(VisitorRequest(version));
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
