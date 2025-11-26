import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/mvvm/view/auto_load_widget.dart';
import 'package:flutter_gallery_next/base/mvvm/view/base_stateless_page.dart';
import 'package:flutter_gallery_next/biz/login/login_view_model.dart';

class LoginPage extends BaseStatelessPage<LoginViewMode> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              viewMode.doLogin();
            },
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
