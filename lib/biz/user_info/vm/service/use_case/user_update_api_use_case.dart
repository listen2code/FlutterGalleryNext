import 'dart:ffi';

import 'package:flutter_gallery_next/base/network/base_network.dart';
import 'package:flutter_gallery_next/biz/user_info/model/user_info_entity.dart';

class UserUpdateApiUseCase extends BaseAPIUseCase<Void, UserUpdateRequest> {
  @override
  String getPath(UserUpdateRequest? request) {
    return "/userUpdate";
  }
}

class UserUpdateRequest implements BaseRequest {
  UserInfoEntity user;

  UserUpdateRequest({
    required this.user,
  });

  @override
  Map<String, dynamic>? getParameters() {
    Map<String, dynamic> result = {
      "id": user.id,
      "name": user.name,
      "age": user.age,
    };
    return result;
  }
}
