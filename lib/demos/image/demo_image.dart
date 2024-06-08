import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/demos/image/demo_image_cache.dart';
import 'package:flutter_gallery_next/demos/image/demo_image_network.dart';
import 'package:flutter_gallery_next/demos/image/demo_image_radius.dart';
import 'package:flutter_gallery_next/demos/text/demo_text_basic.dart';
import 'package:flutter_gallery_next/demos/text/demo_text_bubble.dart';
import 'package:flutter_gallery_next/demos/text/demo_text_fetch.dart';
import 'package:flutter_gallery_next/demos/text/demo_text_focus.dart';
import 'package:flutter_gallery_next/demos/text/demo_text_tag.dart';

class DemoImage extends StatefulWidget {
  const DemoImage({Key? key}) : super(key: key);

  @override
  State<DemoImage> createState() => _DemoImageState();
}

class _DemoImageState extends State<DemoImage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoImageCache()));
                },
                child: const Text("image cache")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoImageNetwork()));
                },
                child: const Text("image network")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoImageRadius()));
                },
                child: const Text("image radius")),
          ],
        ),
      ),
    );
  }
}
