import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/biz/demos/state/tapbox_a.dart';
import 'package:flutter_gallery_next/biz/demos/state/tapbox_b.dart';
import 'package:flutter_gallery_next/biz/demos/state/tapbox_c.dart';

class DemoState extends StatelessWidget {
  const DemoState({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo'),
        ),
        body: Column(
          children: const [
            TapboxA(),
            TapboxBParent(),
            TapboxCParent(),
          ],
        ),
      ),
    );
  }
}
