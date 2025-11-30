import 'dart:async';
import 'dart:io';

import 'package:package_libs/utils/logger_util.dart';
import 'package:plugin_native/plugin_native_platform_interface.dart';
import 'package:plugin_native/proxy/custom_proxy_override.dart';
import 'package:plugin_native/proxy/proxy_info.dart';

class ProxyUtil {
  static const String tag = "ProxyUtil";

  ProxyUtil._private();

  factory ProxyUtil.instance() => _instance;
  static final ProxyUtil _instance = ProxyUtil._private();

  ProxyInfo? _proxyFromNative;

  final ProxyInfo _proxyDirect = ProxyInfo(type: "DIRECT");

  final Map<String?, ProxyInfo?> _proxyCache = {};

  Future init() async {
    _proxyFromNative ??= await PluginNativePlatform.instance.getProxyInfo();
    log("$tag enabled proxy: ${proxyEnabled()}");
    if (proxyEnabled()) {
      log("$tag init proxy: ${_proxyFromNative?.host}:${_proxyFromNative?.port} ${_proxyFromNative?.nonProxy}",
          type: LoggerType.easy);
      HttpOverrides.global = CustomProxyHttpOverride.withProxy();
    }
  }

  String? getProxyHost() {
    return _proxyFromNative?.host;
  }

  String? getProxyPort() {
    return _proxyFromNative?.port;
  }

  String? getNonProxy() {
    return _proxyFromNative?.nonProxy;
  }

  bool proxyEnabled() {
    if (Platform.isIOS && _proxyFromNative?.type == "AUTO") {
      return true;
    }
    return _proxyFromNative?.host.isNotEmpty == true &&
        _proxyFromNative?.port.isNotEmpty == true &&
        (int.tryParse("${_proxyFromNative?.port}") ?? 0) > 0;
  }

  ProxyInfo? findProxySync(Uri? uri) {
    if (proxyEnabled() == false) {
      log("$tag findProxySync proxyEnabled=false");
      return _proxyDirect;
    }
    if (uri?.host == null || uri?.host.isEmpty == true) {
      log("$tag findProxySync uri?.host is empty");
      return _proxyDirect;
    }
    ProxyInfo? proxyInfo = _proxyCache[uri?.host];
    if (null != proxyInfo) {
      log("$tag findProxySync from cache uri=$uri proxyInfo=${proxyInfo.toString()}");
      return proxyInfo;
    }
    log("$tag findProxySync from direct");
    return _proxyDirect;
  }

  Future<ProxyInfo>? findProxyAsync(Uri? uri) async {
    if (proxyEnabled() == false) {
      log("$tag findProxyAsync proxyEnabled=false");
      return Future.value(_proxyDirect);
    }
    if (uri?.host == null || uri?.host.isEmpty == true) {
      log("$tag findProxyAsync uri?.host is empty");
      return Future.value(_proxyDirect);
    }
    ProxyInfo? proxyInfo = _proxyCache[uri?.host];
    if (null != proxyInfo) {
      log("$tag findProxyAsync from cache uri=$uri proxyInfo=${proxyInfo.toString()}");
      return Future.value(proxyInfo);
    }
    proxyInfo = await PluginNativePlatform.instance.findProxy(uri.toString());
    log("$tag findProxyAsync from native uri=$uri proxyInfo=${proxyInfo.toString()}");
    proxyInfo ??= _proxyDirect;
    _proxyCache[uri?.host] = proxyInfo;
    log("$tag findProxyAsync add cache host=${uri?.host}\ncurrent cache$_proxyCache");
    return Future.value(proxyInfo);
  }
}
