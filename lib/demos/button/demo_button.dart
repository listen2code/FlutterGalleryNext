import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/demos/button/demo_button_common.dart';
import 'package:flutter_gallery_next/demos/button/demo_button_download.dart';
import 'package:flutter_gallery_next/demos/button/demo_button_inkwell.dart';
import 'package:flutter_gallery_next/demos/button/demo_button_ontap.dart';
import 'package:flutter_gallery_next/demos/button/demo_button_toggle.dart';

class DemoButton extends StatefulWidget {
  const DemoButton({Key? key}) : super(key: key);

  @override
  State<DemoButton> createState() => _DemoButtonState();
}

class _DemoButtonState extends State<DemoButton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoButtonInkWell()));
                },
                child: const Text("button inkwell")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoButtonOnTap()));
                },
                child: const Text("button onTap")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoButtonDownload()));
                },
                child: const Text("button download")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoButtonCommon()));
                },
                child: const Text("button common")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoButtonToggle()));
                },
                child: const Text("button toggle")),
          ],
        ),
      ),
    );
  }
}
