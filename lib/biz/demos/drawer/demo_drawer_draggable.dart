import 'package:flutter/material.dart';

class DemoDrawerDraggable extends StatelessWidget {
  const DemoDrawerDraggable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('demo drawer draggable'),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.green,
            child: ListView.builder(
              itemCount: 30, // 假设有30个列表项
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.15,
            // 初始高度
            minChildSize: 0.15,
            // 最小高度
            maxChildSize: 1,
            // 最大高度
            snap: true,
            snapSizes: const [0.5, 1],
            snapAnimationDuration: const Duration(milliseconds: 200),
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                color: Colors.red,
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 30, // 假设有30个列表项
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return Container(
                        height: 100,
                        color: Colors.grey,
                        child: Center(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text("menu"),
                          ),
                        ),
                      );
                    }
                    return ListTile(
                      title: Text('Item $index'),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
