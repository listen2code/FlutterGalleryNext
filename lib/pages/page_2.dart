import 'package:flutter/material.dart';


class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Page 2"),
      ),
      body: const Center(
        child: Text('Page 2'),
      ),
    );
  }
}