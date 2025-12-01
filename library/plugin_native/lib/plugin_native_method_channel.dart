import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
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
    final map = await deviceMethodChannel.invokeMapMethod<String, dynamic>("getDeviceInfo");
    return DeviceInfo(
      appName: map!["appName"],
      packageName: map["packageName"],
      appVersionName: map['appVersionName'],
      appVersionCode: map['appVersionCode'],
      model: map['model'],
      product: map['product'],
      deviceVersion: map['deviceVersion'],
      uuid: map['uuid'],
    );
  }

  @override
  Future<ProxyInfo?> getProxyInfo() async {
    final map = await proxyMethodChannel.invokeMapMethod<String, dynamic>("getProxyInfo");
    return ProxyInfo(
      host: map!["host"] ?? "",
      port: map["port"] ?? "",
      type: map["type"] ?? "",
      nonProxy: map["nonProxy"] ?? "",
    );
  }

  @override
  Future<ProxyInfo?> findProxy(String url) async {
    final map = await proxyMethodChannel.invokeMapMethod<String, dynamic>("findProxy", {"url": url});
    return ProxyInfo(
      host: map!["host"] ?? "",
      port: map["port"] ?? "",
      type: map["type"] ?? "",
    );
  }

  @override
  Future<bool> isLaunchExternalApp({required String packageName, required String activityName}) async {
    final map = await launchMethodChannel.invokeMapMethod<String, dynamic>("isLaunchExternalApp", {
      "packageName": packageName,
      "activityName": activityName,
    });
    return map!["isLaunchExternalApp"];
  }

  @override
  Future<void> launchExternalApp({required String packageName, required String activityName}) async {
    await launchMethodChannel.invokeMapMethod<String, dynamic>("launchExternalApp", {
      "packageName": packageName,
      "activityName": activityName,
    });
  }
}
