import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/biz/demos/nav/demo_nav_complex.dart';
import 'package:flutter_gallery_next/biz/demos/nav/demo_nav_hero.dart';
import 'package:flutter_gallery_next/biz/demos/nav/demo_nav_name.dart';
import 'package:flutter_gallery_next/biz/demos/nav/demo_nav_param.dart';
import 'package:flutter_gallery_next/biz/demos/nav/demo_nav_push_pop.dart';
import 'package:flutter_gallery_next/biz/demos/nav/demo_nav_selection.dart';
import 'package:flutter_gallery_next/biz/demos/nav/demo_nav_todos.dart';
import 'package:flutter_gallery_next/biz/demos/page_route/page_1.dart';

class DemoNav extends StatefulWidget {
  const DemoNav({Key? key}) : super(key: key);

  @override
  State<DemoNav> createState() => _DemoNavState();
}

class _DemoNavState extends State<DemoNav> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo nav'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoNavComplex()));
                },
                child: const Text("nav complex")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoNavHero()));
                },
                child: const Text("nav hero")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoNavName()));
                },
                child: const Text("nav name")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoNavParam()));
                },
                child: const Text("nav param")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoNavPushPop()));
                },
                child: const Text("nav push pop")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoNavSelection()));
                },
                child: const Text("nav selection")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoNavTodos()));
                },
                child: const Text("nav todos")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoPageRoute()));
                },
                child: const Text("nav page route")),
          ],
        ),
      ),
    );
  }
}
