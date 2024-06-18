import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/biz/demos/demo_imports.dart';
import 'package:flutter_gallery_next/biz/demos/drawer/demo_drawer_draggable.dart';

class DemoDrawer extends StatefulWidget {
  const DemoDrawer({Key? key}) : super(key: key);

  @override
  State<DemoDrawer> createState() => _DemoDrawerState();
}

class _DemoDrawerState extends State<DemoDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo drawer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DemoDrawerLeft()));
                },
                child: const Text("drawer left")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DemoDrawerDraggable()));
                },
                child: const Text("drawer draggable")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DemoDrawerStagger()));
                },
                child: const Text("drawer stagger")),
          ],
        ),
      ),
    );
  }
}
