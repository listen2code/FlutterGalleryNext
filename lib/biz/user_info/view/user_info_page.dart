import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/mvvm/view/auto_load_widget.dart';
import 'package:flutter_gallery_next/base/mvvm/view/base_stateful_page.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/service/user_info_service.dart';
import 'package:flutter_gallery_next/biz/user_info/vm/user_info_view_model.dart';
import 'package:get/get.dart';

class UserInfoPage extends BaseStatefulPage {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  BaseState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends BaseState<UserInfoViewModel, UserInfoPage> {
  @override
  String titleString() {
    return "UserInfo";
  }

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => UserInfoViewModel());
    Get.lazyPut(() => UserInfoService());
  }

  @override
  void dispose() {
    Get.delete<UserInfoViewModel>();
    Get.delete<UserInfoService>();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    return AutoLoadWidget(
      viewMode: viewMode,
      rxResponse: viewMode.userInfoState.rxUserInfo,
      widget: (data) {
        return Container(
          padding: const EdgeInsetsDirectional.all(20),
          child: Text("userInfo=${data.toString()}"),
        );
      },
    );
  }
}
