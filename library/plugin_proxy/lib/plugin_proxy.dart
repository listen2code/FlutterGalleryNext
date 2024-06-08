
import 'plugin_proxy_platform_interface.dart';

class PluginProxy {
  Future<String?> getPlatformVersion() {
    return PluginProxyPlatform.instance.getPlatformVersion();
  }
}
