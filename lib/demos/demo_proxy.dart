import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/utils/custom_proxy_override.dart';
import 'package:native_flutter_proxy/custom_proxy.dart';
import 'package:native_flutter_proxy/native_proxy_reader.dart';

initProxy() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool enabled = false;
  String? host;
  int? port;
  try {
    ProxySetting settings = await NativeProxyReader.proxySetting;
    enabled = settings.enabled;
    host = settings.host;
    port = settings.port;
  } catch (e) {
    debugPrint("$e");
  }
  if (enabled && host != null) {
    final proxy = CustomProxy(ipAddress: host, port: port);
    HttpOverrides.global = CustomProxyHttpOverride.withProxy(proxy.toString());
    debugPrint("proxy enabled=$enabled host=$host port=$port");
  }
}

class DemoProxy extends StatefulWidget {
  const DemoProxy({Key? key}) : super(key: key);

  @override
  State<DemoProxy> createState() => _DemoProxyState();
}

class _DemoProxyState extends State<DemoProxy> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "demo proxy",
      home: Scaffold(
        appBar: AppBar(
          title: const Text("demo proxy"),
        ),
        body: ElevatedButton(
            onPressed: () {
              Dio().get("http://172.16.0.1");
            },
            child: Text("test dio")),
      ),
    );
  }
}
