import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';
import 'package:flutter_gallery_next/biz/demos/anim/demo_anim_opacity.dart';
import 'package:flutter_gallery_next/biz/demos/anim/demo_anim_physics_drag.dart';
import 'package:flutter_gallery_next/biz/demos/anim/demo_anim_random.dart';

class DemoAnim extends StatelessWidget {
  const DemoAnim({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Anim'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, "Implicit Animations"),
          _buildDemoTile(
            context,
            "Opacity Transition",
            "Smoothly fade widgets in and out.",
            Icons.blur_on,
            () => _go(context, const DemoAnimOpacityPage()),
          ),
          _buildDemoTile(
            context,
            "Random Shape & Color",
            "AnimatedContainer with random properties.",
            Icons.shuffle,
            () => _go(context, const DemoAnimRandomPage()),
          ),
          const Divider(height: 32),
          _buildSectionHeader(context, "Explicit & Physics"),
          _buildDemoTile(
            context,
            "Physics-based Drag",
            "An element that snaps back with spring physics.",
            Icons.touch_app,
            () => _go(context, const DemoAnimPhysicsDragPage()),
          ),
          const Divider(height: 32),
          _buildSectionHeader(context, "Advanced Effects"),
          _buildDemoTile(
            context,
            "Hero Transitions",
            "Shared element transitions between screens.",
            Icons.auto_fix_high,
            () => _go(context, const _DemoHeroList()),
          ),
        ],
      ),
    );
  }

  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child:
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  Widget _buildDemoTile(BuildContext context, String title, String sub, IconData icon, VoidCallback onTap) {
    final colors = AppTheme.colors(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: colors.blue100, child: Icon(icon, color: colors.blue600, size: 20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(sub, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, size: 18),
        onTap: onTap,
      ),
    );
  }
}

// --- Placeholder for Hero Animation Demo ---
class _DemoHeroList extends StatelessWidget {
  const _DemoHeroList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hero Animation")),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Hero(
              tag: 'demo-hero',
              child: Container(
                  width: 100, height: 100, color: Colors.blue, child: const Icon(Icons.star, color: Colors.white, size: 50)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const _DemoHeroDetail())),
              child: const Text("View Detail"),
            )
          ],
        ),
      ),
    );
  }
}

class _DemoHeroDetail extends StatelessWidget {
  const _DemoHeroDetail();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hero Detail")),
      body: Column(
        children: [
          Hero(
            tag: 'demo-hero',
            child: Container(
                width: double.infinity,
                height: 300,
                color: Colors.blue,
                child: const Icon(Icons.star, color: Colors.white, size: 150)),
          ),
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text("The star icon smoothly expanded from the previous screen using a Hero animation."),
          )
        ],
      ),
    );
  }
}
