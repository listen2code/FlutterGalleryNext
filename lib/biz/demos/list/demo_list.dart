import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/biz/demos/list/demo_list_basic.dart';
import 'package:flutter_gallery_next/biz/demos/list/demo_list_dismiss.dart';
import 'package:flutter_gallery_next/biz/demos/list/demo_list_horizontal.dart';
import 'package:flutter_gallery_next/biz/demos/list/demo_list_long.dart';
import 'package:flutter_gallery_next/biz/demos/list/demo_list_multi.dart';
import 'package:flutter_gallery_next/biz/demos/list/demo_list_refresh.dart';
import 'package:flutter_gallery_next/biz/demos/list/demo_list_silver_bar.dart';
import 'package:flutter_gallery_next/biz/demos/list/demo_list_silver_header.dart';

class DemoList extends StatefulWidget {
  const DemoList({Key? key}) : super(key: key);

  @override
  State<DemoList> createState() => _DemoListState();
}

class _DemoListState extends State<DemoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo list'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoListBasic()));
                },
                child: const Text("list basic")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoListDismiss()));
                },
                child: const Text("list dismiss")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoListHorizontal()));
                },
                child: const Text("list horizontal")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => DemoListLong(items: List<String>.generate(10000, (i) => 'Item $i'))));
                },
                child: const Text("list long")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DemoListMulti(
                            items: List<ListItem>.generate(
                              1000,
                              (i) => i % 6 == 0 ? HeadingItem('Heading $i') : MessageItem('Sender $i', 'Message body $i'),
                            ),
                          )));
                },
                child: const Text("list multi")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoListSilverBar()));
                },
                child: const Text("list silver bar")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoListFixHeader()));
                },
                child: const Text("list fix header")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoListRefresh()));
                },
                child: const Text("list refresh")),
          ],
        ),
      ),
    );
  }
}
