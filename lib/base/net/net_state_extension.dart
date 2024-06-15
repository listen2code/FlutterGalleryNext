import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension StateMixinExt on StateMixin<String> {
  Widget observe(NotifierBuilder widget,
      {String? id,
      Widget Function(String? error)? onError,
      Widget? onLoading,
      Widget? onEmpty}) {
    return CircularProgressIndicator();
  }
}
