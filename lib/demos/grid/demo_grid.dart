import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/demos/button/demo_button_common.dart';
import 'package:flutter_gallery_next/demos/grid/demo_grid_basic.dart';

class DemoGrid extends StatefulWidget {
  const DemoGrid({Key? key}) : super(key: key);

  @override
  State<DemoGrid> createState() => _DemoGridState();
}

class _DemoGridState extends State<DemoGrid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo grid'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoGridBasic()));
                },
                child: const Text("grid basic")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoButtonCommon()));
                },
                child: const Text("grid orientation")),
          ],
        ),
      ),
    );
  }
}
