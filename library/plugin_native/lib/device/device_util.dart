import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:package_libs/utils/sp_util.dart';
import 'package:plugin_native/device/device_info_data.dart';

class DeviceUtil {
  DeviceUtil._private();

  factory DeviceUtil.instance() => _instance;
  static final DeviceUtil _instance = DeviceUtil._private();
  DeviceInfo? _deviceInfo;

  Future init() async {
    // todo
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

  Future<String> getNetworkStatus() async {
    List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    switch (connectivityResult.first) {
      case ConnectivityResult.wifi:
        return Future.value("WiFi");
      case ConnectivityResult.mobile:
        return Future.value("Mobile");
      case ConnectivityResult.none:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.vpn:
      case ConnectivityResult.other:
        return Future.value("UNKNOWN");
    }
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
    sb.write("netWorkStatus=${await getNetworkStatus()}");
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

  /// 画面分の横縦設定(デバイスレベル)
  ///
  static void setPortrait(bool isLandscape) async {
    if (isIOS()) {
      // tod
      var platform = const MethodChannel("com.xxxx.plugin/set_portrait");
      await platform.invokeListMethod("setPortrait", {"isLandscape": isLandscape});
    }
  }
}
