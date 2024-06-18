import 'package:flutter/material.dart';

class DemoDrawerDraggableHandler extends StatefulWidget {
  const DemoDrawerDraggableHandler({super.key});

  @override
  State<DemoDrawerDraggableHandler> createState() =>
      _DemoDrawerDraggableHandlerState();
}

class _DemoDrawerDraggableHandlerState
    extends State<DemoDrawerDraggableHandler> {
  double _sheetPosition = 0.1;
  final double _dragSensitivity = 600;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('demo drawer draggable handler')),
      body: DraggableScrollableSheet(
        initialChildSize: _sheetPosition,
        minChildSize: 0.1,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            color: colorScheme.primary,
            child: Column(
              children: <Widget>[
                Grabber(
                  onVerticalDragUpdate: (DragUpdateDetails details) {
                    setState(() {
                      _sheetPosition -= details.delta.dy / _dragSensitivity;
                      if (_sheetPosition < 0.1) {
                        _sheetPosition = 0.1;
                      }
                      if (_sheetPosition > 1.0) {
                        _sheetPosition = 1.0;
                      }
                    });
                  },
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: 25,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          'Item $index',
                          style: TextStyle(color: colorScheme.surface),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// A draggable widget that accepts vertical drag gestures
class Grabber extends StatelessWidget {
  const Grabber({
    super.key,
    required this.onVerticalDragUpdate,
  });

  final ValueChanged<DragUpdateDetails> onVerticalDragUpdate;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: Container(
        width: double.infinity,
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text("button1"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("button2"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("button3"),
            )
          ],
        ),
      ),
    );
  }
}
