import 'package:flutter/cupertino.dart';
import 'package:flutter_gallery_next/base/mvvm/view_mode/base_view_mode.dart';
import 'package:flutter_gallery_next/base/network/base/base_api_use_case.dart';
import 'package:get/get.dart';

class PartLoadWidget<T, VM extends ViewMode> extends StatelessWidget {
  final String? id;
  final VM viewMode;
  final ResponseEntity<T> Function() response;
  final Widget Function(T data) widget;
  final Widget Function(String? error)? onError;
  final Widget? onLoading;
  final Widget? onEmpty;

  const PartLoadWidget({
    super.key,
    this.id,
    required this.viewMode,
    required this.widget,
    this.onError,
    this.onLoading,
    this.onEmpty,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VM>(
      builder: (viewMode) => response().observe(
        (data) => widget(data),
        onError: onError,
        onLoading: onLoading,
        onEmpty: onEmpty,
      ),
      id: id,
    );
  }
}
