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
          triggerOffset: 90,
          clamping: false,
          secondaryText: "Last updated: 12:00",
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

/// A custom Header inspired by ClassicHeader but with Column layout and subTitle.
class MyVerticalHeader extends Header {
  final String? secondaryText;

  const MyVerticalHeader({
    super.triggerOffset = 70,
    super.clamping = false,
    super.processedDuration = Duration.zero,
    this.secondaryText,
  });

  @override
  Widget build(BuildContext context, IndicatorState state) {
    return _MyVerticalHeaderWidget(
      state: state,
      secondaryText: secondaryText,
    );
  }
}

class _MyVerticalHeaderWidget extends StatelessWidget {
  final IndicatorState state;
  final String? secondaryText;

  const _MyVerticalHeaderWidget({
    required this.state,
    this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    final mode = state.mode;
    final isReady = mode == IndicatorMode.ready;
    final isProcessing = mode == IndicatorMode.processing;
    final isProcessed = mode == IndicatorMode.processed;
    final isArmed = mode == IndicatorMode.armed;
    final isDone = mode == IndicatorMode.done;

    final bool isRefreshing = isReady || isProcessing || isProcessed || isDone;
    final bool showSecondary = secondaryText != null && !isRefreshing;

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
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Top Area: Show loading indicator when refreshing, otherwise show static icon
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: isRefreshing
                          ? const SizedBox(
                              key: ValueKey('loading'),
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(
                              Icons.refresh,
                              key: ValueKey('icon'),
                              size: 24,
                              color: Colors.blueGrey,
                            ),
                    ),
                    const SizedBox(height: 6),
                    // Main Content Row
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Hide arrow icon when refreshing
                        if (!isRefreshing) ...[
                          _buildArrow(isArmed),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          _getDisplayText(state),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    // Secondary Text
                    Visibility(
                      visible: showSecondary,
                      replacement: const SizedBox(height: 10),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          secondaryText!,
                          style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArrow(bool isArmed) {
    return TweenAnimationBuilder<double>(
      key: const ValueKey('arrow'),
      tween: Tween<double>(begin: 0, end: isArmed ? 3.14159 : 0),
      duration: const Duration(milliseconds: 200),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value,
          child: const Icon(Icons.arrow_downward, color: Colors.blue, size: 20),
        );
      },
    );
  }

  String _getDisplayText(IndicatorState state) {
    switch (state.mode) {
      case IndicatorMode.drag:
        return "Pull to refresh";
      case IndicatorMode.armed:
        return "Release to refresh";
      case IndicatorMode.ready:
      case IndicatorMode.processing:
      case IndicatorMode.processed:
      case IndicatorMode.done:
        return "Refreshing...";
      default:
        return "Pull to refresh";
    }
  }
}
