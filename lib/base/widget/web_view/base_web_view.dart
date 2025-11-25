import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// [author] yu
///
/// [describe] ベースウェブビュー
///
/// [date] 2024/05/17
abstract class BaseWebView extends StatefulWidget {
  const BaseWebView({
    super.key,
    required this.urlString,
    required this.webViewController,
    this.isNotCache = false,
    this.isAlertDialogToNative = false,
  });

  /// URL
  final String urlString;
  final WebViewController webViewController;
  final bool isNotCache;
  final bool isAlertDialogToNative;

  @override
  BaseWebViewState createState();
}

abstract class BaseWebViewState<T extends BaseWebView> extends State<T> {
  /// HTTP `User-Agent:`
  @protected
  String? userAgent() => null;

  /// リクエストのヘッダー
  @protected
  Map<String, String> headers() {
    Map<String, String> result = {};
    if (widget.isNotCache) {
      notSetCache().forEach((key, value) {
        result[key] = value;
      });
    }
    return result;
  }

  /// 背景色を設定します
  Color backgroundColor() => Colors.white;

  /// 画面上のズーム コントロールとズーム用のジェスチャ
  bool enableZoom() => false;

  @override
  void initState() {
    super.initState();
    _clearCache();
    _setWebViewController();
    addJavaScriptChannel();
  }

  @override
  Widget build(BuildContext context) {
    return buildWebViewWidget(context);
  }

  /// WebView作成
  ///
  Widget buildWebViewWidget(BuildContext context) {
    return WebViewWidget(
      controller: widget.webViewController,
      // 縦にスクロール追加
      gestureRecognizers: <Factory<VerticalDragGestureRecognizer>>{
        Factory<VerticalDragGestureRecognizer>(
          () => VerticalDragGestureRecognizer(),
        ),
      }.toSet(),
    );
  }

  /// WebViewController 初期化
  void _setWebViewController() {
    widget.webViewController
      ..enableZoom(enableZoom())
      ..setUserAgent(userAgent())
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(backgroundColor())
      ..loadRequest(Uri.parse(widget.urlString), headers: headers());
  }

  /// AlertダイアログがNative側で表示
  ///
  void addJavaScriptChannel() {}

  /// web page alert messageが nativeで表示
  ///
  void setAlertMessageScript() {}

  /// アプリロカールクリア
  ///
  void _clearCache() {
    if (widget.isNotCache) {
      widget.webViewController.clearLocalStorage();
    }
  }

  /// websitキャッシュ設定不要
  ///
  Map<String, String> notSetCache() {
    return {
      "Cache-Control": "no-cache, no-store, must-revalidate",
      "Pragma": "no-cache",
      "Expires": "0",
    };
  }
}
