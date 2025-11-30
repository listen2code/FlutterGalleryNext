import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_native/device/device_info.dart';
import 'package:plugin_native/device/device_util.dart';
import 'package:plugin_native/plugin_native_method_channel.dart';
import 'package:plugin_native/plugin_native_platform_interface.dart';
import 'package:plugin_native/proxy/proxy_info.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPluginNativePlatform with MockPlatformInterfaceMixin implements PluginNativePlatform {
  @override
  Future<DeviceInfo?> getDeviceInfo() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isLaunchExternalApp({required String packageName, required String activityName}) {
    throw UnimplementedError();
  }

  @override
  Future<void> launchExternalApp({required String packageName, required String activityName}) {
    throw UnimplementedError();
  }

  @override
  Future<ProxyInfo?> findProxy(String string) {
    throw UnimplementedError();
  }

  @override
  Future<ProxyInfo?> getProxyInfo() {
    throw UnimplementedError();
  }
}

void main() {
  final PluginNativePlatform initialPlatform = PluginNativePlatform.instance;

  test('$MethodChannelPluginNative is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPluginNative>());
  });

  test('getDeviceInfo', () async {
    MockPluginNativePlatform fakePlatform = MockPluginNativePlatform();
    PluginNativePlatform.instance = fakePlatform;
    await DeviceUtil.instance().init(appName: "appName");
    expect(DeviceUtil.instance().getDeviceVersion(), '42');
  });
}
