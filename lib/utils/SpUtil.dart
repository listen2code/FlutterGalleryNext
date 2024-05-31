import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';

class SpUtil {
  SpUtil._private() {
    debugPrint("_private start");
    SharedPreferences.setPrefix("sp_prefix_");
    debugPrint("_private end");
  }
  static final SpUtil instance = SpUtil._private();
  SharedPreferences? _mPrefs;

  final _lock = Lock();
  Future<void> initLock() async {
    debugPrint("init 1");
    if(null == _mPrefs) {
      await _lock.synchronized(() async {
        if(null == _mPrefs) {
          debugPrint("init 2");
          await Future.delayed(const Duration(seconds: 2));
          SharedPreferences.setPrefix("_sp_prefix");
          debugPrint("init 3");
          _mPrefs = await SharedPreferences.getInstance();
          debugPrint("init 4");
        }
      });
    }
  }

  Future<void> _init() async {
    debugPrint("init 1");
    if(null == _mPrefs) {
      debugPrint("init 2");
      await Future.delayed(const Duration(seconds: 2));
      debugPrint("init 3");
      _mPrefs = await SharedPreferences.getInstance();
      debugPrint("init 4");
    }
  }

  Future<dynamic?> getValue(String key) async {
    debugPrint("getValue start");
    await _init();
    debugPrint("getValue end");
    return Future.value(_mPrefs?.get(key));
  }
}