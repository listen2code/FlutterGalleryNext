import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter EasyRefresh Custom Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _count = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Custom Header Demo")),
      body: EasyRefresh(
        header: const MyVerticalHeader(
          triggerOffset: 100,
          clamping: false,
        ),
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));

          if (!mounted) return IndicatorResult.fail;

          setState(() {
            _count = 20;
          });
          return IndicatorResult.success;
        },
        child: ListView.builder(
          itemCount: _count,
          itemBuilder: (context, index) {
            return ListTile(title: Text("List Item - $index"));
          },
        ),
      ),
    );
  }
}

class MyVerticalHeader extends Header {
  const MyVerticalHeader({
    super.triggerOffset = 70,
    super.clamping = false,
    super.position = IndicatorPosition.above,
    super.processedDuration = const Duration(milliseconds: 1000),
  });

  @override
  Widget build(BuildContext context, IndicatorState state) {
    bool isProcessing = state.mode == IndicatorMode.processing;
    bool isProcessed = state.mode == IndicatorMode.processed;
    bool isArmed = state.mode == IndicatorMode.armed;
    bool isDone = state.mode == IndicatorMode.done;

    return Container(
      width: double.infinity,
      height: state.offset,
      color: Colors.grey[100],
      child: ClipRect(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: state.triggerOffset,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isProcessing)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else if (isProcessed || isDone)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Icon(Icons.done, color: Colors.green),
                    )
                  else
                    Transform.rotate(
                      angle: isArmed ? 3.14 : 0,
                      child: const Icon(Icons.arrow_downward, color: Colors.blue),
                    ),
                  Text(
                    _getDisplayText(state),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(
                    "subTitle",
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDisplayText(IndicatorState state) {
    switch (state.mode) {
      case IndicatorMode.drag:
        return "Pull to refresh...";
      case IndicatorMode.armed:
        return "Release to refresh";
      case IndicatorMode.processing:
        return "Refreshing...";
      case IndicatorMode.processed:
        return "Refresh success";
      case IndicatorMode.done:
        return "Refresh success";
      default:
        return "Pull to refresh";
    }
  }
}
