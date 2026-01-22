import 'package:flutter_gallery_next/base/network/base/base_response.dart';
import 'package:flutter_gallery_next/base/view_model/base_view_model.dart';
import 'package:flutter_gallery_next/base/view_model/multi_net_data.dart';
import 'package:flutter_gallery_next/biz/user_info/model/user_info_database.dart';
import 'package:flutter_gallery_next/biz/user_info/model/user_info_entity.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/service/use_case/user_delete_use_case.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/service/use_case/user_list_api_use_case.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/service/user_info_service.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/user_info_state.dart';

import 'service/use_case/user_update_api_use_case.dart';

class UserInfoViewModel extends ViewModel<UserInfoActions, UserInfoService> {
  final UserInfoState userInfoState = UserInfoState();

  @override
  void onReady() {
    super.onReady();
    fetchFromDb();
  }

  @override
  void dispose() {
    UserInfoDataBase.closeDataBase();
    super.dispose();
  }

  @override
  dispatch(UserInfoActions action) {
    switch (action) {
      case GetUserList():
        request(api.getUserList(action.request), action: action, handleBack: true);
        break;
      case UpdateUser():
        request(api.updateUser(action.request), action: action, handleBack: true);
        break;
      case DeleteUser():
        request(api.deleteUser(action.request), action: action, handleBack: true);
        break;
    }
  }

  @override
  void onValue(MultiNetData netData, UserInfoActions action) {
    switch (action) {
      case GetUserList():
        userInfoState.rxUserList.value = netData[0];
        userInfoState.userList?.forEach((user) => UserInfoDataBase.saveOrUpdate(user));
        break;
      case UpdateUser():
        fetchFromAws();
        break;
      case DeleteUser():
        UserInfoDataBase.deleteByUserId(action.request?.id ?? "").then((_) => fetchFromDb());
        break;
    }
  }

  void fetchFromDb() async {
    userInfoState.rxUserList.value = ResponseEntity()
      ..result = APIResult.success
      ..body = await UserInfoDataBase.getList();
  }

  void fetchFromAws() {
    dispatch(UserInfoActions.getUserList(request: UserListRequest()));
  }

  void deleteAll() {
    UserInfoDataBase.delete().then((_) => fetchFromDb());
  }

  void deleteUser(String? id) {
    if (id == null) return;
    dispatch(UserInfoActions.deleteUser(request: UserDeleteRequest(id: id)));
  }

  void addOrUpdateUser(UserInfoEntity user) {
    dispatch(UserInfoActions.updateUser(request: UserUpdateRequest(user: user)));
  }
}
