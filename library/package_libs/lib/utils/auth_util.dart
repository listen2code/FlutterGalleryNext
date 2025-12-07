import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:package_libs/utils/logger_util.dart';
import 'package:package_libs/utils/sp_util.dart';

enum AuthStatus {
  // 初期化
  init,
  // 認証 検査必要
  todo,
  // 認証 検査中
  doing,
  // 認証 完了
  done,
  // スキップ
  skip,
}

enum AuthResult {
  // 成功
  success,
  // エラー
  error,
  // 失敗
  fail,
}

AppLifecycleWatcher appLifecycleWatcher = AppLifecycleWatcher();

class AuthUtil {
  static final AuthUtil _instance = AuthUtil._private();
  static final LocalAuthentication _auth = LocalAuthentication();

  /// 背景に戻る時間
  DateTime? _pausedDate;

  /// 認証ステータス
  AuthStatus _status = AuthStatus.init;

  AuthUtil._private();

  factory AuthUtil.instance() => _instance;

  Future<AuthResult> authenticate() async {
    LoggerUtil.log("AuthUtil authenticate start", type: LoggerType.easy);
    AuthResult authResult = AuthResult.fail;
    try {
      bool result = await _auth.authenticate(
        localizedReason: ' ',
        authMessages: <AuthMessages>[
          const AndroidAuthMessages(
            signInTitle: "user auth",
            cancelButton: "cancel",
            biometricHint: ' ',
          ),
          const IOSAuthMessages(
            cancelButton: "cancel",
          ),
        ],
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (result) {
        authResult = AuthResult.success;
      }
    } on PlatformException catch (e) {
      authResult = AuthResult.error;
      LoggerUtil.log("AuthUtil authenticate error=$e", type: LoggerType.error);
    }
    LoggerUtil.log("AuthUtil authenticate authResult=$authResult", type: LoggerType.easy);
    if (authResult == AuthResult.success) {
      setStatus(AuthStatus.done);
    }
    return authResult;
  }

  Future<bool> checkAuthority() async {
    if (isStatusSkip()) {
      LoggerUtil.log("AuthUtil checkAuthority skip=true", type: LoggerType.easy);
      return false;
    }
    bool isAvailableBool = await isAvailable();
    if (isAvailableBool == false) {
      LoggerUtil.log("AuthUtil checkAuthority isAvailableBool=false", type: LoggerType.easy);
      setStatus(AuthStatus.done);
      await SpUtil.instance().set("lockPassWordId", "");
      await SpUtil.instance().set("authenticationTime", "");
      await stopAuthentication();
      // GlobalDialog.dismissDialog(tag: BiometricAuthLockDialog.tag);
      return false;
    }
    bool isFaceAvailableBool = await isFaceAvailable();
    bool isFingerprintAvailableBool = await isFingerprintAvailable();
    LoggerUtil.log(
        "AuthUtil checkAuthority status=$_status "
        "isAvailable=$isAvailableBool isFace=$isFaceAvailableBool isFingerprint=$isFingerprintAvailableBool",
        type: LoggerType.easy);

    bool shouldAuthBool = await shouldAuth();
    if (shouldAuthBool) {
      if (isStatusDoing()) {
        LoggerUtil.log("AuthUtil checkAuthority isStatusDoing", type: LoggerType.easy);
      } else {
        LoggerUtil.log("AuthUtil checkAuthority 生体認証画面へ", type: LoggerType.easy);
        // BiometricAuthLockDialog.show();
      }
      // 生体認証を行う場合にのみtrueが返る
      return true;
    }
    clearPauseDate();
    LoggerUtil.log("AuthUtil checkAuthority end", type: LoggerType.easy);

    return false;
  }

  Future<bool> shouldAuth() async {
    if (isStatusDone()) {
      LoggerUtil.log("AuthUtil shouldAuth=false isStatusDone", type: LoggerType.easy);
      return false;
    }

    bool isAuthTimeEnabledBool = await isAuthEnabled();
    LoggerUtil.log("AuthUtil shouldAuth isAuthTimeEnabled=$isAuthTimeEnabledBool", type: LoggerType.easy);
    if (isAuthTimeEnabledBool) {
      if (isStatusInit()) {
        // アプリ起動 -> 生体認証へ
        LoggerUtil.log("AuthUtil shouldAuth=true isStatusInit", type: LoggerType.easy);
        return true;
      }

      String authenticationTime = await SpUtil.instance().getStringAsync("authenticationTime", defaultValue: "");
      bool isRequiredIfEnabledBool = await isRequiredIfEnabled(getPausedDate(), int.tryParse(authenticationTime) ?? -1);
      LoggerUtil.log(
          "AuthUtil shouldAuth "
          "authenticationTime=$authenticationTime "
          "isRequiredIfEnabledBool=$isRequiredIfEnabledBool ",
          type: LoggerType.easy);
      if (isRequiredIfEnabledBool == true) {
        LoggerUtil.log("AuthUtil shouldAuth=true isRequiredIfEnabledBool=true", type: LoggerType.easy);
        return true;
      }
    }

    LoggerUtil.log("AuthUtil shouldAuth=false", type: LoggerType.easy);
    return false;
  }

  Future<bool> isAuthEnabled() async {
    String authenticationTime = await SpUtil.instance().getStringAsync("authenticationTime", defaultValue: "");
    String lockPassword = await SpUtil.instance().getStringAsync("lockPassWordId", defaultValue: "");

    if (lockPassword.isEmpty == true) {
      // lockPasswordが設定されていない
      LoggerUtil.log("AuthUtil isAuthTimeEnabled lockPasswordが設定されていない", type: LoggerType.easy);
      return false;
    }

    if (authenticationTime.isEmpty == true) {
      // timeoutが設定されていない
      LoggerUtil.log("AuthUtil isAuthTimeEnabled timeoutが設定されていない", type: LoggerType.easy);
      return false;
    }

    if (num.tryParse(authenticationTime) == null) {
      // 設定無効
      LoggerUtil.log("AuthUtil isAuthTimeEnabled 設定無効=$authenticationTime", type: LoggerType.easy);
      return false;
    }

    return true;
  }

  Future<bool> isRequiredIfEnabled(DateTime? startTime, int timeout) async {
    LoggerUtil.log("AuthUtil isRequiredIfEnabled startTime=$startTime timeout=$timeout", type: LoggerType.easy);
    if (timeout < 0) {
      LoggerUtil.log("AuthUtil isRequiredIfEnabled timeout invalid", type: LoggerType.easy);
      return false;
    }

    if (startTime == null) {
      // 認証有効中
      LoggerUtil.log("AuthUtil isRequiredIfEnabled 認証有効中 startTime=$startTime timeout=$timeout", type: LoggerType.easy);
      return false;
    }

    if (timeout == 0) {
      // 即時認証
      LoggerUtil.log("AuthUtil isRequiredIfEnabled 即時認証", type: LoggerType.easy);
      return true;
    }

    DateTime currentTime = DateTime.now();
    Duration dif = currentTime.difference(startTime);
    LoggerUtil.log(
        "AuthUtil isRequiredIfEnabled "
        "startTime=$startTime currentTime=$currentTime timeout=$timeout "
        "dif=$dif dif.inMinutes=${dif.inMinutes}",
        type: LoggerType.easy);

    if (dif.inMinutes >= timeout) {
      LoggerUtil.log("AuthUtil isRequiredIfEnabled=true ${dif.inMinutes} >= $timeout", type: LoggerType.easy);
      return true;
    } else {
      LoggerUtil.log("AuthUtil isRequiredIfEnabled=false ${dif.inMinutes} < $timeout", type: LoggerType.easy);
      return false;
    }
  }

  Future<bool> isAvailable() async {
    bool isDeviceSupportedBool = false;
    List<BiometricType> biometricList = [];
    try {
      isDeviceSupportedBool = await _auth.isDeviceSupported();
      biometricList = await _auth.getAvailableBiometrics();
      bool canCheckBiometricsBool = await canCheckBiometrics();
      LoggerUtil.log(
          "AuthUtil isAvailable "
          "isDeviceSupported=$isDeviceSupportedBool "
          "canCheckBiometrics=$canCheckBiometricsBool "
          "getAvailableBiometrics=$biometricList",
          type: LoggerType.easy);
    } on PlatformException catch (e) {
      LoggerUtil.log("AuthUtil isAvailable error=$e", type: LoggerType.error);
    }
    return isDeviceSupportedBool && biometricList.isNotEmpty;
  }

  Future<bool> canCheckBiometrics() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      LoggerUtil.log("AuthUtil canCheckBiometrics error=$e", type: LoggerType.error);
    }
    return canCheckBiometrics;
  }

  Future<bool> isFaceAvailable() async {
    // Android の場合、[BiometricType.weak, BiometricType.strong]を返信します
    List<BiometricType> biometricList = [];
    try {
      biometricList = await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      LoggerUtil.log("AuthUtil isFaceAvailable error=$e", type: LoggerType.error);
    }
    return biometricList.contains(BiometricType.face);
  }

  Future<bool> isFingerprintAvailable() async {
    // Android の場合、[BiometricType.weak, BiometricType.strong]を返信します
    List<BiometricType> biometricList = [];
    try {
      biometricList = await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      LoggerUtil.log("AuthUtil isFingerprintAvailable error=$e", type: LoggerType.error);
    }
    return biometricList.contains(BiometricType.fingerprint);
  }

  Future<String> getAuthTypeName() async {
    bool isFaceAvailable = await AuthUtil.instance().isFaceAvailable();
    bool isFingerprintAvailable = await AuthUtil.instance().isFingerprintAvailable();
    String result = "useBiometricAuth";
    if (isFingerprintAvailable && isFaceAvailable) {
      result = "touchIdFaceIdUse";
    } else if (isFingerprintAvailable) {
      result = "touchIdUse";
    } else if (isFaceAvailable) {
      result = "useFaceId";
    }
    return result;
  }

  Future<bool> stopAuthentication() async {
    bool result = false;
    try {
      result = await _auth.stopAuthentication();
    } on PlatformException catch (e) {
      LoggerUtil.log("AuthUtil stopAuthentication error=$e", type: LoggerType.error);
    }
    return result;
  }

  DateTime? getPausedDate() {
    return _pausedDate;
  }

  void clearPauseDate() {
    LoggerUtil.log("AuthUtil clearPauseDate", type: LoggerType.easy);
    _pausedDate = null;
  }

  void clearWhenForgetPassword() {
    /// reset status
    setStatus(AuthStatus.done);
    clearPauseDate();

    // Lockのパスワード
    SpUtil.instance().set("lockPassWordId", "");
    // 生体認証有効時間
    SpUtil.instance().set("authenticationTime", "");
  }

  void setPausedDate() {
    _pausedDate = DateTime.now();
    LoggerUtil.log("AuthUtil setPausedDate pausedDate=$_pausedDate", type: LoggerType.easy);
    setStatusTodo();
  }

  bool isStatusDoing() {
    return _status == AuthStatus.doing;
  }

  bool isStatusSkip() {
    return _status == AuthStatus.skip;
  }

  bool isStatusInit() {
    return _status == AuthStatus.init;
  }

  bool isStatusDone() {
    return _status == AuthStatus.done;
  }

  void setStatus(AuthStatus status) {
    log("AuthUtil setStatus from $_status to $status", type: LoggerType.easy);
    _status = status;
  }

  void setStatusTodo() {
    log("AuthUtil setStatusTodo from $_status to AuthStatus.todo", type: LoggerType.easy);
    if (_status != AuthStatus.doing) {
      _status = AuthStatus.todo;
    }
  }
}

class AppLifecycleWatcher extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.detached:
        log("AuthUtil detached", type: LoggerType.easy);
        break;
      case AppLifecycleState.inactive:
        log("AuthUtil inactive", type: LoggerType.easy);
        break;
      case AppLifecycleState.hidden:
        log("AuthUtil hidden", type: LoggerType.easy);
        break;
      case AppLifecycleState.resumed:
        log("AuthUtil resumed", type: LoggerType.easy);
        AuthUtil.instance().checkAuthority();
        break;
      case AppLifecycleState.paused:
        log("AuthUtil paused", type: LoggerType.easy);
        AuthUtil.instance().setPausedDate();
        break;
    }
  }
}
