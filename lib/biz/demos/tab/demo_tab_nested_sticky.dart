// dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_resource.dart';

class DemoTabNestedSticky extends StatefulWidget {
  const DemoTabNestedSticky({super.key});

  @override
  State<DemoTabNestedSticky> createState() => _DemoTabNestedStickyState();
}

class _DemoTabNestedStickyState extends State<DemoTabNestedSticky> with TickerProviderStateMixin {
  late TabController _outerController;
  late TabController _innerController;

  // 外层 NestedScrollView 的控制器（用于手动滚动外层）
  late ScrollController _outerScrollController;

  // 每个内层 list 的控制器
  late List<ScrollController> _innerListControllers;

  @override
  void initState() {
    super.initState();
    _outerController = TabController(length: 3, vsync: this);
    _innerController = TabController(length: 5, vsync: this);

    _outerScrollController = ScrollController();
    _innerListControllers = List.generate(_innerController.length, (_) => ScrollController());
  }

  @override
  void dispose() {
    _outerController.dispose();
    _innerController.dispose();
    _outerScrollController.dispose();
    for (final c in _innerListControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Nested Sticky Tabs')),
      body: NestedScrollView(
        controller: _outerScrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          final handle = NestedScrollView.sliverOverlapAbsorberHandleFor(context);
          return [
            // 顶部 header 现在是可滚动的 SliverToBoxAdapter，
            // 在内层内容向上滑动时会随之一起收起。
            SliverToBoxAdapter(
              child: Container(
                color: colors.background,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('顶部 Header 内容'),
                    const SizedBox(height: 8),
                    Text('这里可以放 banner、用户信息等'),
                  ],
                ),
              ),
            ),

            // 外层 TabBar：包在 SliverOverlapAbsorber 中，但不 pinned，允许被收起
            SliverOverlapAbsorber(
              handle: handle,
              sliver: SliverPersistentHeader(
                pinned: false,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _outerController,
                    labelColor: colors.blue600,
                    unselectedLabelColor: colors.neutral500,
                    indicatorColor: colors.blue600,
                    tabs: const [
                      Tab(text: "Nested"),
                      Tab(text: "Category A"),
                      Tab(text: "Category B"),
                    ],
                  ),
                  backgroundColor: colors.background,
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _outerController,
          children: [
            _buildInnerNestedSection(colors),
            _buildSimpleScrollTab("Category A Content", colors.rose100),
            _buildSimpleScrollTab("Category B Content", colors.green100),
          ],
        ),
      ),
    );
  }

  Widget _buildInnerNestedSection(BaseThemeColors colors) {
    return Builder(builder: (context) {
      return CustomScrollView(
        key: const PageStorageKey('innerTabScroll'),
        slivers: [
          // 注入外层重叠句柄（与 SliverOverlapAbsorber 配合）
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),

          // 在一级 Tab 与二级 Tab 之间的中间内容（示例）
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('一级 Tab 与二级 Tab 之间的内容'),
                  SizedBox(height: 8),
                  Text('可以放统计卡片、过滤控件等'),
                ],
              ),
            ),
          ),

          // 内层 TabBar（sticky）
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _innerController,
                isScrollable: true,
                labelColor: colors.rose600,
                unselectedLabelColor: colors.neutral500,
                indicatorColor: colors.rose600,
                tabAlignment: TabAlignment.start,
                tabs: const [
                  Tab(text: "SubTab 1"),
                  Tab(text: "SubTab 2"),
                  Tab(text: "SubTab 3"),
                  Tab(text: "SubTab 4"),
                  Tab(text: "SubTab 5"),
                ],
              ),
              backgroundColor: colors.neutral100,
            ),
          ),

          // 内层 TabBarView（每页包含自己的可滚动列表）
          SliverFillRemaining(
            child: TabBarView(
              controller: _innerController,
              children: List.generate(
                5,
                (index) => Builder(builder: (context) {
                  // 使用自定义协调的列表，优先滚动外层 _outerScrollController
                  return _CoordinatedListView(
                    outerController: _outerScrollController,
                    innerController: _innerListControllers[index],
                    itemCount: max(20, Random().nextInt(100)),
                    buildItem: (context, i) => ListTile(
                      title: Text("Inner Tab ${index + 1} - Item $i"),
                      subtitle: const Text("Complex scrolling logic in action"),
                      dense: true,
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSimpleScrollTab(String name, Color bgColor) {
    return Builder(builder: (context) {
      return CustomScrollView(
        key: PageStorageKey('simpleTab-$name'),
        slivers: [
          SliverOverlapInjector(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Container(
                color: bgColor.withAlpha(30),
                child: ListTile(
                  title: Text("$name Item $i"),
                  leading: const Icon(Icons.circle, size: 12),
                ),
              ),
              childCount: 30,
            ),
          ),
        ],
      );
    });
  }
}

/// Simple delegate for a fixed-height box (保留以备需要)
class _SliverBoxDelegate extends SliverPersistentHeaderDelegate {
  _SliverBoxDelegate(this.child, {required this.height});

  final Widget child;
  final double height;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverBoxDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}

/// A specialized delegate to allow TabBar to remain sticky within a CustomScrollView/NestedScrollView.
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar, {required this.backgroundColor});

  final TabBar _tabBar;
  final Color backgroundColor;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}

/// 协调外层与内层滚动的列表控件
class _CoordinatedListView extends StatefulWidget {
  const _CoordinatedListView({
    required this.outerController,
    required this.innerController,
    required this.itemCount,
    required this.buildItem,
    super.key,
  });

  final ScrollController outerController;
  final ScrollController innerController;
  final int itemCount;
  final IndexedWidgetBuilder buildItem;

  @override
  State<_CoordinatedListView> createState() => _CoordinatedListViewState();
}

class _CoordinatedListViewState extends State<_CoordinatedListView> {
  // 使用 GestureDetector 手动驱动两个控制器之一
  void _handleDragUpdate(DragUpdateDetails details) {
    final dy = details.delta.dy;
    final outer = widget.outerController;
    final inner = widget.innerController;

    if (!outer.hasClients || !inner.hasClients) {
      // fallback：直接移动 inner
      _safeJump(inner, -dy);
      return;
    }

    final outerPos = outer.position.pixels;
    final outerMin = outer.position.minScrollExtent;
    final outerMax = outer.position.maxScrollExtent;

    final innerPos = inner.position.pixels;
    final innerMin = inner.position.minScrollExtent;
    final innerMax = inner.position.maxScrollExtent;

    // dy < 0: 手指向上滑，内容向上（优先收起 header -> 外层）
    if (dy < 0) {
      final canScrollOuterUp = outerPos < outerMax - 0.5;
      if (canScrollOuterUp) {
        _safeJump(outer, -dy);
      } else {
        _safeJump(inner, -dy);
      }
      return;
    }

    // dy > 0: 手指向下滑，内容向下（优先滚动内层，内层到顶后才展开 header -> 外层）
    if (dy > 0) {
      final canScrollInnerDown = innerPos > innerMin + 0.5;
      if (canScrollInnerDown) {
        _safeJump(inner, -dy);
      } else {
        _safeJump(outer, -dy);
      }
      return;
    }
  }

  void _safeJump(ScrollController c, double offsetDelta) {
    try {
      if (!c.hasClients) return;
      final pos = c.position.pixels;
      final min = c.position.minScrollExtent;
      final max = c.position.maxScrollExtent;
      final target = (pos + offsetDelta).clamp(min, max);
      c.jumpTo(target);
    } catch (_) {
      // ignore if position not ready
    }
  }

  @override
  Widget build(BuildContext context) {
    // 禁止 ListView 自身的滚动手势，全部由外层 GestureDetector 驱动
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: _handleDragUpdate,
      child: ListView.builder(
        controller: widget.innerController,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.itemCount,
        itemBuilder: widget.buildItem,
      ),
    );
  }
}
