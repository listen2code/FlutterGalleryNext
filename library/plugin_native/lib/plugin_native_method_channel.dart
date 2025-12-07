import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:package_libs/utils/logger_util.dart';
import 'package:plugin_native/device/device_info.dart';
import 'package:plugin_native/proxy/proxy_info.dart';

import 'plugin_native_platform_interface.dart';

/// An implementation of [PluginNativePlatform] that uses method channels.
class MethodChannelPluginNative extends PluginNativePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final deviceMethodChannel = const MethodChannel('com.listen.plugin.plugin_native/device_info');
  @visibleForTesting
  final proxyMethodChannel = const MethodChannel('com.listen.plugin.plugin_native/proxy_info');
  @visibleForTesting
  final launchMethodChannel = const MethodChannel('com.listen.plugin.plugin_native/launch_app');

  @override
  Future<DeviceInfo?> getDeviceInfo() async {
    try {
      final map = await deviceMethodChannel.invokeMapMethod<String, dynamic>("getDeviceInfo");
      if (map != null) {
        return DeviceInfo.fromJson(map);
      }
    } on PlatformException catch (e, t) {
      LoggerUtil.error("getDeviceInfo failed", error: e, stackTrace: t);
    }
    return null;
  }

  @override
  Future<ProxyInfo?> getProxyInfo() async {
    try {
      final map = await proxyMethodChannel.invokeMapMethod<String, dynamic>("getProxyInfo");
      if (map != null) {
        return ProxyInfo.fromJson(map);
      }
    } on PlatformException catch (e, t) {
      LoggerUtil.error("getProxyInfo failed", error: e, stackTrace: t);
    }
    return null;
  }

  @override
  Future<ProxyInfo?> findProxy(String url) async {
    try {
      final map = await proxyMethodChannel.invokeMapMethod<String, dynamic>("findProxy", {"url": url});
      if (map != null) {
        return ProxyInfo.fromJson(map);
      }
    } on PlatformException catch (e, t) {
      LoggerUtil.error("findProxy for $url failed", error: e, stackTrace: t);
    }
    return null;
  }

  @override
  Future<bool> isLaunchExternalApp({required String packageName, required String activityName}) async {
    try {
      final map = await launchMethodChannel.invokeMapMethod<String, dynamic>("isLaunchExternalApp", {
        "packageName": packageName,
        "activityName": activityName,
      });
      return map?['isLaunchExternalApp'] ?? false;
    } on PlatformException catch (e, t) {
      LoggerUtil.error("isLaunchExternalApp for $packageName failed", error: e, stackTrace: t);
    }
    return false;
  }

  @override
  Future<void> launchExternalApp({required String packageName, required String activityName}) async {
    try {
      await launchMethodChannel.invokeMapMethod<String, dynamic>("launchExternalApp", {
        "packageName": packageName,
        "activityName": activityName,
      });
    } on PlatformException catch (e, t) {
      LoggerUtil.error("launchExternalApp for $packageName failed", error: e, stackTrace: t);
    }
  }
}
