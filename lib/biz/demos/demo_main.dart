import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/pages.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';
import 'package:package_base/function_proxy_util.dart';

class DemoMainPage extends StatelessWidget {
  const DemoMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    // Get the grouped categories from the centralized DemoConfigs
    final Map<String, List<DemoConfig>> groupedDemos = {};
    for (var config in Constant.demoConfigs) {
      groupedDemos.putIfAbsent(config.category, () => []).add(config);
    }

    // Determine category icons
    final Map<String, IconData> categoryIcons = {
      Constant.catCore: Icons.palette_outlined,
      Constant.catUI: Icons.layers_outlined,
      Constant.catLogic: Icons.bolt_outlined,
      Constant.catStorage: Icons.storage_outlined,
    };

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Listen Gallery", style: TextStyle(color: colors.foreground, fontWeight: FontWeight.bold)),
              background: Container(color: colors.blue100),
            ),
          ),
          ...groupedDemos.entries.map((entry) {
            return _buildCategorySliver(
              context,
              entry.key,
              categoryIcons[entry.key] ?? Icons.category_outlined,
              entry.value,
            );
          }).toList(),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildCategorySliver(BuildContext context, String title, IconData icon, List<DemoConfig> items) {
    final colors = AppTheme.colors(context);

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Row(
              children: [
                Icon(icon, size: 20, color: colors.blue500),
                const SizedBox(width: 8),
                Text(title, style: TextStyle(color: colors.neutral900, fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = items[index];
                return _buildDemoCard(context, item);
              },
              childCount: items.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDemoCard(BuildContext context, DemoConfig item) {
    final colors = AppTheme.colors(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(item.route);
      }.throttle(milliseconds: 1000),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.neutral200),
          boxShadow: [
            BoxShadow(color: colors.foreground.withAlpha(10), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: colors.blue100,
              child: Icon(item.icon, size: 18, color: colors.blue600),
            ),
            Text(
              item.title,
              style: TextStyle(color: colors.neutral1000, fontWeight: FontWeight.w600, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
