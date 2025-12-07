class ProxyInfo {
  ProxyInfo({
    this.host = "",
    this.port = "",
    this.type = "DIRECT",
    this.nonProxy = "",
  });

  final String host;
  final String port;
  final String type;
  final String nonProxy;

  bool get isProxy => type == "PROXY" && host.isNotEmpty && port.isNotEmpty;

  factory ProxyInfo.fromJson(Map<String, dynamic> json) {
    return ProxyInfo(
      host: json['host'] ?? '',
      port: json['port'] ?? '',
      type: json['type'] ?? 'DIRECT',
      nonProxy: json['nonProxy'] ?? '',
    );
  }

  @override
  String toString() {
    if (isProxy) {
      return "PROXY $host:$port";
    }
    return "DIRECT";
  }
}
