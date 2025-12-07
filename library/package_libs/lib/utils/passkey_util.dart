import 'dart:async';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:package_libs/utils/passkey_chrome_safari_browser.dart';
import 'package:package_libs/utils/sp_util.dart';

enum WebAuthAction {
  auth,
  setting,
  register,
}

enum WebAuthResultType {
  success,
  cancel,
  error,
}

class WebAuthResult {
  WebAuthResultType type;
  String? result;
  String? action;
  String? message;
  String? loginId;

  WebAuthResult._(this.type);

  factory WebAuthResult.success() => WebAuthResult._(WebAuthResultType.success);

  factory WebAuthResult.cancel() => WebAuthResult._(WebAuthResultType.cancel);

  factory WebAuthResult.error(String message) => WebAuthResult._(WebAuthResultType.error)..message = message;
}

class PasskeyUtil {
  static final PasskeyUtil _instance = PasskeyUtil._private();

  PasskeyUtil._private();

  factory PasskeyUtil.instance() => _instance;

  Completer<void>? _authFuture;
  PasskeyChromeSafariBrowser? _browser;

  Future<WebAuthResult> startRegistration({required String loginId}) async {
    if (_checkPublicKeyExists(loginId: loginId) == false) {
      return WebAuthResult.cancel();
    }

    // show guide dialog
    // if ok
    WebAuthResult? result = await _registerAndCallback();

    return result ?? WebAuthResult.cancel();
  }

  Future<WebAuthResult?> _registerAndCallback() async {
    String url = _buildAuthUrl(WebAuthAction.register);
    String authCallback = await _openWebAuth(url: url);
    WebAuthResult? result = _parseAuthCallback(authCallback: authCallback);
    return result;
  }

  Future<WebAuthResult?> startAuth({String? loginId}) async {
    String? url = _buildAuthUrl(WebAuthAction.auth, loginId: loginId);
    String authCallback = await _openWebAuth(url: url ?? "");
    WebAuthResult? result = _parseAuthCallback(authCallback: authCallback);
    return result;
  }

  Future<String> _openWebAuth({required String url}) async {
    String? authCallback = "";
    if (url.isEmpty == true) {
      return Future.value(authCallback);
    }

    await forceStop();
    _authFuture?.complete();
    _authFuture = Completer();
    _browser = PasskeyChromeSafariBrowser();
    authCallback = await _browser?.openWithResult(uri: WebUri(url));
    Future.delayed(const Duration(microseconds: 500), () {
      _authFuture?.complete();
      _authFuture = null;
    });
    return Future.value(authCallback);
  }

  _buildAuthUrl(WebAuthAction action, {String? loginId}) {
    return "http://www.xxx.com?action=$action&loginId=$loginId";
  }

  WebAuthResult _parseAuthCallback({required String authCallback}) {
    if (authCallback.isEmpty == true) {
      return WebAuthResult.error("authCallback is null");
    }
    Uri uri = Uri.parse(authCallback);
    Map<String, String> params = Map.from(uri.queryParameters);
    return WebAuthResult.success()
      ..action = params["action"]
      ..result = params["result"]
      ..loginId = params["loginId"];
  }

  startAuthAndCacheLogin() {}

  FutureOr forceStop() async {
    await _browser?.close();
    _browser = null;
    if (isStatusDoing()) {
      await _authFuture?.future;
    }
  }

  bool isStatusDoing() => _authFuture != null && _authFuture?.isCompleted == false;

  FutureOr _checkPublicKeyExists({required String loginId}) async {
    // todo api
    bool isExists = true;
    if (isExists) {
      SpUtil.instance().set("lastLoginId", loginId);
    } else {
      await SpUtil.instance().remove("lastLoginId");
    }
  }

  Future<bool> canPasskeyUsing() async {
    String lastLoginId = await SpUtil.instance().getStringAsync("lastLoginId");
    return lastLoginId.isNotEmpty == true;
  }
}
