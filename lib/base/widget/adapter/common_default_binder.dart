import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/widget/adapter/common_item_view_binder.dart';

class DefaultDebugViewBinder<T> extends ItemViewBinder<T> {
  @override
  Widget buildWidget(BuildContext context, item, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[600],
        border: const Border(
          bottom: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("WARNING！！！\nindex: $index\nitem: $item\n"),
          Text(
            "This item is not register bind view \n please check it",
            style: TextStyle(color: Colors.grey[200]),
          ),
        ],
      ),
    );
  }

  @override
  bool isMatch(dynamic item, int index) {
    return item != null;
  }
}
