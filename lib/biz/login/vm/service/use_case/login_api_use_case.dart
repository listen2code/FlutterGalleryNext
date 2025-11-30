import 'package:flutter_gallery_next/base/common/event_bus/event_bus.dart';
import 'package:flutter_gallery_next/base/common/event_bus/event_bus_key.dart';
import 'package:flutter_gallery_next/base/network/base/session_info.dart';
import 'package:flutter_gallery_next/base/network/base_network.dart';
import 'package:flutter_gallery_next/biz/login/model/login_entity.dart';
import 'package:package_libs/utils/logger_util.dart';
import 'package:package_libs/utils/profile_util.dart';
import 'package:plugin_native/device/device_util.dart';

enum LoginType { login, reLogin }

class LoginAPIUseCase extends BaseLoginUseCase<LoginEntity, LoginRequest> {
  @override
  String getPath(LoginRequest? request) {
    return "/v1/login";
  }

  Future<ResponseEntity<LoginEntity>> autoLogin() async {
    var local = await ProfileUtil().loadLoginSetting();
    return post(LoginRequest(
      userName: local.userName ?? "",
      password: local.passwd ?? "",
      deviceId: await getDeviceId(),
      deviceType: DeviceType.getDeviceType(),
      appVersion: await getAppVersion(),
    )).then((value) {
      setSessionInfo(value, LoginType.reLogin);
      return value;
    });
  }

  Future<ResponseEntity<LoginEntity>> login(LoginRequest? request, LoginType loginType) async {
    request?.deviceId = await getDeviceId();
    request?.deviceType = DeviceType.getDeviceType();
    request?.appVersion = await getAppVersion();
    return post(request).then((value) {
      setSessionInfo(value, loginType);
      return value;
    });
  }

  void setSessionInfo(ResponseEntity<LoginEntity> loginEntity, LoginType loginType) async {
    if (loginEntity.result == APIResult.success) {
      SessionInfo().setSessionInfo(loginEntity.body);
      loginNotification(loginType);
    }
  }

  void loginNotification(LoginType loginType) {
    String event;
    String key;
    switch (loginType) {
      case LoginType.login:
        event = EventBusKeys.login;
        key = EventBusKeys.login;
        break;
      case LoginType.reLogin:
        event = EventBusKeys.reLogin;
        key = EventBusKeys.reLogin;
        break;
    }
    log("login type:$loginType", type: LoggerType.debug);
    EventBus.defaultBus().post<String>(event: event, key: key);
  }

  void logoutNotification() {
    EventBus.defaultBus().post<String>(event: EventBusKeys.logout, key: EventBusKeys.logout);
  }

  Future<String> getAppVersion() async {
    return DeviceUtil.instance().getAppVersionName() ?? "";
  }

  Future<String?> getDeviceId() async {
    // todo
    // if (await NotificationService.instance.requestPermission()) {
    //   // プッシュ通知権限リクエストを承認された／されている場合はトークンを取得する
    //   token = await NotificationService.instance.getFirebaseToken();
    // }
    return DeviceUtil.instance().getUUID();
  }
}

class LoginRequest implements BaseRequest {
  String userName;
  String password;
  String? deviceId;
  String? deviceType;
  String? appVersion;

  LoginRequest({
    required this.userName,
    required this.password,
    this.deviceId,
    this.deviceType,
    this.appVersion,
  });

  @override
  Map<String, dynamic>? getParameters() {
    Map<String, dynamic> result = {
      "userName": userName,
      "password": password,
      "deviceId": deviceId,
      "deviceType": deviceType,
      "appVersion": appVersion,
    };
    return result;
  }
}
