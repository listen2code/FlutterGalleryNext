import 'package:flutter/material.dart';

class GlobalLoading extends StatefulWidget {
  static BuildContext? globalContext;
  Widget? child;
  static bool isDialogExists = false;

  GlobalLoading({super.key, required this.child});

  static TransitionBuilder init() {
    return (BuildContext context, Widget? child) {
      return GlobalLoading(child: child);
    };
  }

  static void showLoading() {
    isDialogExists = true;
    showDialog(
        context: GlobalLoading.globalContext!,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator(color: Colors.white,));
        }
    );
  }

  static void dismiss() {
    if (isDialogExists) {
      Navigator.of(GlobalLoading.globalContext!).pop();
    }
  }

  @override
  State<GlobalLoading> createState() => _GlobalLoadingState();
}

class _GlobalLoadingState extends State<GlobalLoading> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BuildContext? context;
      if (widget.child is Navigator) {
        context = getNavigationContext(widget.child as Navigator);
      } else if (widget.child is FocusScope) {
        var focusScope = widget.child as FocusScope;
        if (focusScope.child is Navigator) {
          context = getNavigationContext(focusScope.child as Navigator);
        }
      }
      GlobalLoading.globalContext = context;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? Container();
  }

  BuildContext? getNavigationContext(Navigator navigator) {
    BuildContext? context;
    if (navigator.key is GlobalKey) {
      context = (navigator.key as GlobalKey).currentContext!;
    }
    return context;
  }
}