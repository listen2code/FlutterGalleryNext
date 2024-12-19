import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  static final SpUtil _instance = SpUtil._private();
  static SharedPreferences? _prefs;

  SpUtil._private() {
    SharedPreferences.setPrefix("flutter_gallery_");
  }

  factory SpUtil.instance() => _instance;

  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

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
      debugPrint("SharedPreferences setValue Unsupported Type");
      return Future.value(false);
    }
  }

  Future<bool> getBoolAsync(String key, {bool defaultValue = false}) async {
    if (_prefs == null) await _init();
    bool? result = _prefs?.getBool(key);
    if (null == result) {
      return Future.value(defaultValue);
    }
    return Future.value(result);
  }

  Future<int> getIntAsync(String key, {int defaultValue = 0}) async {
    if (_prefs == null) await _init();
    int? result = _prefs?.getInt(key);
    if (null == result) {
      return Future.value(defaultValue);
    }
    return Future.value(result);
  }

  Future<double> getDoubleAsync(String key, {double defaultValue = 0.0}) async {
    if (_prefs == null) await _init();
    double? result = _prefs?.getDouble(key);
    if (null == result) {
      return Future.value(defaultValue);
    }
    return Future.value(result);
  }

  Future<String> getStringAsync(String key, {String defaultValue = ""}) async {
    if (_prefs == null) await _init();
    String? result = _prefs?.getString(key);
    if (null == result) {
      return Future.value(defaultValue);
    }
    return Future.value(result);
  }

  Future<List<String>> getStringListAsync(String key, {defaultValue}) async {
    if (_prefs == null) await _init();
    List<String>? result = _prefs?.getStringList(key);
    if (null == result) {
      return Future.value(defaultValue ?? []);
    }
    return Future.value(result);
  }

  bool getBool(String key, {bool defaultValue = false}) {
    bool? result = _prefs?.getBool(key);
    if (null == result) {
      return defaultValue;
    }
    return result;
  }

  int getInt(String key, {int defaultValue = 0}) {
    int? result = _prefs?.getInt(key);
    if (null == result) {
      return defaultValue;
    }
    return result;
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    double? result = _prefs?.getDouble(key);
    if (null == result) {
      return defaultValue;
    }
    return result;
  }

  String getString(String key, {String defaultValue = ""}) {
    String? result = _prefs?.getString(key);
    if (null == result) {
      return defaultValue;
    }
    return result;
  }

  List<String> getStringList(String key, {defaultValue}) {
    List<String>? result = _prefs?.getStringList(key);
    if (null == result) {
      return defaultValue ?? [];
    }
    return result;
  }

  Future<bool> remove(String key) async {
    if (_prefs == null) await _init();
    return _prefs!.remove(key);
  }
}

class SpKey {
  SpKey._private();

  static const String uuid = "uuid";
  static const String loginId = "loginId";
  static const String password = "password";
}
