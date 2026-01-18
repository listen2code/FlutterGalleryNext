import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';
import 'package:flutter_gallery_next/biz/demos/loading/global_loading.dart';
import 'package:flutter_gallery_next/biz/demos/loading/toast.dart';

class DemoDialog extends StatelessWidget {
  const DemoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Dialogs & Overlays')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, "Custom Overlays"),
          _buildActionCard(
            context,
            "Interactive Toasts",
            "Custom OverlayEntry based messages.",
            [
              ElevatedButton(
                onPressed: () => Toast.show("This is a custom toast!"),
                child: const Text("Show Toast"),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildActionCard(
            context,
            "Loading Indicators",
            "Global Material-style loading overlay.",
            [
              ElevatedButton(
                onPressed: () async {
                  GlobalLoading.showLoading();
                  await Future.delayed(const Duration(seconds: 2));
                  GlobalLoading.dismiss();
                },
                child: const Text("Show Global Loading"),
              ),
            ],
          ),
          const Divider(height: 48),
          _buildSectionHeader(context, "Material Standard"),
          _buildActionCard(
            context,
            "Native Custom Dialog",
            "Custom layout using standard showDialog function.",
            [
              ElevatedButton(
                onPressed: () => _showCustomNativeDialog(context),
                child: const Text("Show Custom Dialog"),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildActionCard(
            context,
            "Bottom Sheets",
            "Slide-up panels for supplementary content.",
            [
              ElevatedButton(
                onPressed: () => _showBottomSheet(context),
                child: const Text("Standard Sheet"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Logic Helpers ---

  void _showCustomNativeDialog(BuildContext context) {
    final colors = AppTheme.colors(context);
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            width: 280,
            height: 300,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: colors.foreground.withAlpha(30),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.auto_awesome, color: colors.blue500, size: 56),
                const SizedBox(height: 20),
                Text(
                  "Native Dialog",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.foreground,
                      ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "This dialog uses the native showDialog function with a fixed height of 300px.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Got it!"),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    final colors = AppTheme.colors(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: colors.neutral300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            Text("Bottom Sheet", style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            const Text("This panel slides up from the bottom and is perfect for list selections or sharing options."),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
          ],
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 16),
      child: Text(title,
          style:
              TextStyle(color: AppTheme.colors(context).blue600, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.1)),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String sub, List<Widget> actions) {
    final colors = AppTheme.colors(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.neutral200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(sub, style: TextStyle(color: colors.neutral500, fontSize: 12)),
            const SizedBox(height: 16),
            Wrap(spacing: 8, runSpacing: 8, children: actions),
          ],
        ),
      ),
    );
  }
}
