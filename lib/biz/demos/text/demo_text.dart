import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/biz/demos/text/demo_text_basic.dart';
import 'package:flutter_gallery_next/biz/demos/text/demo_text_bubble.dart';
import 'package:flutter_gallery_next/biz/demos/text/demo_text_fetch.dart';
import 'package:flutter_gallery_next/biz/demos/text/demo_text_focus.dart';
import 'package:flutter_gallery_next/biz/demos/text/demo_text_tag.dart';

class DemoText extends StatefulWidget {
  const DemoText({Key? key}) : super(key: key);

  @override
  State<DemoText> createState() => _DemoTextState();
}

class _DemoTextState extends State<DemoText> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo empty'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoTextBasic()));
                },
                child: const Text("text basic")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoTextFetch()));
                },
                child: const Text("text fetch")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoTextFocus()));
                },
                child: const Text("text focus")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => DemoTextBubble()));
                },
                child: const Text("text bubble")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => DemoTextTag()));
                },
                child: const Text("text tag")),
          ],
        ),
      ),
    );
  }
}
