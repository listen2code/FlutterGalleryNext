import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';
import 'package:flutter_gallery_next/base/common/theme/color/base_theme_colors.dart';

class DemoTabBar extends StatefulWidget {
  const DemoTabBar({super.key});

  @override
  State<DemoTabBar> createState() => _DemoTabBarState();
}

class _DemoTabBarState extends State<DemoTabBar> with TickerProviderStateMixin {
  late TabController _capsuleController;
  late TabController _scrollableController;

  @override
  void initState() {
    super.initState();
    _capsuleController = TabController(length: 3, vsync: this);
    _scrollableController = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    _capsuleController.dispose();
    _scrollableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo TabBar'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildSectionTitle(context, "1. Capsule & Segmented style"),
            _buildCapsuleTabBar(colors),
            const SizedBox(height: 40),
            _buildSectionTitle(context, "2. Icons with Badges"),
            _buildBadgeTabBar(colors),
            const SizedBox(height: 40),
            _buildSectionTitle(context, "3. Custom Styled & Scrollable"),
            _buildScrollableCustomTabBar(colors),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCapsuleTabBar(BaseThemeColors colors) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colors.neutral100,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _capsuleController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: colors.blue500,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: colors.neutral600,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: "Inbox"),
          Tab(text: "Archived"),
          Tab(text: "Deleted"),
        ],
      ),
    );
  }

  Widget _buildBadgeTabBar(BaseThemeColors colors) {
    return TabBar(
      controller: _capsuleController,
      labelColor: colors.blue600,
      unselectedLabelColor: colors.neutral500,
      indicatorColor: colors.blue600,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: [
        const Tab(icon: Icon(Icons.home), text: "Home"),
        Tab(
          icon: Badge(
            label: const Text('3'),
            child: const Icon(Icons.notifications),
          ),
          text: "Alerts",
        ),
        const Tab(icon: Icon(Icons.person), text: "Profile"),
      ],
    );
  }

  Widget _buildScrollableCustomTabBar(BaseThemeColors colors) {
    return Column(
      children: [
        Container(
          color: colors.blue600,
          child: TabBar(
            controller: _scrollableController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: Colors.white,
            indicatorWeight: 4,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withAlpha(150),
            tabs: const [
              Tab(text: "Tech"),
              Tab(text: "Life"),
              Tab(text: "Biz"),
              Tab(text: "Ent"),
              Tab(text: "Health"),
              Tab(text: "Sci"),
              Tab(text: "Sports"),
              Tab(text: "World"),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: TabBarView(
            controller: _scrollableController,
            children: List.generate(8, (i) => _buildPlaceholder("Scrollable View ${i + 1}")),
          ),
        )
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String text, {Key? key}) {
    return Center(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(text, style: const TextStyle(fontStyle: FontStyle.italic)),
      ),
    );
  }
}
