import 'package:flutter_gallery_next/base/network/base/base.dart';
import 'package:flutter_gallery_next/biz/login/model/login_entity.dart';
import 'package:flutter_gallery_next/biz/login/use_case/login_api_use_case.dart';
import 'package:flutter_gallery_next/biz/login/use_case/logout_api_use_case.dart';

class LoginService extends BaseService {
  Future<ResponseEntity<LoginEntity>> login(LoginRequest? request, LoginType loginType) {
    return createUseCase(LoginAPIUseCase()).login(request, loginType);
  }

  Future<ResponseEntity<void>> logout(LogoutRequest? request) {
    return createUseCase(LogoutAPIUseCase()).post(request);
  }
}
