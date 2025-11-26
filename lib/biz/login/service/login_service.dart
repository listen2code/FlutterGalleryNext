import 'package:flutter_gallery_next/base/network/base/base_api_use_case.dart';
import 'package:flutter_gallery_next/base/network/base/base_service.dart';
import 'package:flutter_gallery_next/biz/login/model/login_entity.dart';
import 'package:flutter_gallery_next/biz/login/use_case/login_api_use_case.dart';

class LoginService extends BaseService {
  Future<ResponseEntity<LoginEntity>> memberLogin(
      LoginRequest? request, LoginType loginType) {
    LoginAPIUseCase memberLoginAPIUseCase = createUseCase(LoginAPIUseCase());
    return memberLoginAPIUseCase.login(request, loginType);
  }
}
