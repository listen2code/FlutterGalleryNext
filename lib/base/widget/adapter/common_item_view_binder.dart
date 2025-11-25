import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/widget/adapter/common_multi_type_adapter.dart';

abstract class ItemViewBinder<T> {
  MultiTypeAdapter? adapter;

  bool isMatch(dynamic item, int index) {
    return item.runtimeType == T;
  }

  Linker<T>? findLinker(T item, int index) {
    Linker? linker = adapter?.links[item.runtimeType.hashCode];
    if (linker != null) {
      return linker as Linker<T>;
    } else {
      return null;
    }
  }

  Widget buildWidget(BuildContext context, T item, int index);
}
