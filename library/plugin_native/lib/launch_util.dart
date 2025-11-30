import 'package:flutter/cupertino.dart';
import 'package:package_base/common_constants.dart';
import 'package:plugin_native/device/device_util.dart';
import 'package:plugin_native/plugin_native.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUtil {
  LaunchUtil._private();

  factory LaunchUtil.instance() => _instance;
  static final LaunchUtil _instance = LaunchUtil._private();

  Future<bool> isLaunchExternalApp({required String packageName, required String activityName}) async {
    return await PluginNative.isLaunchExternalApp(packageName: packageName, activityName: activityName);
  }

  Future<void> launchExternalApp({required String packageName, required String activityName}) async {
    await PluginNative.launchExternalApp(packageName: packageName, activityName: activityName);
  }

  void launchApp({
    required String appName,
    required String packageName,
    required String activityName,
    required String urlScheme,
    required String appId,
  }) {
    if (DeviceUtil.isAndroid()) {
      _launchAndroidApp(appName: appName, packageName: packageName, activityName: activityName);
    } else if (DeviceUtil.isIOS()) {
      _launchIosApp(appName: appName, urlScheme: urlScheme, appId: appId);
    }
  }

  void _launchAndroidApp({required String appName, required String packageName, required String activityName}) async {
    if (await isLaunchExternalApp(packageName: packageName, activityName: activityName)) {
      launchExternalApp(packageName: packageName, activityName: activityName);
    } else {
      String googlePlayStoreUrl = '${AppStoreAddress.appStore}$packageName';
      debugPrint("$appName is not installed： $googlePlayStoreUrl");
    }
  }

  Future<void> _launchIosApp({required String appName, required String urlScheme, required String appId}) async {
    final Uri url = Uri.parse(urlScheme);
    if (await canLaunchUrl(url)) {
      launchUrl(url);
    } else {
      String appStoreUrl = '${AppStoreAddress.appStore}$appId';
      debugPrint("$appName is not installed： $appStoreUrl");
    }
  }
}
