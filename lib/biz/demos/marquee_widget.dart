import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: MarqueeDemo(),
    debugShowCheckedModeBanner: false,
  ));
}

class MarqueeDemo extends StatefulWidget {
  const MarqueeDemo({super.key});

  @override
  State<MarqueeDemo> createState() => _MarqueeDemoState();
}

class _MarqueeDemoState extends State<MarqueeDemo> {
  Timer? _dataTimer;
  List<Map<String, dynamic>> _stocks = [
    {"symbol": "AAPL", "price": 150.25, "change": 1.2},
    {"symbol": "GOOGL", "price": 2800.10, "change": -0.5},
    {"symbol": "TSLA", "price": 700.45, "change": 2.8},
    {"symbol": "AMZN", "price": 3300.00, "change": -1.1},
    {"symbol": "MSFT", "price": 290.50, "change": 0.3},
  ];

  @override
  void initState() {
    super.initState();
    _dataTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _stocks = _stocks.map((stock) {
            final double randomMove = (Random().nextDouble() * 2 - 1);
            final double newPrice = stock["price"] + randomMove;
            return {
              "symbol": stock["symbol"],
              "price": newPrice,
              "change": randomMove > 0 ? (Random().nextDouble() * 5) : -(Random().nextDouble() * 5),
            };
          }).toList();
        });
      }
    });
  }

  @override
  void dispose() {
    _dataTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String stockText = _stocks.map((s) {
      final String sign = s["change"] >= 0 ? "+" : "";
      return "${s["symbol"]}: ${s["price"].toStringAsFixed(2)} ($sign${s["change"].toStringAsFixed(2)}%)";
    }).join("   |   ");

    return Scaffold(
      appBar: AppBar(title: const Text("Stock Index Marquee")),
      body: Center(
        child: Container(
          height: 60,
          color: Colors.black,
          child: MarqueeWidget(
            velocity: 60,
            resumeAfterTouch: true,
            child: Text(
              stockText,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
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
  final bool resumeAfterTouch;

  const MarqueeWidget({
    super.key,
    required this.child,
    this.velocity = 50.0,
    this.gap = 50.0,
    this.resumeAfterTouch = true,
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initScrolling());
  }

  @override
  void didUpdateWidget(MarqueeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final box = _childKey.currentContext?.findRenderObject() as RenderBox?;
        if (box != null) {
          final double newWidth = box.size.width;
          if (_childWidth != newWidth) {
            setState(() {
              _childWidth = newWidth;
            });
          }
        }
      });
    }
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
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!_isPaused && _scrollController.hasClients && _childWidth > 0) {
        double currentOffset = _scrollController.offset;

        // velocity represents pixels per second.
        // 0.016 is the time elapsed in one timer tick (16ms / 1000ms = 0.016s).
        double pixelsPerFrame = widget.velocity * 0.016;

        double newOffset = currentOffset + pixelsPerFrame;
        double loopThreshold = _childWidth + widget.gap;

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
      onTapDown: (_) => setState(() => _isPaused = true),
      onTapUp: (_) {
        if (widget.resumeAfterTouch) setState(() => _isPaused = false);
      },
      onTapCancel: () {
        if (widget.resumeAfterTouch) setState(() => _isPaused = false);
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
