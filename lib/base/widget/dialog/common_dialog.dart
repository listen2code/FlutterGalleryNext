import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_resource.dart';
import 'package:flutter_gallery_next/base/common/theme/color/theme_colors.dart';
import 'package:flutter_gallery_next/base/common/translations/app_translations.dart';
import 'package:flutter_gallery_next/base/widget/text/common_text.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

class GlobalDialog {
  static VoidCallback emptyCallback = () {
    dismissDialog();
  };

  static const double _minHeight = 60;

  static const double _maxWidth = 320;

  static const double _maxHeight = 400;

  static const double _maxBottomHeight = 400;

  static const double _buttonWidth = 110;

  static const double _columnButtonWidth = 150;

  static const String _default = "";

  static final String _defaultOk = AppLocalizations.btnOkName.tr;

  static final String _defaultCancel = AppLocalizations.btnCancelName.tr;

  static void showToast(String message) {
    SmartDialog.showToast(message,
        displayTime: const Duration(milliseconds: 2000));
  }

  static void showLongToast(String message) {
    SmartDialog.showToast(message,
        displayTime: const Duration(milliseconds: 3500));
  }

  static void showLoading() {
    SmartDialog.showLoading();
  }

  static void dismissLoading() {
    SmartDialog.dismiss(status: SmartStatus.loading);
  }

  static void dismissAllDialog() {
    SmartDialog.dismiss(status: SmartStatus.allDialog);
  }

  static void dismissDialog({String? tag}) {
    SmartDialog.dismiss(tag: tag);
  }

  static void showMessageDialog(
    String message, {
    bool? clickMaskDismiss = true,
    bool? keepSingle = false,
    bool? backDismiss = true,
    bool? contentCenter = false,
    String? tag,
    String? title,
    String? okText,
    VoidCallback? onOkPressed,
    VoidCallback? onDismiss,
    VoidCallback? closeAfter,
  }) {
    SmartDialog.show(
        useAnimation: true,
        clickMaskDismiss: clickMaskDismiss,
        keepSingle: keepSingle,
        backDismiss: backDismiss,
        onDismiss: onDismiss,
        tag: tag,
        builder: (_) {
          return _buildMessageDialogFresh(
            title,
            message,
            contentCenter,
            okText,
            onOkPressed,
          );
        }).then((value) {
      var after = closeAfter;
      if (after != null) {
        after();
      }
    });
  }

  static Container _buildMessageDialog(String? title, String message,
      bool? contentCenter, String? okText, VoidCallback? onOkPressed) {
    return Container(
      width: _maxWidth,
      decoration: _initBoxDecoration(),
      padding: const EdgeInsetsDirectional.only(
          start: 10, end: 10, top: 5, bottom: 5),
      child: IntrinsicHeight(
        child: Column(
          children: [
            const SizedBox(height: 5),
            _initTitle(title),
            const SizedBox(height: 5),
            _initContent(message, contentCenter),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: _buttonWidth,
                    child: ElevatedButton(
                        onPressed: () {
                          if (null != onOkPressed) {
                            Future.delayed(Duration.zero, () {
                              onOkPressed.call();
                            });
                          } else {
                            dismissDialog();
                          }
                        },
                        child: CommonText(okText ?? _defaultOk))),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  static void showConfirmDialog(
    String message, {
    bool? clickMaskDismiss = true,
    bool? keepSingle = false,
    bool? backDismiss = true,
    bool? contentCenter = false,
    String? tag,
    String? title,
    String? okText,
    String? cancelText,
    VoidCallback? onOkPressed,
    VoidCallback? onCancelPressed,
    VoidCallback? onDismiss,
  }) {
    SmartDialog.show(
        useAnimation: true,
        clickMaskDismiss: clickMaskDismiss,
        keepSingle: keepSingle,
        backDismiss: backDismiss,
        onDismiss: onDismiss,
        tag: tag,
        builder: (_) {
          return _buildConfirmDialogFresh(title, message, okText, cancelText,
              contentCenter, onOkPressed, onCancelPressed);
        });
  }

  static Container _buildConfirmDialog(
    String? title,
    String message,
    String? okText,
    String? cancelText,
    bool? contentCenter,
    VoidCallback? onOkPressed,
    VoidCallback? onCancelPressed,
  ) {
    return Container(
      width: _maxWidth,
      decoration: _initBoxDecoration(),
      padding: const EdgeInsetsDirectional.only(
          start: 10, end: 10, top: 15, bottom: 5),
      child: IntrinsicHeight(
        child: Column(
          children: [
            const SizedBox(height: 5),
            _initTitle(title),
            const SizedBox(height: 10),
            _initContent(message, contentCenter),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    width: _buttonWidth,
                    child: ElevatedButton(
                        onPressed: () {
                          if (null != onCancelPressed) {
                            Future.delayed(Duration.zero, () {
                              onCancelPressed.call();
                            });
                          } else {
                            dismissDialog();
                          }
                        },
                        child: CommonText(cancelText ?? _defaultCancel))),
                SizedBox(
                    width: _buttonWidth,
                    child: ElevatedButton(
                        onPressed: () {
                          if (null != onOkPressed) {
                            Future.delayed(Duration.zero, () {
                              onOkPressed.call();
                            });
                          } else {
                            dismissDialog();
                          }
                        },
                        child: CommonText(okText ?? _defaultOk))),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  static void showBottomDialog(
    List<BottomItem> itemList,
    ValueChanged<BottomItem> onItemPressed, {
    bool? clickMaskDismiss = true,
    bool? keepSingle = false,
    bool? backDismiss = true,
    String? tag,
    String? cancelText,
    VoidCallback? onCancelPressed,
    VoidCallback? onDismiss,
    String? title,
  }) {
    SmartDialog.show(
        alignment: Alignment.bottomCenter,
        useAnimation: true,
        clickMaskDismiss: clickMaskDismiss,
        keepSingle: keepSingle,
        backDismiss: backDismiss,
        onDismiss: onDismiss,
        tag: tag,
        builder: (_) {
          return _buildBottomDialog(
              itemList, title, cancelText, onItemPressed, onCancelPressed);
        });
  }

  static Container _buildBottomDialog(
    List<BottomItem> itemList,
    String? title,
    String? cancelText,
    ValueChanged<BottomItem> onItemPressed,
    VoidCallback? onCancelPressed,
  ) {
    double statusBarHeight = 0;
    if (null != Get.context) {
      statusBarHeight = MediaQuery.of(Get.context!).padding.top;
    }
    return Container(
      width: double.infinity,
      height: Get.size.height - statusBarHeight,
      decoration: initBottomBoxDecoration(),
      child: IntrinsicHeight(
        child: Column(
          children: [
            // DialogActionBar(
            //   title: title ?? "",
            //   onTap: () {
            //     if (null != onCancelPressed) {
            //       Future.delayed(Duration.zero, () {
            //         onCancelPressed.call();
            //       });
            //     } else {
            //       dismissDialog();
            //     }
            //   },
            // ),
            const SizedBox(height: 28),
            ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: _minHeight,
                maxHeight: _maxBottomHeight,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 16),
                  child: Column(
                    children: List.generate(
                      itemList.length,
                      (index) => InkWell(
                        onTap: () {
                          Future.delayed(Duration.zero, () {
                            onItemPressed(itemList[index]);
                          });
                          dismissDialog();
                        },
                        child: Container(
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 16),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: ThemeColors.grey200)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  itemList[index].value ?? "",
                                  style: AppTextTheme.defaultStyle(),
                                ),
                              ),
                              const SizedBox(width: 10),
                              buildCheckWidget(itemList[index].checked),
                              const SizedBox(width: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildCheckWidget(
    bool? checked,
  ) {
    if (checked == true) {
      return const Icon(Icons.check);
    } else {
      return const SizedBox(width: 16, height: 16);
    }
  }

  static Future<T?> showColumnButtonDialog<T>(
    String message, {
    required Map<String, VoidCallback> buttonEventMap,
    bool? clickMaskDismiss = true,
    bool? keepSingle = false,
    bool? backDismiss = true,
    bool? contentCenter = false,
    String? tag,
    String? title,
    VoidCallback? onDismiss,
  }) async {
    return SmartDialog.show(
        useAnimation: true,
        clickMaskDismiss: clickMaskDismiss,
        keepSingle: keepSingle,
        backDismiss: backDismiss,
        onDismiss: onDismiss,
        tag: tag,
        builder: (_) {
          return _buildColumnButtonDialog(
              title, message, contentCenter, buttonEventMap);
        });
  }

  static Container _buildColumnButtonDialog(
    String? title,
    String message,
    bool? contentCenter,
    Map<String, VoidCallback> buttonEventMap,
  ) {
    List<Widget> buttonList = [];
    for (MapEntry<String, VoidCallback> entry in buttonEventMap.entries) {
      buttonList.add(SizedBox(
          width: _columnButtonWidth,
          child: ElevatedButton(
              onPressed: () {
                entry.value.call();
                dismissDialog();
              },
              child: Text(entry.key))));
    }
    return Container(
      width: _maxWidth,
      decoration: _initBoxDecoration(),
      padding: const EdgeInsetsDirectional.only(
          start: 10, end: 10, top: 15, bottom: 5),
      child: IntrinsicHeight(
        child: Column(
          children: [
            const SizedBox(height: 5),
            _initTitle(title),
            const SizedBox(height: 10),
            _initContent(message, contentCenter),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buttonList,
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  static Widget _initTitle(String? title) {
    if (title?.isNotEmpty == true) {
      return Padding(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
        child: Center(
            child: Text(
          title ?? _default,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        )),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  static ConstrainedBox _initContent(String message, bool? contentCenter) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: _minHeight,
        maxHeight: _maxHeight,
      ),
      child: SingleChildScrollView(
        child: Text(
          message,
          textAlign: contentCenter == true ? TextAlign.center : TextAlign.start,
        ),
      ),
    );
  }

  static BoxDecoration _initBoxDecoration() {
    return const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      color: Colors.white,
    );
  }

  static BoxDecoration initBottomBoxDecoration() {
    return const BoxDecoration(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero),
      color: Colors.white,
    );
  }

  static Widget _buildMessageDialogFresh(String? title, String message,
      bool? contentCenter, String? okText, VoidCallback? onOkPressed) {
    String contentStr = message;
    List<String>? actionButtonText = [okText ?? _defaultOk];
    List<VoidCallback>? actionButtonOnPressed = [];
    if (null != onOkPressed) {
      actionButtonOnPressed.add(onOkPressed);
    } else {
      actionButtonOnPressed.add(emptyCallback);
    }

    return CupertinoAlertDialog(
      title: buildTitle(title),
      content: getContent(
        contentStr: contentStr,
        contentCenter: contentCenter,
      ),
      actions: getCupertinoDialogActions(
        name: actionButtonText,
        onPressed: actionButtonOnPressed,
      ),
    );
  }

  static Widget _buildConfirmDialogFresh(
    String? title,
    String message,
    String? okText,
    String? cancelText,
    bool? contentCenter,
    VoidCallback? onOkPressed,
    VoidCallback? onCancelPressed,
  ) {
    String contentStr = message;
    List<String>? actionButtonText = [
      okText ?? _defaultOk,
      cancelText ?? _defaultCancel
    ];
    List<VoidCallback>? actionButtonOnPressed = [];
    if (null != onOkPressed) {
      actionButtonOnPressed.add(onOkPressed);
    } else {
      actionButtonOnPressed.add(emptyCallback);
    }
    if (null != onCancelPressed) {
      actionButtonOnPressed.add(onCancelPressed);
    } else {
      actionButtonOnPressed.add(emptyCallback);
    }
    List<TextStyle>? actionButtonTextStyle;
    return CupertinoAlertDialog(
      title: buildTitle(title),
      content: getContent(
        contentStr: contentStr,
        contentCenter: contentCenter,
      ),
      actions: getCupertinoDialogActions(
        name: actionButtonText,
        onPressed: actionButtonOnPressed,
        style: actionButtonTextStyle,
      ),
    );
  }

  static List<Widget> getCupertinoDialogActions({
    required List<String> name,
    List<VoidCallback>? onPressed,
    List<TextStyle>? style,
  }) {
    List<Widget> actions = [];
    for (int i = 0; i < name.length; i++) {
      var event = onPressed?[i] ?? () {};
      actions.add(buildCupertinoDialogAction(
        name: name[i],
        onPressed: event,
        style: style?[i] ?? AppTextTheme.defaultStyle(),
      ));
    }
    return actions;
  }

  static Widget buildCupertinoDialogAction({
    required String name,
    required VoidCallback onPressed,
    TextStyle? style,
  }) {
    return CupertinoDialogAction(
      onPressed: () {
        onPressed();
      },
      isDefaultAction: false,
      isDestructiveAction: false,
      textStyle: style,
      child: Text(
        name,
        style: style,
      ),
    );
  }

  static Widget buildTitle(String? title) {
    if (title == null) {
      return const SizedBox(
        height: 0,
      );
    } else {
      return Text(
        title,
        style: AppTextTheme.defaultStyle(),
      );
    }
  }

  static Widget getContent({
    String? contentStr,
    Widget? widget,
    bool? contentCenter,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 5,
          ),
          buildContentStr(contentStr, contentCenter),
          buildContentWidget(widget),
          const SizedBox(
            height: 0,
          ),
        ],
      ),
    );
  }

  static Widget buildContentStr(
    String? content,
    bool? contentCenter,
  ) {
    if (content == null) {
      return const SizedBox(
        height: 0,
      );
    } else {
      return Text(
        content,
        textAlign: contentCenter == true ? TextAlign.center : TextAlign.start,
        style: AppTextTheme.defaultStyle(),
      );
    }
  }

  static Widget buildContentWidget(Widget? content) {
    if (content == null) {
      return const SizedBox(
        height: 0,
      );
    } else {
      return content;
    }
  }
}

class BottomItem {
  late final String? key;
  late final String? value;
  bool checked;

  BottomItem(this.key, this.value, {this.checked = false});

  BottomItem copy() {
    return BottomItem(key, value, checked: checked);
  }
}
