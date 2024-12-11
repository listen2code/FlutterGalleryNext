import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityUtil {
  ConnectivityUtil._private();

  static final ConnectivityUtil _instance = ConnectivityUtil._private();

  factory ConnectivityUtil.instance() => _instance;

  Future<String> getStatus() async {
    List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    switch (connectivityResult.first) {
      case ConnectivityResult.wifi:
        return Future.value("WiFi");
      case ConnectivityResult.mobile:
        return Future.value("Mobile");
      case ConnectivityResult.none:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.vpn:
      case ConnectivityResult.other:
        return Future.value("UNKNOWN");
    }
  }
}
