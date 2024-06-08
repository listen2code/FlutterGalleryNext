import 'package:flutter/material.dart';

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
            const Text("BoxDecoration"),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                  color: Colors.red,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("images/lake.jpg"),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
            ),
            const Text("ClipRRect"),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
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
