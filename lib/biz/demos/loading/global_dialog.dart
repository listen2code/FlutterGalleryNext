import 'package:flutter/material.dart';

class GlobalDialog {
  static bool dismissRoute(Route<dynamic>? route) {
    if (route is DialogRoute) {
      debugPrint("route is DialogRoute");
      return false;
    } else {
      debugPrint("route is not DialogRoute");
      return true;
    }
  }

  static void dismissAllDialog(BuildContext context) {
    Navigator.of(context).popUntil((route) => dismissRoute(route));
  }

  static void dismissDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void showMessageDialog(String message, BuildContext context,
      {bool? barrierDismissible,
      String? title,
      String? okText,
      VoidCallback? onOkPressed}) {
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible ?? false,
        builder: (BuildContext context) {
          return Dialog(
            child: buildMessageDialog(
                title, message, onOkPressed, context, okText),
          );
        }).whenComplete(() => {debugPrint("whenComplete")});
  }

  static void showConfirmDialog(String message, BuildContext context,
      {bool? barrierDismissible,
      String? title,
      String? okText,
      String? cancelText,
      VoidCallback? onOkPressed,
      VoidCallback? onCancelPressed}) {
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible ?? false,
        builder: (BuildContext context) {
          return Dialog(
            child: buildConfirmDialog(title, message, onCancelPressed, context,
                cancelText, onOkPressed, okText),
          );
        }).whenComplete(() => {debugPrint("whenComplete")});
  }

  static void showCustomDialog(Widget builder, BuildContext context,
      {bool? barrierDismissible}) {
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible ?? false,
        builder: (BuildContext context) {
          return Dialog(
            child: builder,
          );
        });
  }

  static Widget initTitle(String? title) {
    if (title?.isNotEmpty == true) {
      return Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
        child: Center(
            child: Text(
          title ?? "",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )),
      );
    } else {
      return const SizedBox(
        height: 0,
      );
    }
  }

  static BoxDecoration initBoxDecoration() {
    return const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: Colors.white,
    );
  }

  static Container buildMessageDialog(String? title, String message,
      VoidCallback? onOkPressed, BuildContext context, String? okText) {
    return Container(
      decoration: initBoxDecoration(),
      padding: const EdgeInsetsDirectional.all(5),
      child: IntrinsicHeight(
        child: Column(
          children: [
            const SizedBox(height: 5),
            initTitle(title),
            const SizedBox(height: 5),
            ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 100,
                maxHeight: 400,
              ),
              child: Text(message),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 100,
                    child: ElevatedButton(
                        onPressed: () {
                          if (null != onOkPressed) {
                            onOkPressed.call();
                          } else {
                            dismissDialog(context);
                          }
                        },
                        child: Text(okText ?? "ok"))),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  static Container buildConfirmDialog(
      String? title,
      String message,
      VoidCallback? onCancelPressed,
      BuildContext context,
      String? cancelText,
      VoidCallback? onOkPressed,
      String? okText) {
    return Container(
      decoration: initBoxDecoration(),
      padding: const EdgeInsetsDirectional.all(5),
      child: IntrinsicHeight(
        child: Column(
          children: [
            const SizedBox(height: 5),
            initTitle(title),
            const SizedBox(height: 5),
            ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 100,
                maxHeight: 400,
              ),
              child: Text(message),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    width: 100,
                    child: ElevatedButton(
                        onPressed: () {
                          if (null != onCancelPressed) {
                            onCancelPressed.call();
                          } else {
                            dismissDialog(context);
                          }
                        },
                        child: Text(cancelText ?? "cancel"))),
                SizedBox(
                    width: 100,
                    child: ElevatedButton(
                        onPressed: () {
                          if (null != onOkPressed) {
                            onOkPressed.call();
                          } else {
                            dismissDialog(context);
                          }
                        },
                        child: Text(okText ?? "ok"))),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
