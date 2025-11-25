import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

abstract class BaseWebView extends StatefulWidget {
  const BaseWebView({
    super.key,
    required this.urlString,
    required this.webViewController,
    this.isNotCache = false,
    this.isAlertDialogToNative = false,
  });

  final String urlString;
  final WebViewController webViewController;
  final bool isNotCache;
  final bool isAlertDialogToNative;

  @override
  BaseWebViewState createState();
}

abstract class BaseWebViewState<T extends BaseWebView> extends State<T> {
  @protected
  String? userAgent() => null;

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

  Color backgroundColor() => Colors.white;

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

  Widget buildWebViewWidget(BuildContext context) {
    return WebViewWidget(
      controller: widget.webViewController,
      gestureRecognizers: <Factory<VerticalDragGestureRecognizer>>{
        Factory<VerticalDragGestureRecognizer>(
          () => VerticalDragGestureRecognizer(),
        ),
      }.toSet(),
    );
  }

  void _setWebViewController() {
    widget.webViewController
      ..enableZoom(enableZoom())
      ..setUserAgent(userAgent())
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(backgroundColor())
      ..loadRequest(Uri.parse(widget.urlString), headers: headers());
  }

  void addJavaScriptChannel() {}

  void setAlertMessageScript() {}

  void _clearCache() {
    if (widget.isNotCache) {
      widget.webViewController.clearLocalStorage();
    }
  }

  Map<String, String> notSetCache() {
    return {
      "Cache-Control": "no-cache, no-store, must-revalidate",
      "Pragma": "no-cache",
      "Expires": "0",
    };
  }
}
