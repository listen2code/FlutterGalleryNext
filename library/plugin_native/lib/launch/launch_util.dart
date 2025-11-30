import 'package:package_base/common_constants.dart';
import 'package:package_libs/utils/logger_util.dart';
import 'package:plugin_native/device/device_util.dart';
import 'package:plugin_native/plugin_native_platform_interface.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUtil {
  LaunchUtil._private();

  factory LaunchUtil.instance() => _instance;
  static final LaunchUtil _instance = LaunchUtil._private();

  Future<bool> isLaunchExternalApp({required String packageName, required String activityName}) async {
    return await PluginNativePlatform.instance.isLaunchExternalApp(packageName: packageName, activityName: activityName);
  }

  Future<void> launchExternalApp({required String packageName, required String activityName}) async {
    await PluginNativePlatform.instance.launchExternalApp(packageName: packageName, activityName: activityName);
  }

  Future<void> launchApp({
    required String appName,
    required String packageName,
    required String activityName,
    required String urlScheme,
    required String appId,
  }) async {
    if (DeviceUtil.isAndroid()) {
      await _launchAndroidApp(appName: appName, packageName: packageName, activityName: activityName);
    } else if (DeviceUtil.isIOS()) {
      await _launchIosApp(appName: appName, urlScheme: urlScheme, appId: appId);
    }
  }

  Future<void> _launchAndroidApp({required String appName, required String packageName, required String activityName}) async {
    if (await isLaunchExternalApp(packageName: packageName, activityName: activityName)) {
      await launchExternalApp(packageName: packageName, activityName: activityName);
    } else {
      String googlePlayStoreUrl = '${AppStoreAddress.appStore}$packageName';
      log("$appName is not installed： $googlePlayStoreUrl");
    }
  }

  Future<void> _launchIosApp({required String appName, required String urlScheme, required String appId}) async {
    final Uri url = Uri.parse(urlScheme);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      String appStoreUrl = '${AppStoreAddress.appStore}$appId';
      log("$appName is not installed： $appStoreUrl");
    }
  }
}
