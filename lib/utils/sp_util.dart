import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  SpUtil._private() {
    debugPrint("_private start");
    SharedPreferences.setPrefix("sp_prefix_");
    debugPrint("_private end");
  }

  static final SpUtil instance = SpUtil._private();
  SharedPreferences? _mPrefs;

  Future<void> init() async {
    if (null == _mPrefs) {
      await Future.delayed(const Duration(seconds: 2));
      _mPrefs = await SharedPreferences.getInstance();
    }
  }

  Future<bool> set(String key, dynamic value) async {
    await init();
    if (value is String) {
      return _mPrefs?.setString(key, value) ?? Future.value(false);
    } else if (value is int) {
      return _mPrefs?.setInt(key, value) ?? Future.value(false);
    } else if (value is double) {
      return _mPrefs?.setDouble(key, value) ?? Future.value(false);
    } else if (value is bool) {
      return _mPrefs?.setBool(key, value) ?? Future.value(false);
    } else if (value is List<String>) {
      return _mPrefs?.setStringList(key, value) ?? Future.value(false);
    }
    return Future.value(false);
  }

  Future<dynamic> get(String key) async {
    await init();
    return Future.value(_mPrefs?.get(key));
  }

  Future<bool> remove(String key) async {
    await init();
    return _mPrefs?.remove(key) ?? Future.value(false);
  }

  Future<bool> clear(String key) async {
    await init();
    return _mPrefs?.clear() ?? Future.value(false);
  }
}
