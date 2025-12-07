import 'dart:async';
import 'dart:io';

import 'package:package_libs/utils/logger_util.dart';
import 'package:plugin_native/plugin_native_platform_interface.dart';
import 'package:plugin_native/proxy/custom_proxy_override.dart';
import 'package:plugin_native/proxy/proxy_info.dart';

class ProxyUtil {
  static const String tag = "ProxyUtil";

  ProxyUtil._private();

  static final ProxyUtil instance = ProxyUtil._private();

  ProxyInfo? _proxyFromNative;

  final ProxyInfo _proxyDirect = ProxyInfo(type: "DIRECT");

  final Map<String?, ProxyInfo?> _proxyCache = {};

  Future<void> init() async {
    _proxyFromNative ??= await PluginNativePlatform.instance.getProxyInfo();
    LoggerUtil.loggerWithType("$tag enabled proxy($_proxyFromNative): ${_proxyEnabled()}", type: LoggerType.easy);
    if (_proxyEnabled()) {
      LoggerUtil.loggerWithType(
          "$tag init proxy: ${_proxyFromNative?.host}:${_proxyFromNative?.port} ${_proxyFromNative?.nonProxy}",
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

  bool _proxyEnabled() {
    final info = _proxyFromNative;
    if (info == null) return false;

    if (Platform.isIOS && info.type == "AUTO") {
      return true;
    }
    return info.host.isNotEmpty && info.port.isNotEmpty && (int.tryParse(info.port) ?? 0) > 0;
  }

  ProxyInfo findProxySync(Uri? uri) {
    if (_proxyEnabled() == false) {
      LoggerUtil.loggerWithType("$tag findProxySync proxyEnabled=false", type: LoggerType.easy);
      return _proxyDirect;
    }
    if (uri?.host == null || uri!.host.isEmpty) {
      LoggerUtil.loggerWithType("$tag findProxySync uri?.host is empty", type: LoggerType.easy);
      return _proxyDirect;
    }
    ProxyInfo? proxyInfo = _proxyCache[uri.host];
    if (proxyInfo != null) {
      LoggerUtil.loggerWithType("$tag findProxySync from cache uri=$uri proxyInfo=${proxyInfo.toString()}",
          type: LoggerType.easy);
      return proxyInfo;
    }
    LoggerUtil.loggerWithType("$tag findProxySync from direct", type: LoggerType.easy);
    return _proxyDirect;
  }

  Future<ProxyInfo> findProxyAsync(Uri? uri) async {
    if (_proxyEnabled() == false) {
      LoggerUtil.loggerWithType("$tag findProxyAsync proxyEnabled=false", type: LoggerType.easy);
      return _proxyDirect;
    }
    if (uri?.host == null || uri!.host.isEmpty) {
      LoggerUtil.loggerWithType("$tag findProxyAsync uri?.host is empty", type: LoggerType.easy);
      return _proxyDirect;
    }
    ProxyInfo? proxyInfo = _proxyCache[uri.host];
    if (proxyInfo != null) {
      LoggerUtil.loggerWithType("$tag findProxyAsync from cache uri=$uri proxyInfo=${proxyInfo.toString()}",
          type: LoggerType.easy);
      return proxyInfo;
    }
    proxyInfo = await PluginNativePlatform.instance.findProxy(uri.toString());
    LoggerUtil.loggerWithType("$tag findProxyAsync from native uri=$uri proxyInfo=${proxyInfo?.toString()}",
        type: LoggerType.easy);
    proxyInfo ??= _proxyDirect;
    _proxyCache[uri.host] = proxyInfo;
    LoggerUtil.loggerWithType("$tag findProxyAsync add cache host=${uri.host}\ncurrent cache$_proxyCache", type: LoggerType.easy);
    return proxyInfo;
  }
}
