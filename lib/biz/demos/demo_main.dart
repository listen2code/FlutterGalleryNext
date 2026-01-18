import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/pages.dart';
import 'package:package_base/function_proxy_util.dart';

class DemoMainPage extends StatelessWidget {
  const DemoMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("main")),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(Constant.router.keys.toList()[index]);
            }.throttle(milliseconds: 2000),
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              child: Text(Constant.router.keys.toList()[index]),
            ),
          );
        },
        itemCount: Constant.router.length,
      ),
    );
  }
}
