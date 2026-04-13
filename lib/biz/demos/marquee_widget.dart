import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Schedulerをインポートする必要があります

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
  ];

  @override
  void initState() {
    super.initState();
    // 1秒ごとに株価データを更新するシミュレーション
    _dataTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _stocks = _stocks.map((stock) {
            final double randomMove = (Random().nextDouble() * 2 - 1);
            return {
              "symbol": stock["symbol"],
              "price": stock["price"] + randomMove,
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
            velocity: 100,
            child: Text(
              stockText,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
                // 重要：等幅フォントを使用して、数字の変化による幅のガタつきを防ぎます
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
  /// スクロールさせたいウィジェット（通常はText）
  final Widget child;

  /// スクロール速度（ピクセル/秒）
  final double velocity;

  /// ループ時の隙間（ピクセル）
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

// SingleTickerProviderStateMixinを使用してVSync信号を取得します
class _MarqueeWidgetState extends State<MarqueeWidget> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  final ValueNotifier<double> _offsetNotifier = ValueNotifier(0.0);
  final GlobalKey _childKey = GlobalKey();
  double _childWidth = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    // 1. Timerの代わりにTickerを使用し、VSync（垂直同期）に完全に一致させます
    _ticker = createTicker(_onTick)..start();
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _onTick(Duration elapsed) {
    if (_isPaused || _childWidth <= 0) {
      _lastElapsed = elapsed;
      return;
    }

    // 前回のフレームからの経過時間（Delta Time）を計算
    final Duration delta = elapsed - _lastElapsed;
    final double dt = delta.inMicroseconds / Duration.microsecondsPerSecond;
    _lastElapsed = elapsed;

    // 速度(velocity) × 経過時間(dt) で移動距離を算出
    final double threshold = _childWidth + widget.gap;
    _offsetNotifier.value = (_offsetNotifier.value + widget.velocity * dt) % threshold;
  }

  void _measure() {
    final box = _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && mounted) {
      // コンテンツの幅を測定。setStateを呼ばないことで、不要なビルドを回避します
      _childWidth = box.size.width;
    }
  }

  @override
  void didUpdateWidget(covariant MarqueeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 3. データ（child）更新後に最新の幅を測定します
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void dispose() {
    _ticker.dispose();
    _offsetNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // GestureDetectorよりも反応が速いListenerを使用して、タッチ時の即時停止を実現します
    return Listener(
      behavior: HitTestBehavior.opaque,
      // 空白エリアでもクリックに反応するように設定
      onPointerDown: (_) {
        _isPaused = true;
      },
      onPointerUp: (_) {
        _isPaused = false;
      },
      onPointerCancel: (_) {
        _isPaused = false;
      },
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _offsetNotifier,
          builder: (context, _) {
            // Transformを使用して描画レイヤーのみを移動させるため、非常にスムーズです
            return Transform.translate(
              offset: Offset(-_offsetNotifier.value, 0),
              child: OverflowBox(
                alignment: Alignment.centerLeft,
                maxWidth: double.infinity,
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
          },
        ),
      ),
    );
  }
}
