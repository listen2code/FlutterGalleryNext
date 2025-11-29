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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => LoginViewMode());
    Get.lazyPut(() => LoginService());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    Get.delete<LoginViewMode>();
    Get.delete<LoginService>();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
            ),
            obscureText: true, // Hide password text
          ),
          const SizedBox(height: 24.0),
          ElevatedButton(
            onPressed: () {
              viewMode.doLogin(
                username: _usernameController.text,
                password: _passwordController.text,
              );
            },
            child: const Text("Login"),
          ),
          const SizedBox(height: 40.0),
          AutoLoadWidget(
            viewMode: viewMode,
            rxResponse: viewMode.loginState.rxLogin,
            widget: (data) {
              return Center(
                child: Text("userId=${data.id}, userName=${data.name}"),
              );
            },
          ),
        ],
      ),
    );
  }
}
