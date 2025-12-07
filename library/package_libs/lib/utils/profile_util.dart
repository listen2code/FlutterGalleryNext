import 'dart:convert';

import 'package:package_libs/utils/sp_util.dart';

class ProfileUtil {
  static final ProfileUtil _instance = ProfileUtil._internal();

  ProfileUtil._internal();

  static ProfileUtil get instance => _instance;

  static final SpUtil _spUtil = SpUtil.instance;

  static const String _loginSettingKey = 'login_setting_key';

  Future<LoginSettingEntity> loadLoginSetting() async {
    final jsonString = _spUtil.getString(_loginSettingKey);
    if (jsonString.isNotEmpty) {
      try {
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        return LoginSettingEntity.fromJson(jsonMap);
      } catch (e) {
        // If parsing fails, return a default entity
        return LoginSettingEntity();
      }
    }
    return LoginSettingEntity();
  }

  Future<void> saveLoginSettingInfo(LoginSettingEntity settingInfo) async {
    final jsonString = json.encode(settingInfo.toJson());
    await _spUtil.set(_loginSettingKey, jsonString);
  }
}

class LoginSettingEntity {
  final String userName;
  final String password;
  final bool userNameSave;
  final bool passwordSave;
  final bool autoLogin;

  LoginSettingEntity({
    this.userName = '',
    this.password = '',
    this.userNameSave = false,
    this.passwordSave = false,
    this.autoLogin = false,
  });

  factory LoginSettingEntity.fromJson(Map<String, dynamic> json) => LoginSettingEntity(
        userName: json['userName'] ?? '',
        password: json['password'] ?? '',
        userNameSave: json['userNameSave'] ?? false,
        passwordSave: json['passwordSave'] ?? false,
        autoLogin: json['autoLogin'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'userNameSave': userNameSave,
        'password': password,
        'passwordSave': passwordSave,
        'autoLogin': autoLogin,
      };
}
