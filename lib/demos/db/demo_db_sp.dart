import 'package:flutter/material.dart';
import 'package:package_libs/utils/sp_util.dart';

class DemoDbSp extends StatefulWidget {
  const DemoDbSp({super.key});

  @override
  State<DemoDbSp> createState() => _DemoDbSpState();
}

class _DemoDbSpState extends State<DemoDbSp> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  //Loading counter value on start
  Future<void> _loadCounter() async {
    var counter = await SpUtil.instance.get('counter');
    setState(() {
      _counter = counter;
    });
  }

  //Incrementing counter after click
  Future<void> _incrementCounter() async {
    var counter = await SpUtil.instance.get('counter');
    debugPrint("counter=$counter");
    setState(() {
      _counter = (counter ?? 0) + 1;
      SpUtil.instance.set('counter', _counter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo sp"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
