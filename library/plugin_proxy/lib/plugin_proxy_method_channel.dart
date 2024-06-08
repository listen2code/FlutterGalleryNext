import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'plugin_proxy_platform_interface.dart';

/// An implementation of [PluginProxyPlatform] that uses method channels.
class MethodChannelPluginProxy extends PluginProxyPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('plugin_proxy');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
