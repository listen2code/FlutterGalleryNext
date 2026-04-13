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

/// 独自のマーキー（電光掲示板）ウィジェット
class MarqueeWidget extends StatefulWidget {
  /// [child]
  /// スクロールさせたいコンテンツ（通常は Text ウィジェット）。
  final Widget child;

  /// [velocity]
  /// スクロールの速度（ピクセル/秒）。数値が大きいほど速く動きます。
  final double velocity;

  /// [gap]
  /// コンテンツがループする際の、末尾と先頭の間の空白距離（ピクセル）。
  final double gap;

  /// [resumeAfterTouch]
  /// ユーザーがタッチ（ドラッグ）を止めた後に、自動再生を再開するかどうか。
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
    // 最初のフレーム描画後に初期化を行う
    WidgetsBinding.instance.addPostFrameCallback((_) => _initScrolling());
  }

  /// ウィジェットが更新された際に呼ばれる
  /// (例: 親ウィジェットの setState により child のテキストが変更された場合)
  @override
  void didUpdateWidget(covariant MarqueeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // テキスト内容が変わった可能性があるため、描画後に再度幅を計測する
    // didUpdateWidget 時点ではまだ新しいレイアウトが確定していないため addPostFrameCallback が必要
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final box = _childKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && mounted) {
        setState(() {
          _childWidth = box.size.width;
        });
      }
    });
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

  /// [Timer.periodic]
  /// 一定間隔（ここでは16ms、約60fps）で処理を繰り返すタイマー。
  /// フレームごとに offset を加算して jumpTo することで滑らかな動きを実現します。
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!_isPaused && _scrollController.hasClients && _childWidth > 0) {
        double currentOffset = _scrollController.offset;

        // 速度計算: velocity は 1秒あたりの移動量なので、16ms分の移動量を計算
        double pixelsPerFrame = widget.velocity * 0.016;

        double newOffset = currentOffset + pixelsPerFrame;
        double loopThreshold = _childWidth + widget.gap;

        // ループ処理: コンテンツ＋隙間分を移動したら先頭に戻す
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
    // GestureDetector でタッチ操作を検知
    // onTap ではなく onPan を使うことで、ドラッグ開始時も確実に一時停止させる
    return GestureDetector(
      onPanDown: (_) => setState(() => _isPaused = true),
      onPanEnd: (_) {
        if (widget.resumeAfterTouch) setState(() => _isPaused = false);
      },
      onPanCancel: () {
        if (widget.resumeAfterTouch) setState(() => _isPaused = false);
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        // ユーザーによる自由なスクロールを禁止し、タイマー制御のみにする
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          children: [
            // コンテンツ本体（幅計測用）
            Container(key: _childKey, child: widget.child),
            SizedBox(width: widget.gap),
            // ループを途切れさせないための複製
            widget.child,
            SizedBox(width: widget.gap),
          ],
        ),
      ),
    );
  }
}
