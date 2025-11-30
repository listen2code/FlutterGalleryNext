import 'package:flutter_gallery_next/base/view_model/base_view_model.dart';
import 'package:flutter_gallery_next/base/view_model/multi_net_data.dart';
import 'package:flutter_gallery_next/biz/user_info/model/user_info_database.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/service/use_case/user_info_api_use_case.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/service/user_info_service.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/user_info_state.dart';
import 'package:get/get.dart';

class UserInfoViewModel extends ViewModel<UserInfoActions, UserInfoService> {
  final UserInfoState userInfoState = UserInfoState();
  final dbInfo = "".obs;

  @override
  void onReady() {
    super.onReady();
    getUserInfo();
  }

  @override
  void dispose() {
    UserInfoDataBase.closeDataBase();
    super.dispose();
  }

  @override
  dispatch(UserInfoActions action) {
    switch (action) {
      case GetUserInfo():
        request(api.getUserInfo(action.request), action: action, handleBack: true);
        break;
    }
  }

  @override
  void onValue(MultiNetData netData, UserInfoActions action) {
    switch (action) {
      case GetUserInfo():
        userInfoState.rxUserInfo.value = netData[0];
        UserInfoDataBase.save(userInfoState.userInfo!).then((_) {
          return UserInfoDataBase.getList();
        }).then((list) {
          dbInfo.value = list.toString();
        });
        break;
    }
  }

  void getUserInfo() {
    dispatch(UserInfoActions.getUserInfo(request: UserInfoRequest(userId: "")));
  }

  void deleteUserInfo() {
    UserInfoDataBase.deleteLast().then((_) {
      return UserInfoDataBase.getList();
    }).then((list) {
      dbInfo.value = list.toString();
    });
  }

  void updateUserInfo() {
    UserInfoDataBase.updateLast(userInfoState.userInfo!..name = "******").then((_) {
      return UserInfoDataBase.getList();
    }).then((list) {
      dbInfo.value = list.toString();
    });
  }
}
