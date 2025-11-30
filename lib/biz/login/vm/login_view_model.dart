import 'package:flutter_gallery_next/base/common/event_bus/event_bus.dart';
import 'package:flutter_gallery_next/base/common/event_bus/event_bus_key.dart';
import 'package:flutter_gallery_next/base/view_model/base_view_model.dart';
import 'package:flutter_gallery_next/base/view_model/multi_net_data.dart';
import 'package:flutter_gallery_next/base/network/base/session_info.dart';
import 'package:flutter_gallery_next/base/network/base_network.dart';
import 'package:flutter_gallery_next/biz/login/model/login_entity.dart';
import 'package:flutter_gallery_next/biz/login/vm/login_state.dart';
import 'package:flutter_gallery_next/biz/login/vm/service/login_service.dart';
import 'package:flutter_gallery_next/biz/login/vm/service/use_case/login_api_use_case.dart';
import 'package:flutter_gallery_next/biz/login/vm/service/use_case/logout_api_use_case.dart';
import 'package:package_libs/utils/http_util.dart';

class LoginViewModel extends ViewModel<LoginActions, LoginService> {
  final LoginState loginState = LoginState();

  @override
  void onReady() {
    super.onReady();
    loginState.rxLogin.value = ResponseEntity<LoginEntity>()
      ..result = APIResult.success
      ..body = LoginEntity().copyWith(
        userId: SessionInfo().loginInfo?.userId,
        name: SessionInfo().loginInfo?.name,
      );
  }

  @override
  dispatch(LoginActions action) {
    switch (action) {
      case DoLogin():
        request(api.login(action.request, LoginType.login), action: action);
        break;
      case DoLogout():
        request(api.logout(action.request), action: action);
        break;
    }
  }

  @override
  void onValue(MultiNetData netData, LoginActions action) {
    switch (action) {
      case DoLogin():
        loginState.rxLogin.value = netData[0];
        break;
      case DoLogout():
        SessionInfo().clearSessionInfo();
        EventBus.defaultBus().post<String>(event: EventBusKeys.logout, key: EventBusKeys.logout);
        loginState.rxLogin.value = ResponseEntity<LoginEntity>()
          ..result = APIResult.success
          ..body = LoginEntity().copyWith(
            userId: SessionInfo().loginInfo?.userId,
            name: SessionInfo().loginInfo?.name,
          );
        break;
    }
  }

  void doLogin({required String username, required String password}) {
    dispatch(
      LoginActions.doLogin(request: LoginRequest(userName: username, password: password)),
    );
  }

  void doLogout() {
    dispatch(LoginActions.doLogout(request: LogoutRequest()));
  }
}
