import 'package:package_base/common_constants.dart';
import 'package:package_libs/utils/logger_util.dart';
import 'package:plugin_native/device/device_util.dart';
import 'package:plugin_native/plugin_native_platform_interface.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUtil {
  LaunchUtil._private();

  static LaunchUtil get instance => _instance;
  static final LaunchUtil _instance = LaunchUtil._private();

  Future<bool> isLaunchExternalApp({required String packageName, required String activityName}) {
    return PluginNativePlatform.instance.isLaunchExternalApp(packageName: packageName, activityName: activityName);
  }

  Future<void> launchExternalApp({required String packageName, required String activityName}) {
    return PluginNativePlatform.instance.launchExternalApp(packageName: packageName, activityName: activityName);
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
    try {
      if (await isLaunchExternalApp(packageName: packageName, activityName: activityName)) {
        await launchExternalApp(packageName: packageName, activityName: activityName);
      } else {
        String googlePlayStoreUrl = '${AppStoreAddress.appStore}$packageName';
        LoggerUtil.loggerWithType("$appName is not installed. Opening Store: $googlePlayStoreUrl", type: LoggerType.easy);
        final Uri storeUri = Uri.parse(googlePlayStoreUrl);
        if (await canLaunchUrl(storeUri)) {
          await launchUrl(storeUri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e, t) {
      LoggerUtil.error("Failed to launch Android app $packageName", error: e, stackTrace: t);
    }
  }

  Future<void> _launchIosApp({required String appName, required String urlScheme, required String appId}) async {
    try {
      final Uri url = Uri.parse(urlScheme);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        String appStoreUrl = '${AppStoreAddress.appStore}$appId';
        LoggerUtil.loggerWithType("$appName is not installed. Opening Store: $appStoreUrl", type: LoggerType.easy);
        final Uri storeUri = Uri.parse(appStoreUrl);
        if (await canLaunchUrl(storeUri)) {
          await launchUrl(storeUri);
        }
      }
    } catch (e, t) {
      LoggerUtil.error("Failed to launch iOS app with scheme $urlScheme", error: e, stackTrace: t);
    }
  }
}
