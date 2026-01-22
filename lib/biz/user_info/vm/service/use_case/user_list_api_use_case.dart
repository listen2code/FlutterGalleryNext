import 'package:flutter_gallery_next/base/network/base_network.dart';
import 'package:flutter_gallery_next/biz/user_info/model/user_info_entity.dart';

class UserListAPIUseCase extends BaseAPIUseCase<List<UserInfoEntity>, UserListRequest> {
  @override
  String getPath(UserListRequest? request) {
    return "/userList";
  }
}

class UserListRequest implements BaseRequest {
  @override
  Map<String, dynamic>? getParameters() {
    return null;
  }
}
