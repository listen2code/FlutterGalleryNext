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
        return Future.value(ConnectType.wifi);
      case ConnectivityResult.mobile:
        return Future.value(ConnectType.mobile);
      case ConnectivityResult.none:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.vpn:
      case ConnectivityResult.other:
        return Future.value(ConnectType.unknow);
    }
  }

  Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult.first != ConnectivityResult.none;
  }
}
