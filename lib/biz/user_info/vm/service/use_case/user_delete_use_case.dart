import 'dart:ffi';

import 'package:flutter_gallery_next/base/network/base_network.dart';

class UserDeleteAPIUseCase extends BaseAPIUseCase<Void, UserDeleteRequest> {
  @override
  String getPath(UserDeleteRequest? request) {
    return "/userDelete";
  }
}

class UserDeleteRequest implements BaseRequest {
  String id;

  UserDeleteRequest({
    required this.id,
  });

  @override
  Map<String, dynamic>? getParameters() {
    Map<String, dynamic> result = {
      "id": id,
    };
    return result;
  }
}
