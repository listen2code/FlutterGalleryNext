import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/widget/web_view/inner_web_view.dart';
import 'package:get/get.dart';

import 'base_web_view.dart';

class DialogWebView extends InnerWebView {
  const DialogWebView({
    super.key,
    required super.urlString,
    required super.webViewController,
    super.height = 0,
    super.backgroundColor,
    super.enableZoom = false,
    super.onNavigationRequest,
    super.onCustomPageStarted,
    super.onCustomPageFinished,
    super.onCustomProgress,
    super.onCustomWebResourceError,
    super.onCustomUrlChange,
    super.onCustomHttpAuthRequest,
    super.onCustomHttpError,
    super.isNeedHeartbeat = false,
    super.isNotCache,
  });

  @override
  BaseWebViewState<BaseWebView> createState() => DialogWebViewState();
}

class DialogWebViewState extends InnerWebViewState {
  double _height = 0.1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: super.build(context),
    );
  }

  @override
  void onDefaultPageFinished(String url) {
    super.onDefaultPageFinished(url);
    updateHeight();
  }

  void updateHeight() async {
    var calcHeight = await getPageHeight();
    debugPrint("dialog page height:$calcHeight");
    double setHeight = widget.height;
    if (calcHeight != null) {
      setHeight = calcHeight;
    }
    setState(() {
      _height = setHeight;
    });
  }

  Future<double?> getPageHeight() async {
    String jsScript = "document.documentElement.scrollHeight;";
    var height =
        await widget.webViewController.runJavaScriptReturningResult(jsScript);
    if (height.toString().isNum) {
      return double.parse(height.toString());
    }
    return null;
  }

  @override
  bool isPageError(String url) {
    return false;
  }
}
