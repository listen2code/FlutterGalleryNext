import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/event_bus/event_bus_key.dart';
import 'package:flutter_gallery_next/base/mvvm/vm/base_view_model.dart';
import 'package:flutter_gallery_next/base/network/base/base_service.dart';
import 'package:flutter_gallery_next/base/network/base/session_info.dart';
import 'package:package_libs/utils/logger_util.dart';

import 'base_action.dart';

mixin SessionChangeMixin<Actions extends BaseAction,
    Service extends BaseService> on ViewModel<Actions, Service> {
  Completer<void>? loginFuture;
  Completer<void>? logoutFuture;

  final List<String> _events = [];

  bool _isLoginEvent = false;
  bool _isLogoutEvent = false;

  List<String> get events => _events;

  bool get isLoginEvent => _isLoginEvent;

  bool get isLogoutEvent => _isLogoutEvent;

  @override
  void onInit() {
    super.onInit();
    subscribe<String>(
        subscriber: (event) async {
          log(event, type: LoggerType.debug);
          if (isFront) {
            loginEventAfterResume();
          } else {
            loginFuture = Completer();
            await loginFuture?.future;
            loginEventAfterResume();
          }
        },
        key: EventBusKeys.login);
    subscribe<String>(
        subscriber: (event) async {
          log(event, type: LoggerType.debug);
          if (isFront) {
            logoutEventAfterResume();
          } else {
            logoutFuture = Completer();
            await logoutFuture?.future;
            logoutEventAfterResume();
          }
        },
        key: EventBusKeys.logout);
  }

  @override
  void onStackResume(BuildContext context) {
    _setEventValue();
    super.onStackResume(context);
    if (SessionInfo().isMember() && !_events.contains(EventBusKeys.logout)) {
      loginFuture?.complete();
      loginFuture = null;
    } else {
      logoutFuture?.complete();
      logoutFuture = null;
    }
  }

  void loginEventAfterResume() {
    _events.clear();
  }

  void logoutEventAfterResume() {
    _events.clear();
  }

  void _setEventValue() {
    _isLoginEvent = _events.contains(EventBusKeys.login);
    _isLogoutEvent = _events.contains(EventBusKeys.logout);
  }
}
