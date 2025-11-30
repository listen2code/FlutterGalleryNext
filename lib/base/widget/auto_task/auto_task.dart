import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/network/base/base_service.dart';
import 'package:flutter_gallery_next/base/view_model/base_action.dart';
import 'package:flutter_gallery_next/base/view_model/base_view_model.dart';
import 'package:package_libs/utils/auth_util.dart';
import 'package:package_libs/utils/logger_util.dart';

mixin AutoReloadMixin<Actions extends BaseAction, Service extends BaseService> on ViewModel<Actions, Service> {
  late DataRefresher refresher;

  int get interval => 5000;

  @override
  void onInit() {
    super.onInit();
    refresher = DataRefresher.instance(interval);
    refresher.setStrategy(fetchData);
    refresher.setUpdateInterval(updateInterval);
  }

  @override
  void onResumed() {
    super.onResumed();
    if (isFront) {
      refresher.startTask();
    }
  }

  @override
  void onStackResume(BuildContext context) {
    super.onStackResume(context);
    refresher.startTask();
  }

  @override
  void onStackPause(BuildContext context) {
    super.onStackPause(context);
    refresher.stopTask();
  }

  @override
  void onPaused() {
    super.onPaused();
    refresher.stopTask();
  }

  @override
  void onClose() {
    super.onClose();
    refresher.stopTask();
  }

  Future<void> fetchData() async {}

  void updateInterval() {
    refresher.interval = interval;
  }
}

class DataRefresher {
  Timer? _timer;

  int _interval;

  RefreshState _state = StoppedState();

  RefreshStrategy? _strategy;
  VoidCallback? _updateInterval;

  factory DataRefresher.instance([int time = 5000]) => DataRefresher._private(time);

  DataRefresher._private(int time) : _interval = time;

  void startTask() {
    if (_state is RunningState) {
      return;
    }
    _state = RunningState();
    handleState();
  }

  void stopTask() {
    if (_state is StoppedState) {
      return;
    }
    _state = StoppedState();
    handleState();
  }

  void setStrategy(RefreshStrategy strategy) {
    _strategy = strategy;
    if (_state is RunningState) {
      handleState();
    }
  }

  void setUpdateInterval(VoidCallback? updateInterval) {
    _updateInterval = updateInterval;
  }

  set interval(int interval) {
    if (_interval != interval) {
      _interval = interval;
      stopTask();
      startTask();
    }
  }

  void handleState() {
    _timer?.cancel();
    _state.handle(this);
  }
}

typedef RefreshStrategy = Future<void> Function();

abstract class RefreshState {
  void handle(DataRefresher context);
}

class RunningState implements RefreshState {
  @override
  void handle(DataRefresher context) {
    context._timer = Timer.periodic(Duration(milliseconds: context._interval), (Timer timer) {
      if (!AuthUtil.instance().isStatusDoing()) {
        context._strategy?.call();
      }
      context._updateInterval?.call();
    });
    LoggerUtil.log("RunningState start");
  }
}

class StoppedState implements RefreshState {
  @override
  void handle(DataRefresher context) {
    context._timer = null;
    LoggerUtil.log("RunningState stop");
  }
}
