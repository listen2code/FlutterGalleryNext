import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';

class DemoImageCache extends StatelessWidget {
  const DemoImageCache({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    const imageUrl = 'https://picsum.photos/id/237/400/300';

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Cached Network Image')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection(
                context,
                "Standard Cache",
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) => _buildPlaceholder(colors),
                  errorWidget: (context, url, error) => _buildError(colors),
                  fit: BoxFit.cover,
                )),
            const SizedBox(height: 24),
            _buildSection(
                context,
                "Circular Cached Image",
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )),
            const SizedBox(height: 32),
            const Text(
              "Images are saved locally after first download.\nTry turning off Wi-Fi to see it still working!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget child) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: child,
        ),
      ],
    );
  }

  Widget _buildPlaceholder(dynamic colors) {
    return Container(
      color: colors.neutral100,
      height: 200,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(dynamic colors) {
    return Container(
      color: colors.neutral100,
      height: 200,
      child: const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey)),
    );
  }
}
