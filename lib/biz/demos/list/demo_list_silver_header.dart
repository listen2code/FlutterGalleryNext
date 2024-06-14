import 'package:flutter/material.dart';

class DemoListFixHeader extends StatelessWidget {
  const DemoListFixHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Fix header';

    return MaterialApp(
      title: title,
      home: Scaffold(
        // No appbar provided to the Scaffold, only a body with a
        // CustomScrollView.
        body: CustomScrollView(
          slivers: [
            // Add the app bar to the CustomScrollView.
            SliverPersistentHeader(
              delegate: MySliverPersistentHeaderDelegate(),
              pinned: true, // 设置头部固定在顶部
            ),
            // Next, create a SliverList
            SliverList(
              // Use a delegate to build items as they're scrolled on screen.
              delegate: SliverChildBuilderDelegate(
                // The builder function returns a ListTile with a title that
                // displays the index of the current item.
                    (context, index) => ListTile(title: Text('Item #$index')),
                // Builds 1000 ListTiles
                childCount: 1000,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 100.0; // 最小高度

  @override
  double get maxExtent => 100.0; // 最大高度

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.blue,
      alignment: Alignment.center,
      child: Text(
        'Header',
        style: TextStyle(color: Colors.white, fontSize: 24.0),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}