import 'package:flutter_gallery_next/base/network/base_network.dart';
import 'package:flutter_gallery_next/base/view_model/base_action.dart';
import 'package:flutter_gallery_next/biz/user_info/model/user_info_entity.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/service/use_case/user_info_api_use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

part 'user_info_state.freezed.dart';

class UserInfoState {
  late final Rx<ResponseEntity<UserInfoEntity>> rxUserInfo;

  UserInfoState() {
    rxUserInfo = ResponseEntity<UserInfoEntity>().obs;
  }

  UserInfoEntity? get userInfo => rxUserInfo.value.body;
}

@Freezed(copyWith: false, when: FreezedWhenOptions.none, map: FreezedMapOptions.none)
sealed class UserInfoActions extends BaseAction {
  const factory UserInfoActions.getUserInfo({UserInfoRequest? request}) = GetUserInfo;
}
