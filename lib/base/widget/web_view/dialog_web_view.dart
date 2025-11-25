import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/widget/web_view/inner_web_view.dart';
import 'package:get/get.dart';

import 'base_web_view.dart';

/// [author] g.zhang0
///
/// [describe] ダイアログ用ウエブビュー
///
/// [date] 2024/07/18
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
  /// WebView高さ
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

  /// WebView高さ更新
  ///
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

  /// JavascriptによりWebView高さを取得
  ///
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
    // ダイアログなので、エラーがチェック不要
    return false;
  }
}
