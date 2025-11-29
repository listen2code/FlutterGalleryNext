import 'package:flutter/cupertino.dart';
import 'package:flutter_gallery_next/base/mvvm/vm/base_view_model.dart';
import 'package:flutter_gallery_next/base/network/base/base_api_use_case.dart';
import 'package:get/get.dart';

class AutoLoadWidget<T, VM extends ViewModel> extends StatelessWidget {
  final VM viewMode;
  final Rx<ResponseEntity<T>> rxResponse;
  final Widget Function(T data) widget;
  final Widget Function(String? error)? onError;
  final Widget Function(String? error)? onSystemError;
  final Widget Function(String? error)? onSessionTimeout;
  final Widget Function(String? error)? onNetworkError;
  final Widget? onLoading;

  final Widget? onEmpty;

  final bool autoEmpty;

  const AutoLoadWidget({
    super.key,
    required this.viewMode,
    required this.rxResponse,
    required this.widget,
    this.onError,
    this.onSystemError,
    this.onSessionTimeout,
    this.onNetworkError,
    this.onLoading,
    this.onEmpty,
    this.autoEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => rxResponse.value.observe(
        (data) => widget(data),
        onError: onError,
        onSystemError: onSystemError,
        onSessionTimeout: onSessionTimeout,
        onNetworkError: onNetworkError,
        onLoading: onLoading,
        onEmpty: onEmpty,
        autoEmpty: autoEmpty,
      ),
    );
  }
}
