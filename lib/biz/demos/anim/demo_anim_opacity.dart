import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';

class DemoAnimOpacityPage extends StatefulWidget {
  const DemoAnimOpacityPage({super.key});

  @override
  State<DemoAnimOpacityPage> createState() => _DemoAnimOpacityPageState();
}

class _DemoAnimOpacityPageState extends State<DemoAnimOpacityPage> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text("Opacity Animation")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: colors.blue500,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: colors.blue500.withAlpha(100),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 80),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Now you see me...",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: colors.foreground,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              "Status: ${_visible ? 'VISIBLE' : 'HIDDEN'}",
              style: TextStyle(color: colors.neutral500),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _visible = !_visible),
        label: Text(_visible ? "Hide Box" : "Show Box"),
        icon: Icon(_visible ? Icons.visibility_off : Icons.visibility),
        backgroundColor: colors.blue600,
      ),
    );
  }
}
