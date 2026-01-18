import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';
import 'package:flutter_gallery_next/generated/r.dart';

class DemoImageRadius extends StatefulWidget {
  const DemoImageRadius({super.key});

  @override
  State<DemoImageRadius> createState() => _DemoImageRadiusState();
}

class _DemoImageRadiusState extends State<DemoImageRadius> {
  double _radius = 20.0;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text("Image Radius & Clipping")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Control Slider
            Card(
              color: colors.blue100,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.rounded_corner),
                    Expanded(
                      child: Slider(
                        value: _radius,
                        min: 0,
                        max: 100,
                        onChanged: (v) => setState(() => _radius = v),
                      ),
                    ),
                    Text("${_radius.toInt()}px", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            _buildExample(
              context,
              "1. BoxDecoration (Container)",
              "Uses decoration to clip the background image.",
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_radius),
                  image: const DecorationImage(image: AssetImage(R.imagesLake), fit: BoxFit.cover),
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 10)],
                ),
              ),
            ),

            _buildExample(
              context,
              "2. ClipRRect (Widget)",
              "Clips any child widget (Image, Video, etc.) to a rounded rect.",
              ClipRRect(
                borderRadius: BorderRadius.circular(_radius),
                child: Image.asset(R.imagesLake, width: 150, height: 150, fit: BoxFit.cover),
              ),
            ),

            _buildExample(
              context,
              "3. Physical Model",
              "Provides both clipping and efficient hardware shadows.",
              PhysicalModel(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(_radius),
                child: Image.asset(R.imagesLake, width: 150, height: 150, fit: BoxFit.cover),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExample(BuildContext context, String title, String desc, Widget child) {
    final colors = AppTheme.colors(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          Text(title, style: TextStyle(color: colors.foreground, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
