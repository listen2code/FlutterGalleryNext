import 'package:flutter_gallery_next/base/mvvm/vm/base_view_model.dart';
import 'package:flutter_gallery_next/base/mvvm/vm/multi_net_data.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/service/use_case/user_info_api_use_case.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/service/user_info_service.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/user_info_state.dart';

class UserInfoViewModel extends ViewModel<UserInfoActions, UserInfoService> {
  final UserInfoState userInfoState = UserInfoState();

  @override
  void onReady() {
    super.onReady();
    dispatch(UserInfoActions.getUserInfo(request: UserInfoRequest(userId: "")));
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
        break;
    }
  }
}
