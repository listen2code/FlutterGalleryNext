import 'plugin_native_platform_interface.dart';

class PluginNative {
  Future<String?> getPlatformVersion() {
    return PluginNativePlatform.instance.getPlatformVersion();
  }

  static isLaunchExternalApp({required String packageName, required String activityName}) {
    // todo
  }

  static launchExternalApp({required String packageName, required String activityName}) {
    // todo
  }
}
