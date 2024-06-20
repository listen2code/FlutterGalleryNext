import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/biz/demos/demo_imports.dart';
import 'package:flutter_gallery_next/biz/demos/tab/demo_tab_scrollable.dart';

class DemoTab extends StatefulWidget {
  const DemoTab({Key? key}) : super(key: key);

  @override
  State<DemoTab> createState() => _DemoTabState();
}

class _DemoTabState extends State<DemoTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo tab'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DemoTabBasic()));
                },
                child: const Text("tab basic")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DemoTabScrollable()));
                },
                child: const Text("tab scrollable")),
          ],
        ),
      ),
    );
  }
}
