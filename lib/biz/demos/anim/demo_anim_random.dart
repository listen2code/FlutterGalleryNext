import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';

class DemoAnimRandomPage extends StatefulWidget {
  const DemoAnimRandomPage({super.key});

  @override
  State<DemoAnimRandomPage> createState() => _DemoAnimRandomPageState();
}

class _DemoAnimRandomPageState extends State<DemoAnimRandomPage> {
  double _width = 150;
  double _height = 150;
  Color _color = Colors.blue;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(16);
  int _counter = 0;

  void _randomize() {
    setState(() {
      final random = Random();
      _width = random.nextInt(200).toDouble() + 100;
      _height = random.nextInt(200).toDouble() + 100;
      _color = Color.fromRGBO(random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
      _borderRadius = BorderRadius.circular(random.nextInt(100).toDouble());
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    final textColor = _color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Random Shape & Style')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              width: _width,
              height: _height,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: _borderRadius,
                boxShadow: [
                  BoxShadow(color: _color.withAlpha(80), blurRadius: 15, offset: const Offset(0, 8))
                ],
              ),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              child: Center(
                child: Text(
                  "#$_counter",
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
            ),
            const SizedBox(height: 48),
            Text("Tap the button to randomize properties", style: TextStyle(color: colors.neutral500)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _randomize,
        backgroundColor: colors.blue600,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
