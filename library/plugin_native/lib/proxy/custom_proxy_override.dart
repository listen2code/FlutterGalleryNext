import 'dart:io';

import 'package:package_libs/utils/logger_util.dart';
import 'package:plugin_native/proxy/proxy_info_data.dart';
import 'package:plugin_native/proxy/proxy_util.dart';

class CustomProxyHttpOverride extends HttpOverrides {
  /// Initializer
  CustomProxyHttpOverride.withProxy();

  /// Override HTTP client creation
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        LoggerUtil.log("HttpOverride findProxy start=$uri", type: LoggerType.debug);
        ProxyInfo? proxyInfo = ProxyUtil.instance().findProxySync(uri);
        if (proxyInfo?.type == "PROXY" && proxyInfo?.host.isNotEmpty == true && proxyInfo?.port.isNotEmpty == true) {
          LoggerUtil.log("HttpOverride findProxy uri=$uri ${proxyInfo.toString()}", type: LoggerType.debug);
          return proxyInfo.toString();
        } else {
          LoggerUtil.log("HttpOverride findProxy DIRECT: $uri", type: LoggerType.debug);
          return "DIRECT";
        }
      };
  }
}
