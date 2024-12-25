import 'dart:math';

import 'package:flutter/material.dart';

class DemoRepaint extends StatefulWidget {
  const DemoRepaint({super.key});

  @override
  State createState() => _DemoRepaintState();
}

class _DemoRepaintState extends State<DemoRepaint> {
  final GlobalKey _paintKey = GlobalKey();
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.cyan,
        title: const Text('Flutter RepaintBoundary Demo'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildBackground(),
          _buildCursor(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    // 不加RepaintBoundary的时候，_buildCursor会导致_buildBackground也重绘，性能很差
    return RepaintBoundary(
      child: CustomPaint(
        painter: BackgroundColor(MediaQuery.of(context).size),
        // 提示这个图层的绘画应该被缓存
        isComplex: true,
        // willChange是false意味着是否应该告诉光栅缓存，这个绘画在下一帧可能会改变
        willChange: false,
      ),
    );
  }

  Widget _buildCursor() {
    return Listener(
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
      10.0,
      Paint()..color = Colors.green,
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

    for (int i = 0; i < 10000; i++) {
      canvas.drawOval(
          Rect.fromCenter(
            center: Offset(
              rand.nextDouble() * _size.width - 100,
              rand.nextDouble() * _size.height,
            ),
            width: rand.nextDouble() * rand.nextInt(150) + 200,
            height: rand.nextDouble() * rand.nextInt(150) + 200,
          ),
          Paint()..color = colors[rand.nextInt(colors.length)].withOpacity(0.3));
    }
  }

  @override
  bool shouldRepaint(BackgroundColor oldDelegate) => false;
}
