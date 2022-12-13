import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/widgets/tapbox_a.dart';
import 'package:flutter_gallery_next/widgets/tapbox_b.dart';
import 'package:flutter_gallery_next/widgets/tapbox_c.dart';

//------------------------- MyApp ----------------------------------


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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