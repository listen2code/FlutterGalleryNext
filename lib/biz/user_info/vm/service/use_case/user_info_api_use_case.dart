import 'package:flutter_gallery_next/base/network/base_network.dart';
import 'package:flutter_gallery_next/biz/user_info/model/user_info_entity.dart';

class UserInfoAPIUseCase extends BaseAPIUseCase<UserInfoEntity, UserInfoRequest> {
  @override
  String getPath(UserInfoRequest? request) {
    return "/v1/userInfo";
  }
}

class UserInfoRequest implements BaseRequest {
  String userId;

  UserInfoRequest({
    required this.userId,
  });

  @override
  Map<String, dynamic>? getParameters() {
    Map<String, dynamic> result = {
      "userId": userId,
    };
    return result;
  }
}
