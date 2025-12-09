import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/widget/base/base_view.dart';
import 'package:flutter_gallery_next/base/widget/bottom_navi/bottom_navi.dart';
import 'package:flutter_gallery_next/base/widget/bottom_navi/route_interceptor.dart';
import 'package:flutter_gallery_next/main.dart';
import 'package:get/get.dart';

import 'multi_navigator.dart';

extension GetExtension on GetInterface {
  Future<T?>? toTab1<T>(
    String page, {
    dynamic arguments,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    bool closeCurrent = false,
    bool closeCurrentAll = false,
    bool closeTargetAll = false,
    RoutePredicate? predicate,
    bool needMemberLogin = false,
    List<CommonRouteInterceptor>? routeInterceptor,
  }) {
    return toNamedWithNavi(page,
        id: BottomNaviImpl.instance().assets,
        arguments: arguments,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        closeCurrent: closeCurrent,
        closeCurrentAll: closeCurrentAll,
        closeTargetAll: closeTargetAll,
        predicate: predicate,
        needMemberLogin: needMemberLogin,
        routeInterceptor: routeInterceptor);
  }

  Future<T?>? toTab2<T>(
    String page, {
    dynamic arguments,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    bool closeCurrent = false,
    bool closeCurrentAll = false,
    bool closeTargetAll = false,
    RoutePredicate? predicate,
    bool needMemberLogin = false,
    List<CommonRouteInterceptor>? routeInterceptor,
  }) {
    return toNamedWithNavi(page,
        id: BottomNaviImpl.instance().order,
        arguments: arguments,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        closeCurrent: closeCurrent,
        closeCurrentAll: closeCurrentAll,
        closeTargetAll: closeTargetAll,
        predicate: predicate,
        needMemberLogin: needMemberLogin,
        routeInterceptor: routeInterceptor);
  }

  Future<T?>? toTab3<T>(
    String page, {
    dynamic arguments,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    bool closeCurrent = false,
    bool closeCurrentAll = false,
    bool closeTargetAll = false,
    RoutePredicate? predicate,
    bool needMemberLogin = false,
    List<CommonRouteInterceptor>? routeInterceptor,
  }) {
    return toNamedWithNavi(page,
        id: BottomNaviImpl.instance().feeds,
        arguments: arguments,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        closeCurrent: closeCurrent,
        closeCurrentAll: closeCurrentAll,
        closeTargetAll: closeTargetAll,
        predicate: predicate,
        needMemberLogin: needMemberLogin,
        routeInterceptor: routeInterceptor);
  }

  Future<T?>? toCurrentTab<T>(
    String page, {
    dynamic arguments,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    bool closeCurrent = false,
    bool closeCurrentAll = false,
    bool closeTargetAll = false,
    RoutePredicate? predicate,
    bool needMemberLogin = false,
    List<CommonRouteInterceptor>? routeInterceptor,
  }) {
    return toNamedWithNavi(page,
        id: currentStackIndex,
        arguments: arguments,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        closeCurrent: closeCurrent,
        closeCurrentAll: closeCurrentAll,
        closeTargetAll: closeTargetAll,
        predicate: predicate,
        needMemberLogin: needMemberLogin,
        routeInterceptor: routeInterceptor);
  }

  Future<T?>? toFullScreen<T>(
    String page, {
    dynamic arguments,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    bool closeCurrent = false,
    bool closeCurrentAll = false,
    RoutePredicate? predicate,
    bool needMemberLogin = false,
    List<CommonRouteInterceptor>? routeInterceptor,
  }) {
    return toNamedWithNavi(page,
        id: mainRouteKey,
        arguments: arguments,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        closeCurrent: closeCurrent,
        closeCurrentAll: closeCurrentAll,
        predicate: predicate,
        needMemberLogin: needMemberLogin,
        routeInterceptor: routeInterceptor);
  }

  Future<T?>? toNamedWithNavi<T>(
    String page, {
    dynamic arguments,
    required int id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    bool closeCurrent = false,
    bool closeCurrentAll = false,
    bool closeTargetAll = false,
    RoutePredicate? predicate,
    bool needMemberLogin = false,
    List<CommonRouteInterceptor>? routeInterceptor,
  }) {
    String current = id == mainRouteKey ? currentRoute : multiRouting.current;
    if (current == page && preventDuplicates) {
      return null;
    }

    Route? oldRoute;
    if (id != mainRouteKey) {
      oldRoute = BottomNaviImpl.instance().getRoutingByIndex(id).history.firstWhereOrNull((route) => route.settings.name == page);
      if (oldRoute != null) {
        Get.removeRoute(oldRoute, id: id);
      }
    }
    if (parameters != null) {
      final uri = Uri(path: page, queryParameters: parameters);
      page = uri.toString();
    }

    Future<T?>? newPage = runOnRedirect(
      page: page,
      arguments: arguments,
      id: id,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      closeCurrent: closeCurrent,
      predicate: predicate,
      needMemberLogin: needMemberLogin,
      routeInterceptor: routeInterceptor,
    );
    if (newPage != null) {
      return newPage;
    }
    if (closeCurrent) {
      if (id != (isFullScreen ? mainRouteKey : currentStackIndex)) {
        // 現在の画面と遷移先の画面は異なるルーティング スタックです
        Get.close(1, isFullScreen ? mainRouteKey : currentStackIndex);
        return global(id).currentState?.pushNamed<T>(
              page,
              arguments: arguments,
            );
      } else {
        return global(id).currentState?.pushReplacementNamed(
              page,
              arguments: arguments,
            );
      }
    } else if (closeCurrentAll || closeTargetAll) {
      RoutePredicate routePredicate = predicate ?? (route) => route.settings.name == "home";
      if (id != (isFullScreen ? mainRouteKey : currentStackIndex)) {
        // 現在の画面と遷移先の画面は異なるルーティング スタックです
        if (closeCurrentAll) {
          if (!isFullScreen && page != BottomNaviImpl.instance().currentTab.top) {
            routePredicate = predicate ??
                (route) =>
                    route.settings.name == BottomNaviImpl.instance().currentTab.top || route.settings.name == "/placeHolder";
          }
          Get.until(routePredicate, id: isFullScreen ? mainRouteKey : currentStackIndex);
        }
        if (closeTargetAll) {
          if (id != mainRouteKey && page != BottomNaviImpl.instance().getTabByIndex(id).top) {
            routePredicate = predicate ??
                (route) =>
                    route.settings.name == BottomNaviImpl.instance().getTabByIndex(id).top ||
                    route.settings.name == "/placeHolder";
          }
          Get.until(routePredicate, id: id);
        }
        return global(id).currentState?.pushNamed<T>(
              page,
              arguments: arguments,
            );
      } else {
        if (id != mainRouteKey && page != BottomNaviImpl.instance().getTabByIndex(id).top) {
          routePredicate = predicate ??
              (route) =>
                  route.settings.name == BottomNaviImpl.instance().getTabByIndex(id).top || route.settings.name == "/placeHolder";
        }
        Get.until(routePredicate, id: id);
        return global(id).currentState?.pushNamed<T>(
              page,
              arguments: arguments,
            );
      }
    }
    return global(id).currentState?.pushNamed<T>(
          page,
          arguments: arguments,
        );
  }

  void backToTop<T>(int id) {
    String topPage = BottomNaviImpl.instance().getTabByIndex(id).top;
    Route? topRoute =
        BottomNaviImpl.instance().getRoutingByIndex(id).history.firstWhereOrNull((route) => route.settings.name == topPage);
    if (topRoute != null) {
      Get.until((route) => route.settings.name == topPage, id: id);
    } else {
      Get.offAllNamed(topPage, id: id);
    }
  }

  int get currentStackIndex => Get.find<NavigationController>().currentStackIndex;

  NavigatorState? get currentNaviState => Get.global(currentStackIndex).currentState;

  BuildContext? get currentContext => Get.global(currentStackIndex).currentContext;

  Widget? get currentWidget => Get.global(currentStackIndex).currentWidget;

  MultiRouting get multiRouting => BottomNaviImpl.instance().multiRouting;

  bool get isFromBottomNaviClick => Get.find<NavigationController>().isFromBottomNaviClick;
}
