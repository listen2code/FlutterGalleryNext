import 'dart:ffi';

import 'package:flutter_gallery_next/base/network/base_network.dart';
import 'package:flutter_gallery_next/biz/user_info/model/user_info_entity.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/service/use_case/user_delete_use_case.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/service/use_case/user_list_api_use_case.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/service/use_case/user_update_api_use_case.dart';

class UserInfoService extends BaseService {
  Future<ResponseEntity<List<UserInfoEntity>>> getUserList(UserListRequest? request) {
    return createUseCase(UserListAPIUseCase()).get(request);
  }

  Future<ResponseEntity<Void>> updateUser(UserUpdateRequest? request) {
    return createUseCase(UserUpdateApiUseCase()).post(request);
  }

  Future<ResponseEntity<Void>> deleteUser(UserDeleteRequest? request) {
    return createUseCase(UserDeleteAPIUseCase()).post(request);
  }
}
