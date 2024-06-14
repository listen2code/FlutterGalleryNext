import 'package:flutter/material.dart';

class DemoEmpty extends StatefulWidget {
  const DemoEmpty({Key? key}) : super(key: key);

  @override
  State<DemoEmpty> createState() => _DemoEmptyState();
}

class _DemoEmptyState extends State<DemoEmpty> {

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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DemoEmpty()));
                },
                child: const Text("text")),
          ],
        ),
      ),
    );
  }
}
