import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: MarqueeDemo(),
    debugShowCheckedModeBanner: false,
  ));
}

class MarqueeDemo extends StatelessWidget {
  const MarqueeDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scroll Marquee with Pause")),
      body: Center(
        child: Container(
          height: 50,
          color: Colors.black12,
          child: const MarqueeWidget(
            velocity: 50,
            child: Text(
              "11111111111111111222222222222222223333333333333333",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

class MarqueeWidget extends StatefulWidget {
  final Widget child;
  final double velocity;
  final double gap;

  const MarqueeWidget({
    super.key,
    required this.child,
    this.velocity = 50.0,
    this.gap = 50.0,
  });

  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _childKey = GlobalKey();
  Timer? _timer;
  double _childWidth = 0;
  bool _isPaused = false;
  int _logCounter = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initScrolling());
  }

  void _initScrolling() {
    final box = _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && mounted) {
      setState(() {
        _childWidth = box.size.width;
      });
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    debugPrint("Timer Started. Velocity: ${widget.velocity}, Gap: ${widget.gap}, ChildWidth: $_childWidth");

    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!_isPaused && _scrollController.hasClients && _childWidth > 0) {
        double currentOffset = _scrollController.offset;
        double pixelsPerFrame = widget.velocity * 0.016;
        double newOffset = currentOffset + pixelsPerFrame;
        double loopThreshold = _childWidth + widget.gap;

        if (_logCounter % 60 == 0) {
          debugPrint("--- Marquee Status ---");
          debugPrint("Paused: $_isPaused");
          debugPrint("Current Offset: ${currentOffset.toStringAsFixed(2)}");
          debugPrint("New Offset: ${newOffset.toStringAsFixed(2)}");
          debugPrint("Loop Threshold: $loopThreshold (ChildWidth + Gap)");
          if (newOffset >= loopThreshold) {
            debugPrint(">>> Loop Triggered! Jumping back by $loopThreshold");
          }
        }
        _logCounter++;

        if (newOffset >= loopThreshold) {
          _scrollController.jumpTo(newOffset - loopThreshold);
        } else {
          _scrollController.jumpTo(newOffset);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        debugPrint("User touched down - Pausing");
        setState(() => _isPaused = true);
      },
      onTapUp: (_) {
        debugPrint("User lifted up - Resuming");
        setState(() => _isPaused = false);
      },
      onTapCancel: () {
        debugPrint("Touch canceled - Resuming");
        setState(() => _isPaused = false);
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            Container(key: _childKey, child: widget.child),
            SizedBox(width: widget.gap),
            widget.child,
            SizedBox(width: widget.gap),
          ],
        ),
      ),
    );
  }
}
