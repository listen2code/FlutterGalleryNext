import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/event_bus/event_bus.dart';
import 'package:flutter_gallery_next/base/common/event_bus/event_bus_key.dart';

class DemoEventBus extends StatefulWidget {
  const DemoEventBus({Key? key}) : super(key: key);

  @override
  State<DemoEventBus> createState() => _DemoEventBusState();
}

class _DemoEventBusState extends State<DemoEventBus> {
  StreamSubscription? streamSubscription;

  @override
  void initState() {
    super.initState();
    streamSubscription =
        EventBus.defaultBus().subscribe(subscriber: (event) async {
      debugPrint("EventBus subscribe=$event");
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo EventBus'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                EventBus.defaultBus().post(event: EventBusKeys.login);
              },
              child: const Text("post login"),
            ),
          ],
        ),
      ),
    );
  }
}
