// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension StateMixinExt on StateMixin<String> {
  Widget observe(
    NotifierBuilder widget, {
    String? id,
    Widget Function(String? error)? onError,
    Widget? onLoading,
    Widget? onEmpty,
  }) {
    var lastStatus = status;
    SimpleBuilder simpleBuilder = SimpleBuilder(
      builder: (_) {
        status.toString();
        if ((value == null || id == null) || value == id) {
          lastStatus = status;
        }
        if (lastStatus.isLoading) {
          return onLoading ?? const Center(child: CircularProgressIndicator());
        } else if (lastStatus.isError) {
          return onError != null
              ? onError(lastStatus.errorMessage)
              : Center(
                  child: Text('A error occurred: ${lastStatus.errorMessage}'));
        } else if (lastStatus.isEmpty) {
          return onEmpty ?? const SizedBox.shrink();
        }
        return widget(value);
      },
    );
    return simpleBuilder;
  }
}
