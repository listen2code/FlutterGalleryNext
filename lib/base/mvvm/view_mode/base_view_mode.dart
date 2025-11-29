import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/event_bus/event_bus.dart';
import 'package:flutter_gallery_next/base/mvvm/view/base_view.dart';
import 'package:flutter_gallery_next/base/mvvm/view_mode/base_controller.dart';
import 'package:flutter_gallery_next/base/network/base/base_api_use_case.dart';
import 'package:flutter_gallery_next/base/network/base/base_service.dart';
import 'package:flutter_gallery_next/base/network/base/session_info.dart';
import 'package:flutter_gallery_next/base/utils/login_util.dart';
import 'package:flutter_gallery_next/base/widget/dialog/common_dialog.dart';
import 'package:flutter_gallery_next/main.dart';
import 'package:get/get.dart';
import 'package:package_libs/utils/http_util.dart';
import 'package:package_libs/utils/logger_util.dart';

import 'base_action.dart';
import 'multi_net_data.dart';

abstract class ViewMode<Actions extends BaseAction, Service extends BaseService>
    extends BaseController {
  final Service api = Get.find<Service>();

  late final List<StreamSubscription> _eventSubList = [];

  bool isFront = true;

  bool isNetworkErrorShowing = false;

  @override
  void onClose() {
    super.onClose();
    for (var element in _eventSubList) {
      element.cancel();
    }
    api.cancelAllUseCase();
  }

  FutureOr dispatch(Actions action);

  void onValue(MultiNetData netData, Actions action);

  FutureOr request(var requests,
      {bool handleLoading = true,
      bool handleError = true,
      bool handleSuccess = true,
      bool handleBack = false,
      bool handleNetworkError = true,
      bool requestsChainCall = false,
      required Actions action}) async {
    showLoading(handleLoading);
    Future? future;
    if (requests is List<Future<ResponseEntity>>) {
      if (requestsChainCall) {
        future = _chainCall(requests).toList();
      } else {
        future = Future.wait(requests, eagerError: true);
      }
    } else if (requests is Future<ResponseEntity>) {
      future = requests;
    }

    return future?.then((net) {
      showSuccess(handleSuccess);
      MultiNetData data = MultiNetData(net);
      showApiResult(data, handleError, handleBack, handleNetworkError);
      onValue(data, action);
    }).catchError((e, stackTrace) {
      showError(handleError, handleBack, e: e, stackTrace: stackTrace);
      LoggerUtil.error("viewModel error: e=$e t=$stackTrace");
    }).whenComplete(() {
      dismissLoading(handleLoading);
    });
  }

  @mustCallSuper
  void onStackResume(BuildContext context) {
    isFront = true;
    final navigatorKey =
        Navigator.of(context).widget.key as GlobalKey<NavigatorState>;
    if (navigatorKey == Get.nestedKey(mainRouteKey)) {
      isFullScreen = true;
    } else {
      isFullScreen = false;
    }
    log("onStackResume:${context.widget}");
  }

  void onStackPause(BuildContext context) {
    isFront = false;
    log("onStackPause:${context.widget}");
  }

  void showApiResult(
    MultiNetData data,
    bool isShow,
    bool isBack,
    bool isNetworkShow,
  ) {
    if (data.errorData is! ResponseEntity) {
      return;
    }
    ResponseEntity responseEntity = data.errorData;
    switch (responseEntity.result) {
      case APIResult.success:
      case APIResult.loading:
      case APIResult.empty:
        break;
      case APIResult.generalError:
      case APIResult.systemError:
        showApiError(
          show: isShow,
          back: isBack,
          messageId: responseEntity.messageId,
          message: responseEntity.message,
        );
        break;
      case APIResult.sessionTimeout:
        onSessionTimeout();
        break;
      case APIResult.networkError:
        if (isNetworkShow) {
          showApiError(
            show: isShow,
            back: isBack,
            message: "errorNetworkErrorMessage",
          );
        }
        break;
    }
  }

  void onSessionTimeout() async {
    if (SessionInfo().isMember()) {
      reLoginAfter(true);
    } else {
      if (await LoginUtil.isAutoLogin()) {
        showLogin(callback: reLoginAfter);
      }
    }
  }

  void reLoginAfter(bool? isLogin) {
    log("session timeout login after exec", type: LoggerType.easy);
  }

  void showLogin({void Function(bool)? callback}) {
    // todo login
  }

  void showLoading(bool show) {
    if (show) {
      GlobalDialog.showLoading();
    }
  }

  void showSuccess(bool show) {}

  void showError(
    bool show,
    bool back, {
    required e,
    stackTrace,
    VoidCallback? closeAfter,
  }) {
    if (isFront) {
      var title = "errorTitle";
      var message = "errorTryMessage";
      GlobalDialog.showMessageDialog(
        message,
        title: title,
        closeAfter: () {
          var after = closeAfter;
          if (after != null) {
            after();
          }
          if (back == true) {
            apiErrorPageBack();
          }
        },
      );
    }
  }

  void apiErrorPageBack() {
    pageBack();
  }

  void showApiError({
    bool show = true,
    bool back = false,
    String? messageId,
    String? message,
    VoidCallback? closeAfter,
  }) {
    if (isFront) {
      if (show) {
        GlobalDialog.showMessageDialog(
          message ?? "",
          closeAfter: () {
            var after = closeAfter;
            if (after != null) {
              after();
            }
            if (back == true) {
              apiErrorPageBack();
            }
          },
        );
      }
    }
  }

  void dismissLoading(bool hasLoading) {
    if (hasLoading) {
      GlobalDialog.dismissLoading();
    }
  }

  Stream<ResponseEntity> _chainCall(List<Future<ResponseEntity>> tasks) async* {
    for (var element in tasks) {
      yield await element;
    }
  }

  void subscribe<T>(
      {String? key,
      required ISubscriber<T> subscriber,
      String? page,
      bool clearStickyEvent = true}) {
    _eventSubList.add(EventBus.defaultBus().subscribe<T>(
      subscriber: subscriber,
      key: key,
      page: page,
      clearStickyEvent: clearStickyEvent,
    ));
  }
}
