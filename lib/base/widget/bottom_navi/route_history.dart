import 'package:flutter/material.dart';

HistoryRouteObserver routeHistoryObserver = HistoryRouteObserver();

class HistoryRouteObserver extends RouteObserver<PageRoute> {
  List<Route<dynamic>> history = <Route<dynamic>>[];

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    history.remove(route);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    history.add(route);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    history.remove(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute != null) {
      history.remove(oldRoute);
    }
    if (newRoute != null) {
      history.add(newRoute);
    }
  }
}
