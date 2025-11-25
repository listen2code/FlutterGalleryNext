import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/color/theme_colors.dart';
import 'package:flutter_gallery_next/base/widget/dialog/common_dialog.dart';
import 'package:flutter_gallery_next/base/widget/web_view/base_web_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShrinkWebView extends BaseWebView {
  final Color? backgroundColor;
  final bool isShowLoading;
  final bool isNeedHeartbeat;
  final bool isRemoveSpace;
  final FutureOr<NavigationDecision> Function(NavigationRequest)?
      onNavigationRequest;
  final FutureOr<NavigationDecision> Function(NavigationRequest)?
      onPageFinishedBefore;
  final void Function(String url)? onPageStarted;
  final void Function(String url)? onPageFinished;
  final void Function(int progress)? onProgress;
  final void Function(WebResourceError error)? onWebResourceError;
  final void Function(UrlChange change)? onUrlChange;
  final void Function(HttpAuthRequest request)? onHttpAuthRequest;
  final void Function(HttpResponseError error)? onHttpError;
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  const ShrinkWebView({
    super.key,
    required super.urlString,
    required super.webViewController,
    super.isNotCache = false,
    super.isAlertDialogToNative = false,
    this.backgroundColor,
    this.isShowLoading = false,
    this.isNeedHeartbeat = false,
    this.isRemoveSpace = false,
    this.onNavigationRequest,
    this.onPageFinishedBefore,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.onWebResourceError,
    this.onUrlChange,
    this.onHttpAuthRequest,
    this.onHttpError,
    this.gestureRecognizers,
  });

  factory ShrinkWebView.build({
    required String urlString,
    GlobalKey<ShrinkWebViewState>? key,
    WebViewController? webViewController,
    bool isNotCache = false,
    bool isAlertDialogToNative = false,
    Color? backgroundColor,
    bool isShowLoading = false,
    bool isNeedHeartbeat = false,
    bool isRemoveSpace = false,
    FutureOr<NavigationDecision> Function(NavigationRequest request)?
        onNavigationRequest,
    FutureOr<NavigationDecision> Function(NavigationRequest request)?
        onPageFinishedBefore,
    void Function(String url)? onPageStarted,
    void Function(String url)? onPageFinished,
    void Function(int progress)? onProgress,
    void Function(WebResourceError error)? onWebResourceError,
    void Function(UrlChange change)? onUrlChange,
    void Function(HttpAuthRequest request)? onHttpAuthRequest,
    void Function(HttpResponseError error)? onHttpError,
    Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers,
  }) =>
      ShrinkWebView(
        urlString: urlString,
        key: key ?? GlobalKey<ShrinkWebViewState>(),
        webViewController: webViewController ?? WebViewController(),
        isNotCache: isNotCache,
        isAlertDialogToNative: isAlertDialogToNative,
        backgroundColor: backgroundColor,
        isShowLoading: isShowLoading,
        isNeedHeartbeat: isNeedHeartbeat,
        isRemoveSpace: isRemoveSpace,
        onNavigationRequest: onNavigationRequest,
        onPageFinishedBefore: onPageFinishedBefore,
        onPageStarted: onPageStarted,
        onPageFinished: onPageFinished,
        onProgress: onProgress,
        onWebResourceError: onWebResourceError,
        onUrlChange: onUrlChange,
        onHttpAuthRequest: onHttpAuthRequest,
        onHttpError: onHttpError,
        gestureRecognizers: gestureRecognizers,
      );

  @override
  BaseWebViewState<BaseWebView> createState() => ShrinkWebViewState();
}

class ShrinkWebViewState extends BaseWebViewState<ShrinkWebView> {
  bool isError = false;
  bool isReady = true;
  bool isPageFinished = false;
  double webViewHeight = defaultWebViewHeight;
  static const double defaultWebViewHeight = 1;

  @override
  void initState() {
    debugPrint("ShrinkWebViewState initState");
    super.initState();

    _init();
    _initDelegate();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "ShrinkWebView build ---------> isError:$isError, isReady:$isReady, webViewHeight:$webViewHeight");
    if (widget.isRemoveSpace && (isReady || isError)) {
      return const SizedBox(height: defaultWebViewHeight);
    }

    return ScrollConfiguration(
      behavior: _NonScrollBehavior(),
      child: SizedBox(
        height: webViewHeight,
        child: WebViewWidget(
          controller: widget.webViewController,
          gestureRecognizers: widget.gestureRecognizers ?? {},
        ),
      ),
    );
  }

  @override
  Color backgroundColor() => widget.backgroundColor ?? ThemeColors.white;

  @override
  bool enableZoom() => false;

  @override
  void addJavaScriptChannel() {
    if (widget.isAlertDialogToNative) {
      debugPrint("addJavaScriptChannel ........>");
      widget.webViewController.addJavaScriptChannel("Alert",
          onMessageReceived: (javaScriptMsg) {
        if (isPageFinished) {
          debugPrint("Alert message ........>${javaScriptMsg.message}");
          GlobalDialog.showMessageDialog(
            javaScriptMsg.message,
            okText: "OK",
          );
        } else {
          debugPrint("Page loading .........>");
        }
      });
    }
  }

  @override
  void setAlertMessageScript() {
    if (widget.isAlertDialogToNative) {
      debugPrint("setAlertMessageScript ........>");
      String script = '''
        window.alert = function(message) {
          Alert.postMessage(message);
        }
      ''';
      widget.webViewController.runJavaScript(script);
    }
  }

  void _initDelegate() {
    widget.webViewController.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: onDefaultPageStarted,
        onPageFinished: onDefaultPageFinished,
        onProgress: onDefaultProgress,
        onWebResourceError: onDefaultWebResourceError,
        onUrlChange: onDefaultUrlChange,
        onHttpAuthRequest: onDefaultHttpAuthRequest,
        onHttpError: onDefaultHttpError,
        onNavigationRequest: onDefaultNavigationRequest,
      ),
    );
  }

  FutureOr<NavigationDecision> onDefaultNavigationRequest(
      NavigationRequest request) {
    var navigationRequest = widget.onNavigationRequest;
    if (isPageFinished) {
      if (navigationRequest != null) {
        return navigationRequest(request);
      }
    } else {
      var pageFinishedBefore = widget.onPageFinishedBefore;
      if (pageFinishedBefore != null) {
        return pageFinishedBefore(request);
      }
    }
    return NavigationDecision.navigate;
  }

  void onDefaultPageStarted(String url) {
    if (widget.isShowLoading) {
      GlobalDialog.showLoading();
    }
    isPageFinished = false;
    isReady = false;
    debugPrint("onPageStarted ---------> $url");
    var onPageStarted = widget.onPageStarted;
    if (onPageStarted != null) {
      onPageStarted(url);
    }
  }

  void onDefaultPageFinished(String url) async {
    isPageFinished = true;
    debugPrint("onPageFinished ---------> $url");
    var onPageFinished = widget.onPageFinished;
    if (onPageFinished != null) {
      onPageFinished(url);
    }
    setAlertMessageScript();
    if (widget.isShowLoading) {
      GlobalDialog.dismissLoading();
    }

    await hideScrollBar();
    await calcWebViewHeight();
    setState(() {});
  }

  void onDefaultProgress(int progress) {
    debugPrint("onProgress ---------> $progress");
    var onPageProgress = widget.onProgress;
    if (onPageProgress != null) {
      onPageProgress(progress);
    }
  }

  void onDefaultWebResourceError(WebResourceError error) {
    isPageFinished = true;
    isReady = false;
    isError = true;
    debugPrint(
        "onWebResourceError  ---------> ${error.description}  ${error.errorCode}");
    debugPrint(
        "onWebResourceError  ---------> ${error.errorType}  ${error.url}");
    var onWebResourceError = widget.onWebResourceError;
    if (onWebResourceError != null) {
      onWebResourceError(error);
    }
    if (widget.isShowLoading) {
      GlobalDialog.dismissLoading();
    }
  }

  void onDefaultUrlChange(UrlChange change) {
    debugPrint("onUrlChange ---------> ${change.url}");
    if (isSessionTimeout(change.url ?? "")) {
      setState(() {
        isError = true;
      });
    }
    var onUrlChange = widget.onUrlChange;
    if (onUrlChange != null) {
      onUrlChange(change);
    }
  }

  void onDefaultHttpAuthRequest(HttpAuthRequest request) {
    debugPrint("onHttpAuthRequest ---------> $request");
    var onHttpAuthRequest = widget.onHttpAuthRequest;
    if (onHttpAuthRequest != null) {
      onHttpAuthRequest(request);
    }
  }

  void onDefaultHttpError(HttpResponseError error) {
    if (error.response?.uri == null) {
      return;
    }

    isPageFinished = true;
    isReady = false;
    isError = true;
    debugPrint("onHttpError ---------> ${error.response?.statusCode}");
    debugPrint("onHttpError ---------> ${error.response?.uri}");
    var onHttpError = widget.onHttpError;
    if (onHttpError != null) {
      onHttpError(error);
    }
    if (widget.isShowLoading) {
      GlobalDialog.dismissLoading();
    }
  }

  bool isSessionTimeout(String url) {
    if (url.contains("session_error.html")) {
      debugPrint("isSessionTimeout ---------> url:$url");
      return true;
    } else {
      debugPrint("notSessionTimeout ---------> url:$url");
      return false;
    }
  }

  Future<void> hideScrollBar() async {
    await widget.webViewController.runJavaScript(
      'document.body.style.overflow = "hidden";',
    );
  }

  Future<void> calcWebViewHeight() async {
    await Future<void>.delayed(const Duration(seconds: 1));

    double heightRatio = 1.5;

    String targetElement = "document.body";

    Object scrollWidth =
        await widget.webViewController.runJavaScriptReturningResult(
      '$targetElement.scrollWidth;',
    );
    debugPrint("calcWebViewHeight ----scrollWidth-----> $scrollWidth");

    Object scrollHeight =
        await widget.webViewController.runJavaScriptReturningResult(
      '$targetElement.scrollHeight;',
    );
    debugPrint("calcWebViewHeight ----scrollHeight-----> $scrollHeight");

    double jsHeight = min(double.parse(scrollWidth.toString()),
        double.parse(scrollHeight.toString()));

    double devicePixelRatio;
    if (mounted) {
      devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
      debugPrint(
          "calcWebViewHeight ----devicePixelRatio-----> $devicePixelRatio");
    } else {
      devicePixelRatio = 1;
    }

    double contentHeight = jsHeight == 0
        ? defaultWebViewHeight
        : jsHeight * devicePixelRatio * heightRatio;
    debugPrint("calcWebViewHeight ----contentHeight-----> $contentHeight");

    setState(() {
      webViewHeight = contentHeight;
    });
  }

  void _init() {
    isError = false;
    isPageFinished = false;
    isReady = false;

    setState(() {
      webViewHeight = defaultWebViewHeight;
    });
  }
}

class _NonScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  Widget buildOverscrollIndicator(
          BuildContext context, Widget child, ScrollableDetails details) =>
      child;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const NeverScrollableScrollPhysics();
}
