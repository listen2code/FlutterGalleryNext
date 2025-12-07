import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PasskeyChromeSafariBrowser with WidgetsBindingObserver {
  String callbackURLScheme = "fido2-callback";
  WebAuthenticationSession? _authenticationSession;
  StreamSubscription<Uri>? _streamSubscription;
  ChromeSafariBrowser? _chromeSafariBrowser;
  Completer<void>? _authResultFuture;
  String _authCallback = "";

  Future<String> openWithResult({required WebUri uri}) async {
    _completeFuture();
    _authResultFuture = Completer();
    try {
      if (Platform.isIOS) {
        await _authIOS(uri);
      } else if (Platform.isAndroid) {
        await _authAndroid(uri);
      } else {
        throw Exception("Unsupported platform");
      }
      WidgetsBinding.instance.addObserver(this);
      await _authResultFuture?.future;
    } catch (e) {
      debugPrint("PasskeyChromeSafariBrowser openWithResult error=$e");
    } finally {
      _completeFuture();
    }
    return Future.value(_authCallback);
  }

  Future<void> _authAndroid(WebUri uri) async {
    _streamSubscription = AppLinks().uriLinkStream.listen((Uri? uri) {
      if (uri?.scheme == callbackURLScheme) {
        _authCallback = uri.toString();
        _completeFuture();
      }
    }, onError: (error, stackTrace) {
      debugPrint("PasskeyChromeSafariBrowser openWithResult error=$error");
    });
    bool isChromeAvailable = true;
    _chromeSafariBrowser = ChromeSafariBrowser();
    await _chromeSafariBrowser?.open(
      url: uri,
      settings: ChromeSafariBrowserSettings(
        packageName: isChromeAvailable ? "com.android.chrome" : null,
        noHistory: true,
      ),
    );
  }

  Future<void> _authIOS(WebUri uri) async {
    _authenticationSession = await WebAuthenticationSession.create(
      url: uri,
      callbackURLScheme: callbackURLScheme,
      initialSettings: WebAuthenticationSessionSettings(prefersEphemeralWebBrowserSession: true),
      onComplete: (Uri? callbackUrl, WebAuthenticationSessionError? error) async {
        if (error != null) {
          debugPrint("PasskeyChromeSafariBrowser openWithResult error=$error");
          _completeFuture();
          return;
        }

        if (callbackUrl?.scheme == callbackURLScheme) {
          _authCallback = callbackUrl.toString();
        }
        _completeFuture();
      },
    );
    await _authenticationSession?.start();
  }

  Future<void> close() async {
    if (Platform.isIOS) {
      await _authenticationSession?.cancel();
    } else if (Platform.isAndroid) {
      await _chromeSafariBrowser?.close();
    }
    await _completeFuture();
  }

  Future<void> _completeFuture() async {
    _authResultFuture?.complete();
    _authResultFuture = null;
    if (Platform.isAndroid) {
      await _streamSubscription?.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.resumed:
        debugPrint("PasskeyChromeSafariBrowser didChangeAppLifecycleState resumed");
        Future.delayed(const Duration(microseconds: 200), () {
          // delay for authCallback to be set
          _completeFuture();
        });
        break;
      case AppLifecycleState.paused:
        debugPrint("PasskeyChromeSafariBrowser didChangeAppLifecycleState paused");
        break;
    }
  }
}
