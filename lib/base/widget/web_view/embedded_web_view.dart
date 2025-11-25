import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/widget/web_view/inner_web_view.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'base_web_view.dart';

/// [author] g.zhang0
///
/// [describe] 埋め込み用ウエブビュー
///
/// [date] 2024/09/09
class EmbeddedWebView extends InnerWebView {
  const EmbeddedWebView({
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
    this.enableScrolling = true,
    super.showError = true,
    this.onEmbeddedPageFinished,
    this.updateHeightError,
  });

  /// スクロールできるか
  final bool enableScrolling;

  /// WebView表示した後事件
  final void Function(String url)? onEmbeddedPageFinished;

  /// [緊急時お知らせ] WebView高さ更新
  final void Function()? updateHeightError;

  @override
  BaseWebViewState<BaseWebView> createState() => EmbeddedWebViewState();
}

class EmbeddedWebViewState extends InnerWebViewState<EmbeddedWebView> {
  /// WebView高さ
  double embeddedHeight = 385;

  @override
  void initState() {
    if (widget.height > 0) {
      embeddedHeight = widget.height;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: embeddedHeight,
      child: super.build(context),
    );
  }

  @override
  void onDefaultPageFinished(String url) {
    super.onDefaultPageFinished(url);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && !isError) {
        updateHeight();
      }
    });

    // onEmbeddedPageFinishedが存在する場合
    var onPageFinished = widget.onEmbeddedPageFinished;
    if (onPageFinished != null) {
      onPageFinished(url);
    }
  }

  @override
  Widget buildWebViewWidget(BuildContext context) {
    if (widget.enableScrolling) {
      return super.buildWebViewWidget(context);
    } else {
      return WebViewWidget(
        controller: widget.webViewController,
      );
    }
  }

  @override
  void onDefaultHttpError(HttpResponseError error) {
    super.onDefaultHttpError(error);
    setDefaultHttpError(error);
  }

  @override
  void onDefaultWebResourceError(WebResourceError error) {
    super.onDefaultWebResourceError(error);
    setWebResourceError(error);
  }

  void setDefaultHttpError(HttpResponseError error) {
    if (error.response?.statusCode != 200 &&
        error.request?.uri.toString() == widget.urlString) {
      isPageFinished = false;
      isReady = false;
      isError = true;
      debugPrint(
          "EmbeddedWebView onHttpError ---------> ${error.response?.statusCode}");
      debugPrint(
          "EmbeddedWebView onHttpError ---------> ${error.response?.uri}");

      if (mounted) {
        setState(() {
          embeddedHeight = 1;
        });
      }
    }
  }

  void setWebResourceError(WebResourceError error) {
    debugPrint(
        "EmbeddedWebView onDefaultWebResourceError ---------> ${error.description}");
    if (mounted) {
      setState(() {
        embeddedHeight = 1;
      });
    }
  }

  /// WebView高さ更新
  ///
  void updateHeight() async {
    var calcHeight = await getPageHeight();
    debugPrint("embedded height:$calcHeight");
    double setHeight = widget.height;
    if (calcHeight != null) {
      setHeight = calcHeight;
    }
    await setScrolling();
    setState(() {
      embeddedHeight = setHeight;
    });
  }

  /// JavascriptによりWebView高さを取得
  ///
  Future<double?> getPageHeight() async {
    String jsScript = "document.documentElement.scrollHeight;";
    var height =
        await widget.webViewController.runJavaScriptReturningResult(jsScript);
    if (height.toString().isNum) {
      return double.parse(height.toString()) + 10;
    }
    return null;
  }

  /// web view スクロールを無効にする
  ///
  Future<void> setScrolling() async {
    if (widget.enableScrolling == false) {
      String bodyScript = "document.body.style.overflow = 'hidden';";
      await widget.webViewController.runJavaScriptReturningResult(bodyScript);
      String elementScript =
          "document.documentElement.style.overflow = 'hidden';";
      await widget.webViewController
          .runJavaScriptReturningResult(elementScript);
    }
  }
}
