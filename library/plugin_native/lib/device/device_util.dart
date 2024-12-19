import 'dart:io';

import 'package:package_libs/utils/sp_util.dart';
import 'package:plugin_native/device/device_info_data.dart';

class DeviceUtil {
  DeviceUtil._private();

  factory DeviceUtil.instance() => _instance;
  static final DeviceUtil _instance = DeviceUtil._private();
  DeviceInfo? _deviceInfo;

  Future init() async {
    // _deviceInfo ??= await DevicePlugin.getDeviceInfo();
  }

  String? getAppName() {
    return _deviceInfo?.appName;
  }

  String? getPackageName() {
    return _deviceInfo?.packageName;
  }

  String? getAppVersionName() {
    return _deviceInfo?.appVersionName;
  }

  String? getAppVersionCode() {
    return _deviceInfo?.appVersionCode;
  }

  String? getModelName() {
    return _deviceInfo?.model;
  }

  String? getProductName() {
    return _deviceInfo?.product;
  }

  String? getDeviceVersion() {
    return _deviceInfo?.deviceVersion;
  }

  Future<String>? getUUID() async {
    String? uuid = await SpUtil.instance().getStringAsync(SpKey.uuid);
    if (uuid.isNotEmpty == true) {
      return Future.value(uuid);
    }
    SpUtil.instance().set(SpKey.uuid, _deviceInfo?.uuid);
    return Future.value(_deviceInfo?.uuid);
  }

  Future<String> getUserAgent() async {
    StringBuffer sb = StringBuffer("flutter_gallery/");
    if (Platform.isIOS) {
      sb.write("${getAppVersionName()}i(");
    } else if (Platform.isAndroid) {
      sb.write("${getAppVersionName()}A(");
    } else {
      sb.write("${getAppVersionName()}(");
    }
    sb.write("${getModelName()}/");
    sb.write("${getProductName()}; ");
    if (Platform.isIOS) {
      sb.write("iOS/");
    } else if (Platform.isAndroid) {
      sb.write("Android/");
    } else {
      sb.write("other/");
    }
    sb.write("${getDeviceVersion()}");
    sb.write(";");
    sb.write("uid=${await getUUID()}");
    sb.write(")");
    return Future.value(sb.toString());
  }
}
