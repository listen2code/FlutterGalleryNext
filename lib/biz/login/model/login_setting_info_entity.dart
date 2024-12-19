import 'dart:convert';

import 'package:flutter_gallery_next/generated/json/base/json_field.dart';

@JsonSerializable()
class LoginSettingInfoEntity {
  @JSONField(name: "login_id")
  String? loginId = '';
  @JSONField(name: "login_id_save")
  bool? loginIdSave = false;
  String? passwd = '';
  @JSONField(name: "passwd_save")
  bool? passwdSave = false;
  @JSONField(name: "auto_login")
  bool? autoLogin = false;
  @JSONField(name: "can_set_auto_login")
  bool? canSetAutoLogin = false;
  @JSONField(name: "can_login")
  bool? canLogin = false;
  @JSONField(name: "biometric_auth")
  bool? biometricAuth = false;

  LoginSettingInfoEntity();

  @override
  String toString() {
    return jsonEncode(this);
  }
}
