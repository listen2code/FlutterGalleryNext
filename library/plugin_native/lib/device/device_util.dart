import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_libs/utils/connectivity_util.dart';
import 'package:package_libs/utils/sp_util.dart';
import 'package:plugin_native/device/device_info.dart';
import 'package:plugin_native/plugin_native_platform_interface.dart';

class DeviceUtil {
  DeviceUtil._private();

  factory DeviceUtil.instance() => _instance;
  static final DeviceUtil _instance = DeviceUtil._private();
  DeviceInfo? _deviceInfo;
  late String appName;

  Future init({required String appName}) async {
    this.appName = appName;
    _deviceInfo ??= await PluginNativePlatform.instance.getDeviceInfo();
    debugPrint("DeviceUtil init: $_deviceInfo");
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
    return Future.value(_deviceInfo?.uuid ?? "");
  }

  Future<String> getUserAgent() async {
    StringBuffer sb = StringBuffer("$appName/");
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
    sb.write("netWorkStatus=${await ConnectivityUtil.instance().getStatus()}");
    sb.write("uid=${await getUUID()}");
    sb.write(")");
    return Future.value(sb.toString());
  }

  static bool isIOS() {
    return Platform.isIOS;
  }

  static bool isAndroid() {
    return Platform.isAndroid;
  }

  static void setPortrait(bool isLandscape) async {
    if (isIOS()) {
      // todo
      var platform = const MethodChannel("com.xxxx.plugin/set_portrait");
      await platform.invokeListMethod("setPortrait", {"isLandscape": isLandscape});
    }
  }
}

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
