import 'package:flutter_gallery_next/base/mvvm/view_mode/base_view_mode.dart';
import 'package:flutter_gallery_next/base/mvvm/view_mode/multi_net_data.dart';
import 'package:flutter_gallery_next/biz/login/login_state.dart';
import 'package:flutter_gallery_next/biz/login/service/login_service.dart';
import 'package:flutter_gallery_next/biz/login/use_case/login_api_use_case.dart';

class LoginViewMode extends ViewMode<LoginActions, LoginService> {
  final LoginState loginState = LoginState();

  @override
  dispatch(LoginActions action) {
    switch (action) {
      case DoLogin():
        request(
          api.memberLogin(action.request, LoginType.genLogin),
          action: action,
        );
    }
  }

  @override
  void onValue(MultiNetData netData, LoginActions action) {
    switch (action) {
      case DoLogin():
        loginState.rxLogin.value = netData[0];
    }
  }

  void doLogin({required String username, required String password}) {
    dispatch(LoginActions.doLogin(request: LoginRequest(username, password)));
  }
}
