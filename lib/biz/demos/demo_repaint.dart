import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DemoRepaint extends StatefulWidget {
  const DemoRepaint({super.key});

  @override
  State createState() => _DemoRepaintState();
}

class _DemoRepaintState extends State<DemoRepaint> {
  final GlobalKey _paintKey = GlobalKey();
  Offset _offset = Offset.zero;
  bool isRepaintBoundary = true;

  @override
  void initState() {
    super.initState();
    // Every repainted widget will be highlighted with a continuously changing rainbow-colored border.
    debugRepaintRainbowEnabled = true;
  }

  @override
  void dispose() {
    super.dispose();
    debugRepaintRainbowEnabled = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.cyan,
        title: const Text('DemoRepaint'),
      ),
      body: Stack(
        children: [
          _buildBackground(),
          _buildCursor(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isRepaintBoundary = !isRepaintBoundary;
          });
        },
        child: Text(isRepaintBoundary ? "On" : "Off"),
      ),
    );
  }

  Widget _buildBackground() {
    return CustomPaint(
      painter: BackgroundColor(MediaQuery.of(context).size),
      isComplex: true,
      willChange: false,
    );
  }

  Widget _buildCursor() {
    // By wrapping the moving part in its own RepaintBoundary, we give a strong
    // hint to the engine to isolate it in a separate layer. This makes it much
    // easier for the engine to decide to cache the background layer.
    final cursorWidget = Listener(
      onPointerDown: _updateOffset,
      onPointerMove: _updateOffset,
      child: CustomPaint(
        key: _paintKey,
        painter: CursorPointer(_offset),
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
        ),
      ),
    );

    if (isRepaintBoundary) {
      // After adding RepaintBoundary, the drawing of cursorWidget is isolated,
      // preventing it from causing _buildBackground to repaint, thus improving performance.
      return RepaintBoundary(child: cursorWidget);
    }

    return cursorWidget;
  }

  _updateOffset(PointerEvent event) {
    RenderBox? referenceBox = _paintKey.currentContext?.findRenderObject() as RenderBox;
    Offset offset = referenceBox.globalToLocal(event.position);
    setState(() {
      _offset = offset;
    });
  }
}

class CursorPointer extends CustomPainter {
  final Offset _offset;

  CursorPointer(this._offset);

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint("DemoRepaint CursorPointer paint()");
    canvas.drawCircle(
      _offset,
      50.0,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(CursorPointer oldDelegate) => oldDelegate._offset != _offset;
}

class BackgroundColor extends CustomPainter {
  static const List<Color> colors = [
    Colors.orange,
    Colors.purple,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.red,
  ];

  final Size _size;

  BackgroundColor(this._size);

  @override
  void paint(Canvas canvas, Size size) {
    debugPrint("DemoRepaint BackgroundColor paint()");
    final Random rand = Random(12345);

    for (int i = 0; i < 500; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(
            rand.nextDouble() * _size.width - 100,
            rand.nextDouble() * _size.height,
          ),
          width: rand.nextDouble() * rand.nextInt(150) + 200,
          height: rand.nextDouble() * rand.nextInt(150) + 200,
        ),
        Paint()..color = colors[rand.nextInt(colors.length)].withAlpha(60),
      );
    }
  }

  @override
  bool shouldRepaint(BackgroundColor oldDelegate) => false;
}
