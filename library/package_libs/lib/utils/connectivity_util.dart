import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectType { wifi, mobile, unknow }

class ConnectivityUtil {
  ConnectivityUtil._private();

  static final ConnectivityUtil _instance = ConnectivityUtil._private();

  factory ConnectivityUtil.instance() => _instance;

  Future<ConnectType> getStatus() async {
    List<ConnectivityResult> connectivityResult = await Connectivity().checkConnectivity();

    switch (connectivityResult.first) {
      case ConnectivityResult.wifi:
        return ConnectType.wifi;
      case ConnectivityResult.mobile:
        return ConnectType.mobile;
      case ConnectivityResult.none:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.vpn:
      case ConnectivityResult.other:
      case ConnectivityResult.satellite:
        return ConnectType.unknow;
    }
  }

  Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.first != ConnectivityResult.none;
  }

  Stream<ConnectivityResult> get onConnectivityChanged {
    return Connectivity().onConnectivityChanged.map((list) => list.first);
  }
}
