import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/demos/anim/demo_anim_opacity.dart';
import 'package:flutter_gallery_next/demos/anim/demo_anim_physics_drag.dart';
import 'package:flutter_gallery_next/demos/anim/demo_anim_random.dart';
import 'package:flutter_gallery_next/demos/anim/demo_anim_transition.dart';

class DemoAnim extends StatefulWidget {
  const DemoAnim({Key? key}) : super(key: key);

  @override
  State<DemoAnim> createState() => _DemoAnimState();
}

class _DemoAnimState extends State<DemoAnim> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo anim'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoAnimOpacity()));
                },
                child: const Text("anim opacity")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoAnimPhysicsDrag()));
                },
                child: const Text("anim physics drag")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoAnimRandom()));
                },
                child: const Text("anim random")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => DemoAnimTransition()));
                },
                child: const Text("anim transition")),
          ],
        ),
      ),
    );
  }
}
