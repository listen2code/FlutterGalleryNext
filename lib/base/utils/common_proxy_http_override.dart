import 'dart:io';

/// This class overrides the global proxy settings.
class CommonProxyHttpOverride extends HttpOverrides {
  /// The entire proxy server
  /// Format: "localhost:8888"
  final String proxyString;

  /// Set this to true
  /// - Warning: Setting this to true in production apps can be dangerous. Use with care!
  final bool allowBadCertificates;

  /// Initializer
  CommonProxyHttpOverride.withProxy(
    this.proxyString, {
    this.allowBadCertificates = false,
  });

  /// Override HTTP client creation
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        return "DIRECT";
      };
  }
}
