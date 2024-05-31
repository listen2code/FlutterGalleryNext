import 'dart:io';

import 'package:flutter/widgets.dart';

/// This class overrides the global proxy settings.
class CustomNoProxyHttpOverride extends HttpOverrides {
  /// The entire proxy server
  /// Format: "localhost:8888"
  final String proxyString;

  /// Set this to true
  /// - Warning: Setting this to true in production apps can be dangerous. Use with care!
  final bool allowBadCertificates;

  /// Initializer
  CustomNoProxyHttpOverride.withProxy(
    this.proxyString, {
    this.allowBadCertificates = false,
  });

  /// Override HTTP client creation
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        // assert(this.proxyString.isNotEmpty,
        //     'You must set a valid proxy if you enable it!');
        // return "PROXY " + this.proxyString + ";";
        String findProxy = HttpClient.findProxyFromEnvironment(uri, environment: {"http_proxy": proxyString, "no_proxy": "16.0.1,[192.168.0.10]"});
        debugPrint("findProxy=$findProxy uri=$uri");
        return findProxy;
      };
/*      ..badCertificateCallback = this.allowBadCertificates
          ? (X509Certificate cert, String host, int port) => true
          : null;*/
  }
}
