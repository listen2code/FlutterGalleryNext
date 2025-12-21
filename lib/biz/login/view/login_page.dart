import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gallery_next/base/widget/base/auto_load_widget.dart';
import 'package:flutter_gallery_next/base/widget/base/base_stateful_page.dart';
import 'package:flutter_gallery_next/biz/login/vm/login_view_model.dart';
import 'package:flutter_gallery_next/biz/login/vm/service/login_service.dart';
import 'package:get/get.dart';

class LoginPage extends BaseStatefulPage {
  const LoginPage({Key? key}) : super(key: key);

  @override
  BaseState createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginViewModel, LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  String titleString() {
    return "Login";
  }

  @override
  void initState() {
    super.initState();
    Get.lazyPut(() => LoginViewModel());
    Get.lazyPut(() => LoginService());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    Get.delete<LoginViewModel>();
    Get.delete<LoginService>();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
          child: Text(
            'Env: ${dotenv.env['NAME'] ?? 'Not Found'}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54),
          ),
        ),
        Expanded(
          child: AutoLoadWidget(
            viewMode: viewMode,
            rxResponse: viewMode.loginState.rxLogin,
            widget: (data) {
              return Center(
                child: Text("userId=${data.userId}, userName=${data.name}"),
              );
            },
          ),
        ),
        Padding(
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
                obscureText: true,
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
              ElevatedButton(
                onPressed: viewMode.doLogout,
                child: const Text("logout"),
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ],
    );
  }
}
