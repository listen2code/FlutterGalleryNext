import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';

class DemoGrid extends StatelessWidget {
  const DemoGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo Grid'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDemoTile(
            context,
            "Complex Sliver Grid",
            "Mixed layouts using Slivers for advanced scrolling effects.",
            Icons.dashboard_customize_outlined,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const _DemoGridComplex())),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoTile(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    final colors = AppTheme.colors(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colors.blue100,
          child: Icon(icon, color: colors.blue600),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _DemoGridComplex extends StatelessWidget {
  const _DemoGridComplex();

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text("Complex Grid Layout"),
            pinned: true,
            expandedHeight: 56,
            actions: [
              IconButton(
                onPressed: () {
                  final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
                  if (isPortrait) {
                    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                  } else {
                    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                  }
                },
                icon: const Icon(Icons.screen_rotation),
                tooltip: "Toggle Orientation",
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 120,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.blue500,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                  child:
                      Text("Featured Banner", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                  decoration: BoxDecoration(
                    color: colors.neutral100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.neutral200),
                  ),
                  child: Center(child: Text("Main $index", style: const TextStyle(fontWeight: FontWeight.bold))),
                ),
                childCount: 4,
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text("Compact Grid", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
          )),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 120,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                  decoration: BoxDecoration(
                    color: colors.blue100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: Text("S $index", style: TextStyle(color: colors.blue700, fontSize: 12))),
                ),
                childCount: 12,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
