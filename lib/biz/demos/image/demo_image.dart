import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';
import 'package:flutter_gallery_next/biz/demos/image/demo_image_cache.dart';
import 'package:flutter_gallery_next/biz/demos/image/demo_image_network.dart';
import 'package:flutter_gallery_next/biz/demos/image/demo_image_radius.dart';

class DemoImage extends StatelessWidget {
  const DemoImage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Image Handling'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDemoTile(
            context,
            "Image Cache",
            "Efficient loading and local caching using CachedNetworkImage.",
            Icons.cached,
            () => _go(context, const DemoImageCache()),
          ),
          _buildDemoTile(
            context,
            "Network Fade-in",
            "Smooth transition effects when loading images from the web.",
            Icons.cloud_download_outlined,
            () => _go(context, const DemoImageNetwork()),
          ),
          _buildDemoTile(
            context,
            "Radius & Clipping",
            "Exploring different ways to create rounded corners and shapes.",
            Icons.rounded_corner,
            () => _go(context, const DemoImageRadius()),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Text(
              "Select a demo to see high-performance image processing in action.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _go(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }

  Widget _buildDemoTile(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    final colors = AppTheme.colors(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: colors.blue100,
          child: Icon(icon, color: colors.blue600),
        ),
        title: Text(
          title,
          style: TextStyle(color: colors.foreground, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: colors.neutral600, fontSize: 12),
        ),
        trailing: Icon(Icons.chevron_right, color: colors.neutral400),
        onTap: onTap,
      ),
    );
  }
}
