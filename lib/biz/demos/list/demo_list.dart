import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';
import 'package:flutter_gallery_next/base/common/theme/color/base_theme_colors.dart';

class DemoList extends StatelessWidget {
  const DemoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo List')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildDemoTile(context, "Basic List", "Standard vertical list with icons.", Icons.list,
              () => _go(context, const _DemoListBasic())),
          _buildDemoTile(context, "Horizontal List", "Scrolling items from left to right.", Icons.linear_scale,
              () => _go(context, const _DemoListHorizontal())),
          _buildDemoTile(context, "Infinite/Long List", "Building 10,000+ items efficiently.", Icons.format_list_numbered,
              () => _go(context, const _DemoListLong())),
          _buildDemoTile(context, "Multi-Type Items", "Mixing different layouts in one list.", Icons.dashboard_customize,
              () => _go(context, const _DemoListMulti())),
          _buildDemoTile(context, "Swipe to Dismiss", "Gesture-based deletion with UNDO support.", Icons.delete_sweep,
              () => _go(context, const _DemoListDismiss())),
          _buildDemoTile(context, "Refresh & Load More", "Pull to refresh and infinite scroll.", Icons.refresh,
              () => _go(context, const _DemoListRefresh())),
          _buildDemoTile(context, "Sliver App Bar", "A list with a collapsing image header.", Icons.vertical_align_top,
              () => _go(context, const _DemoListSliverBar())),
          _buildDemoTile(context, "Sliver Sticky Header", "Pinned section headers while scrolling.", Icons.view_agenda,
              () => _go(context, const _DemoListSliverHeader())),
        ],
      ),
    );
  }

  void _go(BuildContext context, Widget page) => Navigator.push(context, MaterialPageRoute(builder: (context) => page));

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

// --- 1. Basic List ---
class _DemoListBasic extends StatelessWidget {
  const _DemoListBasic();

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Basic List")),
      body: ListView(
        children: List.generate(
            15,
            (i) => ListTile(
                  leading: Icon(Icons.star_border, color: colors.amber500),
                  title: Text("Basic Item $i", style: TextStyle(color: colors.foreground)),
                  subtitle: const Text("Simple subtitle text"),
                  onTap: () {},
                )),
      ),
    );
  }
}

// --- 2. Horizontal List ---
class _DemoListHorizontal extends StatelessWidget {
  const _DemoListHorizontal();

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Horizontal List")),
      body: Center(
        child: SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 10,
            itemBuilder: (context, i) => Container(
              width: 160,
              margin: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: [colors.blue500, colors.rose500, colors.green500, colors.amber500][i % 4],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Center(child: Text("Card $i", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            ),
          ),
        ),
      ),
    );
  }
}

// --- 3. Long List ---
class _DemoListLong extends StatelessWidget {
  const _DemoListLong();

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    return Scaffold(
      appBar: AppBar(title: const Text("10,000 Items List")),
      body: ListView.builder(
        itemCount: 10000,
        prototypeItem: const ListTile(title: Text("Placeholder")),
        itemBuilder: (context, i) => ListTile(
          title: Text("Efficient Item #$i", style: TextStyle(color: colors.foreground)),
          leading: Text("${i + 1}", style: TextStyle(color: colors.neutral400, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}

// --- 4. Multi-Type List ---
class _DemoListMulti extends StatelessWidget {
  const _DemoListMulti();

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Multi-Type Items")),
      body: ListView.builder(
        itemCount: 50,
        itemBuilder: (context, i) {
          if (i % 5 == 0) {
            return Container(
              padding: const EdgeInsets.all(16),
              color: colors.neutral100,
              child: Text("SECTION HEADER ${i ~/ 5}",
                  style: TextStyle(color: colors.blue600, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            );
          }
          return ListTile(
            leading: CircleAvatar(backgroundColor: colors.neutral200, radius: 16),
            title: Text("Standard Item $i"),
            subtitle: const Text("Layout Variation A"),
          );
        },
      ),
    );
  }
}

// --- 5. Swipe to Dismiss ---
class _DemoListDismiss extends StatefulWidget {
  const _DemoListDismiss();

  @override
  State<_DemoListDismiss> createState() => _DemoListDismissState();
}

class _DemoListDismissState extends State<_DemoListDismiss> {
  final items = List<String>.generate(20, (i) => "Dismissible Item ${i + 1}");

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Swipe to Dismiss")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, i) {
          final item = items[i];
          return Dismissible(
            key: Key(item),
            onDismissed: (_) {
              setState(() => items.removeAt(i));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("$item removed"),
                  action: SnackBarAction(label: "UNDO", onPressed: () => setState(() => items.insert(i, item)))));
            },
            background: Container(
                color: colors.red500,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                child: const Icon(Icons.delete, color: Colors.white)),
            secondaryBackground: Container(
                color: colors.red500,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white)),
            child: ListTile(title: Text(item), leading: const Icon(Icons.drag_handle)),
          );
        },
      ),
    );
  }
}

// --- 6. Refresh & Load ---
class _DemoListRefresh extends StatefulWidget {
  const _DemoListRefresh();

  @override
  State<_DemoListRefresh> createState() => _DemoListRefreshState();
}

class _DemoListRefreshState extends State<_DemoListRefresh> {
  final ScrollController _scrollController = ScrollController();
  List<int> data = List.generate(20, (i) => i);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      final lastItem = data.last;
      data.addAll(List.generate(20, (i) => lastItem + i + 1));
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Refresh & Load More")),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          if (!mounted) return;
          setState(() => data = List.generate(20, (i) => i + 100));
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount: data.length + (_isLoading ? 1 : 0),
          itemBuilder: (context, i) {
            if (i == data.length) {
              return const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            return ListTile(
              title: Text("Dynamic Data Item ${data[i]}"),
              leading: const Icon(Icons.sync),
              subtitle: Text("Index: $i"),
            );
          },
        ),
      ),
    );
  }
}

// --- 7. Sliver Bar ---
class _DemoListSliverBar extends StatelessWidget {
  const _DemoListSliverBar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("Collapsing Header"),
              background: Image.network("https://picsum.photos/800/400?random=1", fit: BoxFit.cover),
            ),
          ),
          SliverList(delegate: SliverChildBuilderDelegate((_, i) => ListTile(title: Text("Sliver Item $i")), childCount: 50)),
        ],
      ),
    );
  }
}

// --- 8. Sliver Header ---
class _DemoListSliverHeader extends StatelessWidget {
  const _DemoListSliverHeader();

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text("Sticky Headers"), pinned: true),
          for (var section in [1, 2, 3]) ...[
            SliverPersistentHeader(pinned: true, delegate: _MyHeaderDelegate("Section $section", colors)),
            SliverList(
                delegate:
                    SliverChildBuilderDelegate((_, i) => ListTile(title: Text("Item $i in Section $section")), childCount: 10)),
          ],
        ],
      ),
    );
  }
}

class _MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final BaseThemeColors colors;

  _MyHeaderDelegate(this.title, this.colors);

  @override
  Widget build(context, shrink, overlaps) => Container(
      color: colors.blue600,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate old) => false;
}
