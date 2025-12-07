import 'package:package_libs/utils/logger_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  static final SpUtil _instance = SpUtil._internal();

  SpUtil._internal();

  static SpUtil get instance => _instance;

  late final SharedPreferences _prefs;

  Future<void> init({required String prefix}) async {
    SharedPreferences.setPrefix(prefix);
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> set(String key, dynamic value) {
    if (value is String) {
      return _prefs.setString(key, value);
    } else if (value is bool) {
      return _prefs.setBool(key, value);
    } else if (value is double) {
      return _prefs.setDouble(key, value);
    } else if (value is int) {
      return _prefs.setInt(key, value);
    } else if (value is List<String>) {
      return _prefs.setStringList(key, value);
    } else {
      LoggerUtil.warning("SpUtil.set: Unsupported type ${value.runtimeType} for key '$key'");
      return Future.value(false);
    }
  }

  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  int getInt(String key, {int defaultValue = 0}) {
    return _prefs.getInt(key) ?? defaultValue;
  }

  double getDouble(String key, {double defaultValue = 0.0}) {
    return _prefs.getDouble(key) ?? defaultValue;
  }

  String getString(String key, {String defaultValue = ""}) {
    return _prefs.getString(key) ?? defaultValue;
  }

  List<String> getStringList(String key, {List<String> defaultValue = const []}) {
    return _prefs.getStringList(key) ?? defaultValue;
  }

  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }
}
