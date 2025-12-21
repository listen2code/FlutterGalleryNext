import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/pages.dart';
import 'package:flutter_gallery_next/base/widget/bottom_navi/route_ext.dart';
import 'package:get/get.dart';

class Tab1 extends StatefulWidget {
  const Tab1({Key? key}) : super(key: key);

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: Text("tab11"),
            onPressed: () {
              Get.toTab1(Routers.tab11);
            },
          ),
          ElevatedButton(
            child: Text("tab21"),
            onPressed: () {
              Get.toTab2(Routers.tab21);
            },
          ),
          ElevatedButton(
            child: Text("tab31"),
            onPressed: () {
              Get.toTab3(Routers.tab31);
            },
          ),
          ElevatedButton(
            child: Text(Routers.login),
            onPressed: () {
              Get.toTab1(Routers.login);
            },
          ),
          ElevatedButton(
            child: Text(Routers.userInfo),
            onPressed: () {
              Get.toTab1(Routers.userInfo);
            },
          ),
        ],
      ),
    );
  }
}
