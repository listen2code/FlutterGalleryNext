import 'package:shared_preferences/shared_preferences.dart';

/// [describe] ローカルデータ管理ユーティリティクラス
class SpUtil {
  static final SpUtil _instance = SpUtil._private();
  static SharedPreferences? _prefs;

  /// [describe] SharedPreference.setPrefix 初期化
  SpUtil._private() {
    SharedPreferences.setPrefix("flutter_gallery_");
  }

  factory SpUtil.instance() => _instance;

  /// [describe] SharedPreference初期化
  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// [describe] データ設定
  Future<bool> set(String key, dynamic value) async {
    if (_prefs == null) await _init();

    if (value is String) {
      return _prefs!.setString(key, value);
    } else if (value is bool) {
      return _prefs!.setBool(key, value);
    } else if (value is double) {
      return _prefs!.setDouble(key, value);
    } else if (value is int) {
      return _prefs!.setInt(key, value);
    } else if (value is List<String>) {
      return _prefs!.setStringList(key, value);
    } else {
      // debugPrint("SharedPreferences setValue Unsupported Type");
      return Future.value(false);
    }
  }

  /// [describe] Bool データ取得-非同期処理
  Future<bool> getBoolAsync(String key, {defaultValue = false}) async {
    if (_prefs == null) await _init();
    bool? result = _prefs?.getBool(key);
    if (null == result) {
      return Future.value(defaultValue);
    }
    return Future.value(result);
  }

  /// [describe] int データ取得-非同期処理
  Future<int> getIntAsync(String key, {defaultValue = 0}) async {
    if (_prefs == null) await _init();
    int? result = _prefs?.getInt(key);
    if (null == result) {
      return Future.value(defaultValue);
    }
    return Future.value(result);
  }

  /// [describe] double データ取得-非同期処理
  Future<double> getDoubleAsync(String key, {defaultValue = 0.0}) async {
    if (_prefs == null) await _init();
    double? result = _prefs?.getDouble(key);
    if (null == result) {
      return Future.value(defaultValue);
    }
    return Future.value(result);
  }

  /// [describe] String データ取得-非同期処理
  Future<String> getStringAsync(String key, {defaultValue = ""}) async {
    if (_prefs == null) await _init();
    String? result = _prefs?.getString(key);
    if (null == result) {
      return Future.value(defaultValue);
    }
    return Future.value(result);
  }

  /// [describe] List<String> データ取得-非同期処理
  Future<List<String>> getStringListAsync(String key, {defaultValue}) async {
    if (_prefs == null) await _init();
    List<String>? result = _prefs?.getStringList(key);
    if (null == result) {
      return Future.value(defaultValue ?? []);
    }
    return Future.value(result);
  }

  /// [describe] Bool データ取得-同期処理
  bool getBool(String key, {defaultValue = false}) {
    bool? result = _prefs?.getBool(key);
    if (null == result) {
      return defaultValue;
    }
    return result;
  }

  /// [describe] int データ取得-同期処理
  int getInt(String key, {defaultValue = 0}) {
    int? result = _prefs?.getInt(key);
    if (null == result) {
      return defaultValue;
    }
    return result;
  }

  /// [describe] double データ取得-同期処理
  double getDouble(String key, {defaultValue = 0.0}) {
    double? result = _prefs?.getDouble(key);
    if (null == result) {
      return defaultValue;
    }
    return result;
  }

  /// [describe] String データ取得-同期処理
  String getString(String key, {defaultValue = ""}) {
    String? result = _prefs?.getString(key);
    if (null == result) {
      return defaultValue;
    }
    return result;
  }

  /// [describe] Bool データ取得-同期処理
  List<String> getStringList(String key, {defaultValue}) {
    List<String>? result = _prefs?.getStringList(key);
    if (null == result) {
      return defaultValue ?? [];
    }
    return result;
  }

  /// [describe] データ削除
  Future<bool> remove(String key) async {
    if (_prefs == null) await _init();
    return _prefs!.remove(key);
  }
}
