import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';
import 'package:flutter_gallery_next/generated/r.dart';

class DemoImageNetwork extends StatefulWidget {
  const DemoImageNetwork({super.key});

  @override
  State<DemoImageNetwork> createState() => _DemoImageNetworkState();
}

class _DemoImageNetworkState extends State<DemoImageNetwork> {
  int _imageId = 10;

  void _nextImage() {
    setState(() {
      _imageId++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    final String imageUrl = 'https://picsum.photos/id/$_imageId/600/400';

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Fade-in Network Images')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(30), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: FadeInImage.assetNetwork(
                    placeholder: R.imagesLoading,
                    image: imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                    fadeInDuration: const Duration(milliseconds: 500),
                    fadeInCurve: Curves.easeIn,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Dynamic Image ID: #$_imageId",
                style: TextStyle(color: colors.neutral600, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "FadeInImage provides a smooth transition when the network image finishes loading.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _nextImage,
        label: const Text("Next Image"),
        icon: const Icon(Icons.refresh),
        backgroundColor: colors.blue600,
      ),
    );
  }
}
