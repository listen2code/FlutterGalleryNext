import 'package:flutter_gallery_next/base/mvvm/view_mode/base_action.dart';
import 'package:flutter_gallery_next/base/network/base/base_api_use_case.dart';
import 'package:flutter_gallery_next/biz/login/model/login_entity.dart';
import 'package:flutter_gallery_next/biz/login/use_case/login_api_use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

part 'login_state.freezed.dart';

class LoginState {
  late final Rx<ResponseEntity<LoginEntity>> rxLogin;

  LoginState() {
    rxLogin = ResponseEntity<LoginEntity>().obs;
  }
}

// todo upgrade
@Freezed(
    copyWith: false, when: FreezedWhenOptions.none, map: FreezedMapOptions.none)
sealed class LoginActions extends BaseAction {
  const factory LoginActions.doLogin({LoginRequest? request}) = DoLogin;
}
