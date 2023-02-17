import 'package:flutter/material.dart';

/// 圆角效果处理实现
class DemoImageRadius extends StatelessWidget {
  const DemoImageRadius({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ClipDemoPage"),
      ),
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("BoxDecoration 圆角"),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                  color: Colors.red,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("images/lake.jpg"),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text("ClipRRect 圆角对 child"),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Image.asset(
                "images/lake.jpg",
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            )
          ],
        ),
      ),
    );
  }
}
