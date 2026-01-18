import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:package_libs/utils/logger_util.dart';
import 'package:package_libs/utils/sp_util.dart';

enum AuthStatus {
  init, // 初期化
  todo, // 認証 検査必要
  doing, // 認証 検査中
  done, // 認証 完了
  skip, // スキップ
}

enum AuthResult {
  success,
  error,
  fail,
}

// todo update
class AuthUtil {
  static const String tag = "AuthUtil";

  // --- SP Keys ---
  static const String keyAuthEnable = "keyAuthEnable";
  static const String keyAuthTimeout = "keyAuthTimeout";

  static final AuthUtil _instance = AuthUtil._private();
  static final LocalAuthentication _auth = LocalAuthentication();

  DateTime? _pausedDate;
  AuthStatus _status = AuthStatus.init;

  VoidCallback? _onShowAuth;
  VoidCallback? _onDismissAuth;

  AuthUtil._private();

  factory AuthUtil.instance() => _instance;

  void init({required VoidCallback onShow, required VoidCallback onDismiss}) {
    _onShowAuth = onShow;
    _onDismissAuth = onDismiss;
  }

  Future<AuthResult> authenticate() async {
    LoggerUtil.log("$tag: authenticate start", type: LoggerType.easy);

    if (_status == AuthStatus.doing) return AuthResult.fail;
    setStatus(AuthStatus.doing);

    AuthResult authResult = AuthResult.fail;
    try {
      final bool result = await _auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: "Security Check",
            cancelButton: "Cancel",
            biometricHint: 'Verify your identity',
          ),
          IOSAuthMessages(cancelButton: "Cancel"),
        ],
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      authResult = result ? AuthResult.success : AuthResult.fail;
    } on PlatformException catch (e) {
      authResult = AuthResult.error;
      LoggerUtil.error("$tag: Authentication error", error: e);
    }

    if (authResult == AuthResult.success) {
      setStatus(AuthStatus.done);
      _onDismissAuth?.call();
    } else {
      setStatus(AuthStatus.todo);
    }

    return authResult;
  }

  Future<bool> checkAuthority() async {
    if (isStatusSkip()) return false;

    if (!await isAvailable()) {
      LoggerUtil.log("$tag: Biometrics not available, cleanup settings", type: LoggerType.easy);
      clearWhenForgetPassword();
      await stopAuthentication();
      _onDismissAuth?.call();
      return false;
    }

    if (await shouldAuth()) {
      if (!isStatusDoing()) {
        LoggerUtil.log("$tag: Triggering Auth UI", type: LoggerType.easy);
        _onShowAuth?.call();
      }
      return true;
    }

    clearPauseDate();
    return false;
  }

  Future<bool> shouldAuth() async {
    if (isStatusDone()) return false;

    if (await isAuthEnabled()) {
      if (isStatusInit()) return true;

      final String timeoutStr = SpUtil.instance.getString(keyAuthTimeout);
      final int timeout = int.tryParse(timeoutStr) ?? -1;

      return await isRequiredIfEnabled(getPausedDate(), timeout);
    }
    return false;
  }

  Future<bool> isAuthEnabled() async {
    final String timeout = SpUtil.instance.getString(keyAuthTimeout);
    final bool enabled = SpUtil.instance.getBool(keyAuthEnable, defaultValue: false);
    return enabled && timeout.isNotEmpty && num.tryParse(timeout) != null;
  }

  Future<bool> isRequiredIfEnabled(DateTime? startTime, int timeoutMinutes) async {
    if (timeoutMinutes < 0 || startTime == null) return false;
    if (timeoutMinutes == 0) return true;

    final Duration difference = DateTime.now().difference(startTime);
    return difference.inMinutes >= timeoutMinutes;
  }

  Future<bool> isAvailable() async {
    try {
      final bool isSupported = await _auth.isDeviceSupported();
      final bool canCheck = await _auth.canCheckBiometrics;
      final List<BiometricType> available = await _auth.getAvailableBiometrics();
      return isSupported && canCheck && available.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<String> getAuthTypeName() async {
    final List<BiometricType> available = await _auth.getAvailableBiometrics();
    if (available.contains(BiometricType.fingerprint) && available.contains(BiometricType.face)) {
      return "Fingerprint & Face";
    } else if (available.contains(BiometricType.fingerprint)) {
      return "Fingerprint";
    } else if (available.contains(BiometricType.face)) {
      return "Face ID";
    }
    return "Biometric";
  }

  Future<bool> isFaceAvailable() async {
    final list = await _auth.getAvailableBiometrics();
    return list.contains(BiometricType.face);
  }

  Future<bool> isFingerprintAvailable() async {
    final list = await _auth.getAvailableBiometrics();
    return list.contains(BiometricType.fingerprint);
  }

  Future<void> stopAuthentication() async {
    try {
      await _auth.stopAuthentication();
    } catch (_) {}
  }

  DateTime? getPausedDate() => _pausedDate;

  void clearPauseDate() {
    _pausedDate = null;
  }

  void setPausedDate() {
    _pausedDate = DateTime.now();
    setStatusTodo();
  }

  bool isStatusDoing() => _status == AuthStatus.doing;

  bool isStatusSkip() => _status == AuthStatus.skip;

  bool isStatusInit() => _status == AuthStatus.init;

  bool isStatusDone() => _status == AuthStatus.done;

  void setStatus(AuthStatus status) {
    LoggerUtil.log("$tag: Status -> $status", type: LoggerType.easy);
    _status = status;
  }

  void setStatusTodo() {
    if (_status != AuthStatus.doing) setStatus(AuthStatus.todo);
  }

  void clearWhenForgetPassword() {
    setStatus(AuthStatus.done);
    clearPauseDate();
    SpUtil.instance.set(keyAuthEnable, false);
    SpUtil.instance.set(keyAuthTimeout, "");
  }
}

class AppLifecycleWatcher extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      AuthUtil.instance().checkAuthority();
    } else if (state == AppLifecycleState.paused) {
      AuthUtil.instance().setPausedDate();
    }
  }
}

final AppLifecycleWatcher appLifecycleWatcher = AppLifecycleWatcher();
