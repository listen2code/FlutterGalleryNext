import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/demos/image/demo_image_cache.dart';
import 'package:flutter_gallery_next/demos/image/demo_image_network.dart';
import 'package:flutter_gallery_next/demos/image/demo_image_radius.dart';
import 'package:flutter_gallery_next/demos/net/demo_net_async.dart';
import 'package:flutter_gallery_next/demos/net/demo_net_basic.dart';
import 'package:flutter_gallery_next/demos/net/demo_net_complex_add.dart';
import 'package:flutter_gallery_next/demos/net/demo_net_complex_del.dart';
import 'package:flutter_gallery_next/demos/net/demo_net_complex_update.dart';
import 'package:flutter_gallery_next/demos/text/demo_text_basic.dart';
import 'package:flutter_gallery_next/demos/text/demo_text_bubble.dart';
import 'package:flutter_gallery_next/demos/text/demo_text_fetch.dart';
import 'package:flutter_gallery_next/demos/text/demo_text_focus.dart';
import 'package:flutter_gallery_next/demos/text/demo_text_tag.dart';

class DemoNet extends StatefulWidget {
  const DemoNet({Key? key}) : super(key: key);

  @override
  State<DemoNet> createState() => _DemoNetState();
}

class _DemoNetState extends State<DemoNet> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo net'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoNetBasic()));
                },
                child: const Text("net basic")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoNetAsync()));
                },
                child: const Text("net async")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoNetComplexAdd()));
                },
                child: const Text("net complex add")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoNetComplexDel()));
                },
                child: const Text("net complex del")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoNetComplexUpdate()));
                },
                child: const Text("net complex update")),
          ],
        ),
      ),
    );
  }
}
