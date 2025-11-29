import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/mvvm/view/auto_load_widget.dart';
import 'package:flutter_gallery_next/base/mvvm/view/base_stateful_page.dart';
import 'package:flutter_gallery_next/biz/login/login_view_model.dart';
import 'package:flutter_gallery_next/biz/login/service/login_service.dart';
import 'package:get/get.dart';

class LoginPage extends BaseStatefulPage {
  const LoginPage({Key? key}) : super(key: key);

  @override
  BaseState createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginViewMode, LoginPage> {
  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => LoginViewMode());
    Get.lazyPut(() => LoginService());
  }

  @override
  void dispose() {
    super.dispose();
    Get.delete<LoginViewMode>();
    Get.delete<LoginService>();
  }

  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: viewMode.doLogin,
            child: const Text("login"),
          ),
          AutoLoadWidget(
            viewMode: viewMode,
            rxResponse: viewMode.loginState.rxLogin,
            widget: (data) {
              return Text("id=${data.id} name=${data.name}");
            },
          ),
        ],
      ),
    );
  }
}
