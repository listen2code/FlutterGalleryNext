import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/widget/base/global_navigation.dart';

class GlobalLoading extends StatelessWidget {
  final Widget? child;
  static bool isDialogExists = false;

  const GlobalLoading({super.key, this.child});

  static TransitionBuilder init() {
    return (BuildContext context, Widget? child) {
      return GlobalLoading(child: child);
    };
  }

  static void showLoading() {
    final context = GlobalNavigation.navigatorKey.currentContext;
    if (context == null || isDialogExists) return;

    isDialogExists = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const PopScope(
          canPop: false,
          child: Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      },
    ).then((_) => isDialogExists = false);
  }

  static void dismiss() {
    final context = GlobalNavigation.navigatorKey.currentContext;
    if (isDialogExists && context != null) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return child ?? const SizedBox.shrink();
  }
}
