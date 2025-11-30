import 'dart:async';
import 'dart:io';

import 'package:package_libs/utils/logger_util.dart';
import 'package:plugin_native/proxy/custom_proxy_override.dart';
import 'package:plugin_native/proxy/proxy_info_data.dart';

class ProxyUtil {
  ProxyUtil._private();

  factory ProxyUtil.instance() => _instance;
  static final ProxyUtil _instance = ProxyUtil._private();

  /// nativeからプロキシ情報
  ProxyInfo? _proxyFromNative;

  /// default:プロキシを使用しない
  final ProxyInfo _proxyDirect = ProxyInfo(type: "DIRECT");

  /// プロキシキャッシュ
  final Map<String?, ProxyInfo?> _proxyCache = {};

  Future init() async {
    // _proxyFromNative ??= await DevicePlugin.getProxyInfo();
    LoggerUtil.log("enabled proxy: ${proxyEnabled()}", type: LoggerType.easy);
    if (proxyEnabled()) {
      LoggerUtil.log("init proxy: ${_proxyFromNative?.host}:${_proxyFromNative?.port} ${_proxyFromNative?.nonProxy}",
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
      LoggerUtil.log("findProxySync proxyEnabled=false", type: LoggerType.easy);
      return _proxyDirect;
    }
    if (uri?.host == null || uri?.host.isEmpty == true) {
      LoggerUtil.log("findProxySync uri?.host is empty", type: LoggerType.easy);
      return _proxyDirect;
    }
    ProxyInfo? proxyInfo = _proxyCache[uri?.host];
    if (null != proxyInfo) {
      LoggerUtil.log("findProxySync from cache uri=$uri proxyInfo=${proxyInfo.toString()}", type: LoggerType.easy);
      return proxyInfo;
    }
    LoggerUtil.log("findProxySync from direct", type: LoggerType.easy);
    return _proxyDirect;
  }

  Future<ProxyInfo>? findProxyAsync(Uri? uri) async {
    if (proxyEnabled() == false) {
      LoggerUtil.log("findProxyAsync proxyEnabled=false", type: LoggerType.easy);
      return Future.value(_proxyDirect);
    }
    if (uri?.host == null || uri?.host.isEmpty == true) {
      LoggerUtil.log("findProxyAsync uri?.host is empty", type: LoggerType.easy);
      return Future.value(_proxyDirect);
    }
    ProxyInfo? proxyInfo = _proxyCache[uri?.host];
    if (null != proxyInfo) {
      LoggerUtil.log("findProxyAsync from cache uri=$uri proxyInfo=${proxyInfo.toString()}", type: LoggerType.easy);
      return Future.value(proxyInfo);
    }
    // todo
    // proxyInfo = await DevicePlugin.findProxy(uri.toString());
    LoggerUtil.log("findProxyAsync from native uri=$uri proxyInfo=${proxyInfo.toString()}", type: LoggerType.easy);
    proxyInfo ??= _proxyDirect;
    _proxyCache[uri?.host] = proxyInfo;
    LoggerUtil.log("findProxyAsync add cache host=${uri?.host}\ncurrent cache$_proxyCache", type: LoggerType.easy);
    return Future.value(proxyInfo);
  }
}
