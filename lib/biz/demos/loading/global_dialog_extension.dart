import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/biz/demos/loading/global_dialog.dart';

extension DialogStateExtension on State {
  void dismissDialog() {
    GlobalDialog.dismissDialog(context);
  }

  void showMessageDialog(String message, {bool? barrierDismissible, String? title, String? okText, VoidCallback? onOkPressed}) {
    GlobalDialog.showMessageDialog(message, context, barrierDismissible: barrierDismissible, title: title, okText: okText, onOkPressed: onOkPressed);
  }

  void showConfirmDialog(String message,
      {BuildContext? contextParam,
      bool? barrierDismissible,
      String? title,
      String? okText,
      String? cancelText,
      VoidCallback? onOkPressed,
      VoidCallback? onCancelPressed}) {
    GlobalDialog.showConfirmDialog(message, context,
        barrierDismissible: barrierDismissible,
        title: title,
        okText: okText,
        cancelText: cancelText,
        onOkPressed: onOkPressed,
        onCancelPressed: onCancelPressed);
  }

  void showCustomDialog(Widget builder, {bool? barrierDismissible}) {
    GlobalDialog.showCustomDialog(builder, context, barrierDismissible: barrierDismissible);
  }
}

extension DialogStalessWidgetExtension on StatelessWidget {
  void dismissDialog(context) {
    GlobalDialog.dismissDialog(context);
  }

  void showMessageDialog(context, String message, {bool? barrierDismissible, String? title, String? okText, VoidCallback? onOkPressed}) {
    GlobalDialog.showMessageDialog(message, context, barrierDismissible: barrierDismissible, title: title, okText: okText, onOkPressed: onOkPressed);
  }

  void showConfirmDialog(context, String message,
      {bool? barrierDismissible, String? title, String? okText, String? cancelText, VoidCallback? onOkPressed, VoidCallback? onCancelPressed}) {
    GlobalDialog.showConfirmDialog(message, context,
        barrierDismissible: barrierDismissible,
        title: title,
        okText: okText,
        cancelText: cancelText,
        onOkPressed: onOkPressed,
        onCancelPressed: onCancelPressed);
  }

  void showCustomDialog(context, Widget builder, {bool? barrierDismissible}) {
    GlobalDialog.showCustomDialog(builder, context, barrierDismissible: barrierDismissible);
  }
}
