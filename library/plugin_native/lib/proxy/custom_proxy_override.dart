import 'dart:io';

import 'package:package_libs/utils/logger_util.dart';
import 'package:plugin_native/proxy/proxy_info.dart';
import 'package:plugin_native/proxy/proxy_util.dart';

class CustomProxyHttpOverride extends HttpOverrides {
  CustomProxyHttpOverride.withProxy();

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        LoggerUtil.loggerWithType("HttpOverride findProxy start=$uri", type: LoggerType.easy);
        ProxyInfo proxyInfo = ProxyUtil.instance.findProxySync(uri);
        if (proxyInfo.isProxy) {
          final proxyString = proxyInfo.toString();
          LoggerUtil.loggerWithType("HttpOverride findProxy uri=$uri $proxyString", type: LoggerType.easy);
          return proxyString;
        } else {
          LoggerUtil.loggerWithType("HttpOverride findProxy DIRECT: $uri", type: LoggerType.easy);
          return "DIRECT";
        }
      };
  }
}
