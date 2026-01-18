import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/widget/dialog/common_dialog.dart';
import 'package:plugin_native/proxy/proxy_info.dart';
import 'package:plugin_native/proxy/proxy_util.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text("Demo proxy")),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await ProxyUtil.instance.init();
                GlobalDialog.showToast("ProxyUtil init");
              },
              child: Text("init"),
            ),
            ElevatedButton(
              onPressed: () async {
                ProxyInfo? proxyInfo = await ProxyUtil.instance.findProxyAsync(Uri.parse("http://192.168.0.224:9898/api/login"));
                GlobalDialog.showToast("proxyInfo=$proxyInfo");
                Dio().get("http://192.168.0.224:9898/api/login");
              },
              child: Text("test login"),
            ),
          ],
        ),
      ),
    );
  }
}
