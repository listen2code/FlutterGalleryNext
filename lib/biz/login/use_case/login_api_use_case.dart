import 'dart:io';

import 'package:flutter_gallery_next/base/common/event_bus/event_bus.dart';
import 'package:flutter_gallery_next/base/common/event_bus/event_bus_key.dart';
import 'package:flutter_gallery_next/base/network/base/base_api_use_case.dart';
import 'package:flutter_gallery_next/base/network/base/base_login_use_case.dart';
import 'package:flutter_gallery_next/base/network/base/session_info.dart';
import 'package:flutter_gallery_next/biz/login/model/login_entity.dart';
import 'package:flutter_gallery_next/biz/login/use_case/visitor_api_use_case.dart';
import 'package:package_libs/utils/http_util.dart';
import 'package:package_libs/utils/logger_util.dart';
import 'package:package_libs/utils/profile_util.dart';
import 'package:plugin_native/device/device_util.dart';

class LoginAPIUseCase extends BaseLoginUseCase<LoginEntity, LoginRequest> {
  @override
  String getPath(LoginRequest? request) {
    return "/v1/login";
  }

  Future<ResponseEntity<LoginEntity>> autoLogin() async {
    // ローカルデータから取得
    var local = await ProfileUtil().loadLoginSettingInfo();
    String loginId = local.loginId ?? "";
    String loginPwd = local.passwd ?? "";
    // todo
    String? deviceId = await getDeviceId();
    String deviceType = DeviceType.getDeviceType();
    String appVersion = await getAppVersion();
    return post(LoginRequest(loginId, loginPwd)).then((value) {
      setSessionInfo(value, LoginType.reLogin);
      return value;
    });
  }

  Future<ResponseEntity<LoginEntity>> login(
    LoginRequest? memberLoginRequest,
    LoginType loginType,
  ) {
    return post(memberLoginRequest).then((value) {
      setSessionInfo(value, loginType);
      return value;
    });
  }

  void setSessionInfo(
      ResponseEntity<LoginEntity> loginEntity, LoginType loginType) async {
    if (loginEntity.result == APIResult.success) {
      SessionInfo().loginInfo = loginEntity.body;
      loginNotification(loginType);
    }
  }

  Future<ResponseEntity<void>> visitorLogin() async {
    var loginUseCase = VisitorAPIUseCase();
    String version = await getAppVersion();
    return loginUseCase.post(VisitorRequest(version));
  }

  void loginNotification(LoginType loginType) {
    String event;
    String key;
    switch (loginType) {
      case LoginType.genLogin:
        event = EventBusKeys.login;
        key = EventBusKeys.login;
        break;
      case LoginType.reLogin:
        event = EventBusKeys.reLogin;
        key = EventBusKeys.reLogin;
        break;
    }
    log("login type:$loginType", type: LoggerType.debug);
    EventBus.defaultBus().post<String>(
      event: event,
      key: key,
    );
  }

  void logoutNotification() {
    EventBus.defaultBus()
        .post<String>(event: EventBusKeys.logout, key: EventBusKeys.logout);
  }

  Future<String> getAppVersion() async {
    await deviceUtilInit();
    return DeviceUtil.instance().getAppVersionName() ?? "";
  }

  Future<void> deviceUtilInit() async {
    await DeviceUtil.instance().init();
  }

  Future<String?> getDeviceId() async {
    String? token;
    // todo
    // if (await NotificationService.instance.requestPermission()) {
    //   // プッシュ通知権限リクエストを承認された／されている場合はトークンを取得する
    //   token = await NotificationService.instance.getFirebaseToken();
    // }
    return token;
  }
}

/// 要求用モデル
class LoginRequest implements IRequest {
  String userName;
  String password;

  LoginRequest(this.userName, this.password);

  @override
  Map<String, dynamic>? getParameters() {
    Map<String, dynamic> result = {
      "userName": userName,
      "password": password,
    };
    return result;
  }
}

enum LoginType { genLogin, reLogin }

class DeviceType {
  DeviceType._private();

  static const String iOS = "1";

  static const String android = "2";

  static String getDeviceType() {
    if (Platform.isAndroid) {
      return android;
    } else if (Platform.isIOS) {
      return iOS;
    } else {
      throw Exception("not support DeviceType");
    }
  }
}
