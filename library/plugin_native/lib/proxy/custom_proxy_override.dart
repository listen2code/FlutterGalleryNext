import 'dart:io';

import 'package:package_libs/utils/logger_util.dart';
import 'package:plugin_native/proxy/proxy_info.dart';
import 'package:plugin_native/proxy/proxy_util.dart';

class CustomProxyHttpOverride extends HttpOverrides {
  /// Initializer
  CustomProxyHttpOverride.withProxy();

  /// Override HTTP client creation
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        log("HttpOverride findProxy start=$uri");
        ProxyInfo? proxyInfo = ProxyUtil.instance().findProxySync(uri);
        if (proxyInfo?.type == "PROXY" && proxyInfo?.host.isNotEmpty == true && proxyInfo?.port.isNotEmpty == true) {
          log("HttpOverride findProxy uri=$uri ${proxyInfo.toString()}");
          return proxyInfo.toString();
        } else {
          log("HttpOverride findProxy DIRECT: $uri");
          return "DIRECT";
        }
      };
  }
}
