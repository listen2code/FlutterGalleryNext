import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/network/base/session_info.dart';
import 'package:flutter_gallery_next/base/utils/login_util.dart';
import 'package:flutter_gallery_next/base/widget/bottom_navi/route_ext.dart';
import 'package:get/get_core/src/get_main.dart';

abstract class _RouteInterceptor {
  // 優先度、値が小さいほど優先度が高くなります
  //  -8 => 2 => 4 => 5
  int? priority;

  Future<T?>? runOnRedirect<T>({
    String? page,
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    bool closeCurrent = false,
    bool closeCurrentAll = false,
    bool closeTargetAll = false,
    RoutePredicate? predicate,
    bool needMemberLogin = false,
    List<CommonRouteInterceptor>? routeInterceptor,
  });
}

class CommonRouteInterceptor implements _RouteInterceptor {
  @override
  int? priority = -1;

  @override
  Future<T?>? runOnRedirect<T>({
    String? page,
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    bool closeCurrent = false,
    bool closeCurrentAll = false,
    bool closeTargetAll = false,
    RoutePredicate? predicate,
    bool needMemberLogin = false,
    List<CommonRouteInterceptor>? routeInterceptor,
  }) =>
      null;
}

class LoginRouteInterceptor extends CommonRouteInterceptor {
  @override
  int? get priority => -1;

  @override
  Future<T?>? runOnRedirect<T>({
    String? page,
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    bool closeCurrent = false,
    bool closeCurrentAll = false,
    bool closeTargetAll = false,
    RoutePredicate? predicate,
    bool needMemberLogin = false,
    List<CommonRouteInterceptor>? routeInterceptor,
  }) {
    bool isVisitor = !SessionInfo().isMember();

    Future<T?> convert(value) {
      if (T == bool || T == dynamic) {
        return Future.value(value as T);
      } else {
        return Future.value(null);
      }
    }

    if (isVisitor && !ignoreRoutes().contains(page)) {
      // ビジターであり、ログインが必要なルートであるため、ログイン画面にリダイレクトされる
      return Get.toFullScreen(LoginUtil.getLoginPageRoute())?.then((proceed) {
        if (proceed == true && page != null && id != null) {
          // ログインに成功しました。ルーティングを続行する
          return Get.toNamedWithNavi(
            page,
            arguments: arguments,
            id: id,
            preventDuplicates: preventDuplicates,
            parameters: parameters,
            closeCurrent: closeCurrent,
            closeCurrentAll: closeCurrentAll,
            closeTargetAll: closeTargetAll,
            predicate: predicate,
            needMemberLogin: needMemberLogin,
            routeInterceptor: routeInterceptor,
          );
        } else if (proceed == true && (page == null || id == null)) {
          // ログインに成功しました。前のロジックを続行する
          return convert(true);
        } else {
          // ログインが失敗し、何もしない
          return null;
        }
      });
    } else {
      // メンバーであり。インターセプトなし
      if (page != null && id != null) {
        // ルーティングロジック
        return null;
      } else {
        // 非ルーティングロジック
        return convert(true);
      }
    }
  }

  List<String> ignoreRoutes() {
    // return [Routes.settingsLogin, Routes.loginTop, Routes.memberLogin, Routes.ccwebLogin];
    return [];
  }
}

class RouteInterceptorRunner {
  RouteInterceptorRunner(this._routeInterceptors);

  final List<CommonRouteInterceptor>? _routeInterceptors;

  List<CommonRouteInterceptor> _getInterceptors() {
    final m = _routeInterceptors ?? <CommonRouteInterceptor>[];
    return m
      ..sort(
        (a, b) => (a.priority ?? 0).compareTo(b.priority ?? 0),
      );
  }

  Future<T?>? runOnRedirect<T>({
    String? page,
    dynamic arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    bool closeCurrent = false,
    bool closeCurrentAll = false,
    bool closeTargetAll = false,
    RoutePredicate? predicate,
    bool needMemberLogin = false,
    List<CommonRouteInterceptor>? routeInterceptor,
  }) {
    Future<T?>? to;
    for (final element in _getInterceptors()) {
      to = element.runOnRedirect(
        page: page,
        arguments: arguments,
        id: id,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        closeCurrent: closeCurrent,
        closeCurrentAll: closeCurrentAll,
        closeTargetAll: closeTargetAll,
        predicate: predicate,
        needMemberLogin: needMemberLogin,
        routeInterceptor: routeInterceptor,
      );
      if (to != null) {
        Get.log("RouteIntercepted wantTo $page, redirect by ${element.runtimeType}");
        break;
      }
    }

    return to;
  }
}

Future<T?>? runOnRedirect<T>({
  String? page,
  dynamic arguments,
  int? id,
  bool preventDuplicates = true,
  Map<String, String>? parameters,
  bool closeCurrent = false,
  bool closeCurrentAll = false,
  bool closeTargetAll = false,
  RoutePredicate? predicate,
  bool needMemberLogin = false,
  List<CommonRouteInterceptor>? routeInterceptor,
}) {
  final runner = RouteInterceptorRunner([
    ...?routeInterceptor,
    if (needMemberLogin) ...[loginRouteInterceptor]
  ]);
  return runner.runOnRedirect(
    page: page,
    arguments: arguments,
    id: id,
    preventDuplicates: preventDuplicates,
    parameters: parameters,
    closeCurrent: closeCurrent,
    closeCurrentAll: closeCurrentAll,
    closeTargetAll: closeTargetAll,
    predicate: predicate,
    needMemberLogin: needMemberLogin,
    routeInterceptor: routeInterceptor,
  );
}

LoginRouteInterceptor loginRouteInterceptor = LoginRouteInterceptor();
