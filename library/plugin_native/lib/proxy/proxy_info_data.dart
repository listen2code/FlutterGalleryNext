class ProxyInfo {
  ProxyInfo({
    this.host = "",
    this.port = "",
    this.type = "DIRECT",
    this.nonProxy = "",
  });

  final String host;

  final String port;

  /// デバイスのtype PROXY:プロキシを使用 DIRECT:プロキシを不使用
  final String type;

  final String nonProxy;

  @override
  String toString() {
    if ("DIRECT" == type) {
      return "DIRECT";
    }
    String result = host;
    if (port.isNotEmpty == true) result += ":$port";
    return "PROXY $result;";
  }
}
