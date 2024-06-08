import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'plugin_proxy_method_channel.dart';

abstract class PluginProxyPlatform extends PlatformInterface {
  /// Constructs a PluginProxyPlatform.
  PluginProxyPlatform() : super(token: _token);

  static final Object _token = Object();

  static PluginProxyPlatform _instance = MethodChannelPluginProxy();

  /// The default instance of [PluginProxyPlatform] to use.
  ///
  /// Defaults to [MethodChannelPluginProxy].
  static PluginProxyPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PluginProxyPlatform] when
  /// they register themselves.
  static set instance(PluginProxyPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
