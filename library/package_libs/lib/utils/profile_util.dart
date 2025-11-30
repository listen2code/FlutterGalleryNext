import 'package:package_libs/utils/sp_util.dart';

class ProfileUtil {
  static final ProfileUtil _instance = ProfileUtil._internal();

  factory ProfileUtil() => _instance;

  ProfileUtil._internal();

  static ProfileUtil get instance => _instance;

  static final SpUtil _spUtil = SpUtil.instance();

  Future<LoginSettingEntity> loadLoginSetting() async {
    return LoginSettingEntity()
      ..userName = await _spUtil.getStringAsync(SpKey.loginId)
      ..passwd = await _spUtil.getStringAsync(SpKey.password);
  }

  void saveLoginSettingInfo(LoginSettingEntity settingInfo) {
    _spUtil.set(SpKey.loginId, settingInfo.userName);
    _spUtil.set(SpKey.password, settingInfo.passwd);
  }
}

class LoginSettingEntity {
  String? userName = '';
  bool? loginIdSave = false;
  String? passwd = '';
  bool? passwdSave = false;
  bool? autoLogin = false;
  bool? canSetAutoLogin = false;
  bool? canLogin = false;
  bool? biometricAuth = false;

  LoginSettingEntity();
}
