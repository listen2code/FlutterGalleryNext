import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/color/theme_colors.dart';
import 'package:flutter_gallery_next/base/widget/dialog/common_dialog.dart';
import 'package:flutter_gallery_next/base/widget/web_view/base_web_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InnerWebView extends BaseWebView {
  const InnerWebView({
    super.key,
    required super.urlString,
    required super.webViewController,
    this.height = 0,
    this.backgroundColor,
    this.enableZoom = false,
    this.isNeedHeartbeat = false,
    this.isRemoveSpace = false,
    this.onNavigationRequest,
    this.onPageFinishedBefore,
    this.onCustomPageStarted,
    this.onCustomPageFinished,
    this.onCustomProgress,
    this.onCustomWebResourceError,
    this.onCustomUrlChange,
    this.onCustomHttpAuthRequest,
    this.onCustomHttpError,
    super.isNotCache,
    super.isAlertDialogToNative,
    this.showLoading = false,
    this.showError = true,
    this.setFinishWhenError = true,
  });

  final double height;
  final Color? backgroundColor;
  final bool enableZoom;
  final bool isNeedHeartbeat;
  final bool isRemoveSpace;
  final bool setFinishWhenError;
  final FutureOr<NavigationDecision> Function(NavigationRequest)?
      onNavigationRequest;
  final FutureOr<NavigationDecision> Function(NavigationRequest)?
      onPageFinishedBefore;
  final void Function(String url)? onCustomPageStarted;
  final void Function(String url)? onCustomPageFinished;
  final void Function(int progress)? onCustomProgress;
  final void Function(WebResourceError error)? onCustomWebResourceError;
  final void Function(UrlChange change)? onCustomUrlChange;
  final void Function(HttpAuthRequest request)? onCustomHttpAuthRequest;
  final void Function(HttpResponseError error)? onCustomHttpError;
  final bool showLoading;
  final bool showError;

  @override
  BaseWebViewState<BaseWebView> createState() => InnerWebViewState();
}

class InnerWebViewState<T extends InnerWebView> extends BaseWebViewState<T> {
  bool isError = false;
  bool isPageFinished = false;
  bool isReady = true;

  @override
  void initState() {
    super.initState();
    _initDelegate();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "InnerWebView build ---------> isError:$isError, isReady:$isReady");
    if (widget.isRemoveSpace && (isReady || isError)) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: widget.height == 0 ? _screenHeight(context) : widget.height,
      child: isError ? _errorView() : super.build(context),
    );
  }

  @override
  Color backgroundColor() {
    return widget.backgroundColor ?? ThemeColors.white;
  }

  @override
  bool enableZoom() {
    return widget.enableZoom;
  }

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

  Widget _errorView() {
    if (widget.showError) {
      return buildErrorView();
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildErrorView() {
    return Center(
      child: Container(
        margin: const EdgeInsets.fromLTRB(45, 0, 45, 0),
        child: const Text(
          "webViewErrorMessage",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  double _screenHeight(context) {
    double height = MediaQuery.of(context).size.height;
    return height - 80;
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
    if (widget.showLoading) {
      GlobalDialog.showLoading();
    }
    isPageFinished = false;
    isReady = false;
    debugPrint("onPageStarted ---------> $url");
    var onPageStarted = widget.onCustomPageStarted;
    if (onPageStarted != null) {
      onPageStarted(url);
    }
  }

  void onDefaultPageFinished(String url) {
    isPageFinished = true;
    debugPrint("onPageFinished ---------> $url");
    var onPageFinished = widget.onCustomPageFinished;
    if (onPageFinished != null) {
      onPageFinished(url);
    }
    setAlertMessageScript();
    if (widget.showLoading) {
      GlobalDialog.dismissLoading();
    }
  }

  void onDefaultProgress(int progress) {
    debugPrint("onProgress ---------> $progress");
    var onPageProgress = widget.onCustomProgress;
    if (onPageProgress != null) {
      onPageProgress(progress);
    }
  }

  void onDefaultWebResourceError(WebResourceError error) {
    if (widget.setFinishWhenError == true) {
      isPageFinished = true;
    }
    isReady = false;
    isError = true;
    debugPrint(
        "onWebResourceError  ---------> ${error.description}  ${error.errorCode}");
    debugPrint(
        "onWebResourceError  ---------> ${error.errorType}  ${error.url}");
    var onWebResourceError = widget.onCustomWebResourceError;
    if (onWebResourceError != null) {
      onWebResourceError(error);
    }
    if (widget.showLoading) {
      GlobalDialog.dismissLoading();
    }
  }

  void onDefaultUrlChange(UrlChange change) {
    debugPrint("onUrlChange ---------> ${change.url}");
    if (isPageError(change.url ?? "")) {
      setState(() {
        isError = true;
      });
    }
    var onUrlChange = widget.onCustomUrlChange;
    if (onUrlChange != null) {
      onUrlChange(change);
    }
  }

  void onDefaultHttpAuthRequest(HttpAuthRequest request) {
    debugPrint("onHttpAuthRequest ---------> $request");
    var onHttpAuthRequest = widget.onCustomHttpAuthRequest;
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
    var onHttpError = widget.onCustomHttpError;
    if (onHttpError != null) {
      onHttpError(error);
    }
    if (widget.showLoading) {
      GlobalDialog.dismissLoading();
    }
  }

  bool isPageError(String url) {
    if (url.contains("session_error.html")) {
      debugPrint("isSessionTimeout ---------> url:$url");
      return true;
    } else if (url.contains("login_error.html")) {
      debugPrint("isLoginError ---------> url:$url");
      return true;
    } else {
      debugPrint("notPageError ---------> url:$url");
      return false;
    }
  }
}
