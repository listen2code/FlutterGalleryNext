import 'package:flutter_gallery_next/base/network/base_network.dart';
import 'package:flutter_gallery_next/biz/user_info/model/user_info_entity.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/service/use_case/user_info_api_use_case.dart';

class UserInfoService extends BaseService {
  Future<ResponseEntity<UserInfoEntity>> getUserInfo(UserInfoRequest? request) {
    return createUseCase(UserInfoAPIUseCase()).get(request);
  }
}
