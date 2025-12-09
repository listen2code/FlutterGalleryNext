import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/router_report.dart';

import 'bottom_navi.dart';

class MultiNavigator extends Navigator {
  final ValueChanged<Routing?>? routingCallback;
  final MultiRouting? routingNavi;

  MultiNavigator({
    GlobalKey<NavigatorState>? super.key,
    Function(Page<Object?> page)? super.onDidRemovePage,
    super.pages,
    super.initialRoute,
    super.onGenerateInitialRoutes,
    super.onGenerateRoute,
    List<NavigatorObserver>? observers,
    super.reportsRouteUpdateToEngine,
    TransitionDelegate? transitionDelegate,
    this.routingCallback,
    this.routingNavi,
  }) : super(
          observers: [
            ...[MultiNaviObserver(routingCallback, routingNavi)],
            if (observers != null) ...observers,
          ],
          transitionDelegate: transitionDelegate ?? const DefaultTransitionDelegate<dynamic>(),
        );

  @override
  NavigatorState createState() => MultiNavigatorState();
}

class MultiNavigatorState extends NavigatorState {
  @override
  Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) {
    GlobalKey<NavigatorState>? navi = widget.key as GlobalKey<NavigatorState>?;
    int naviStack = Get.keys.entries.firstWhere((element) => element.value == navi).key;
    BottomNaviImpl.instance()
        .removeHolderPageIfTop(naviStack, routeName == BottomNaviImpl.instance().getTabByIndex(naviStack).top);
    Get.find<NavigationController>().changePage(naviStack);
    return super.pushNamed(routeName, arguments: arguments);
  }

  @override
  Future<T?> pushAndRemoveUntil<T extends Object?>(Route<T> newRoute, RoutePredicate predicate) {
    GlobalKey<NavigatorState>? navi = widget.key as GlobalKey<NavigatorState>?;
    int naviStack = Get.keys.entries.firstWhere((element) => element.value == navi).key;
    BottomNaviImpl.instance()
        .removeHolderPageIfTop(naviStack, newRoute.settings.name == BottomNaviImpl.instance().getTabByIndex(naviStack).top);
    Get.find<NavigationController>().changePage(naviStack);
    return super.pushAndRemoveUntil(newRoute, predicate);
  }

  @override
  void pop<T extends Object?>([T? result]) {
    // 現在のルーティングスタックを取得する
    GlobalKey<NavigatorState>? navi = widget.key as GlobalKey<NavigatorState>?;
    int naviStack = Get.keys.entries.firstWhere((element) => element.value == navi).key;
    var canPop = Get.global(naviStack).currentState?.canPop();
    bool isPlaceHolder = BottomNaviImpl.instance().getRoutingByIndex(naviStack).history.length == 2 &&
        BottomNaviImpl.instance().getRoutingByIndex(naviStack).history.first.settings.name == "/placeHolder";
    if (canPop == true && !isPlaceHolder) {
    } else {
      Get.find<NavigationController>().remove(naviStack);
    }
    super.pop(result);
  }
}

class MultiNaviObserver extends GetObserver {
  final MultiRouting? routingNavi;

  MultiNaviObserver(routing, this.routingNavi) : super(routing, routingNavi);

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    routingNavi?.history.remove(route);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    routingNavi?.history.add(route);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    routingNavi?.history.remove(route);
    RouterReportManager.reportRouteDispose(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute != null) {
      routingNavi?.history.remove(oldRoute);
    }
    if (newRoute != null) {
      routingNavi?.history.add(newRoute);
    }
  }
}

class MultiRouting extends Routing {
  int get currentNavi => Get.find<NavigationController>().selectedIndex;
  List<Route<dynamic>> history = <Route<dynamic>>[];

  MultiRouting({
    super.current,
    super.previous,
    super.args,
    super.removed,
    super.route,
    super.isBack,
    super.isBottomSheet,
    super.isDialog,
  });
}

class NavigationController extends GetxController {
  late int currentStackIndex;
  late final int initStackIndex;
  late bool isFromBottomNaviClick;
  late final RxInt _selectedIndex;

  late ({bool isChange, int lastIndex}) _stackChangeHistory;

  late final Set<int> _navigationStack;
  late final List<Navigator> _navigatorPages;

  @override
  void onInit() {
    super.onInit();
    initStackIndex = getNavigatorSelectedIndex();
    currentStackIndex = initStackIndex;
    isFromBottomNaviClick = false;
    _selectedIndex = initStackIndex.obs;
    _stackChangeHistory = (isChange: false, lastIndex: initStackIndex);
    _navigationStack = {initStackIndex};
    _navigatorPages = BottomNaviImpl.instance().createMultiNavigator();
  }

  int get selectedIndex => _selectedIndex.value;

  set selectedIndex(int selectedIndex) => changePage(selectedIndex);

  void tryRestoreStackPosition() {
    if (_stackChangeHistory.isChange) {
      changePage(_stackChangeHistory.lastIndex);
    }
  }

  void changePage(int index, {String? init, dynamic args, bool isRoute = true}) {
    _stackChangeHistory = (isChange: _selectedIndex.value != index && isRoute, lastIndex: _selectedIndex.value);
    _selectedIndex.value = index;
    currentStackIndex = index;
    if (!_navigationStack.add(index)) {
      _navigationStack
        ..remove(index)
        ..add(index);
    }
    if (_navigationStack.length > BottomNaviImpl.instance().tabs.length) {
      _navigationStack.remove(_navigationStack.first);
    }
  }

  void removeAtSelectedIndex() {
    remove(selectedIndex);
  }

  void remove(int index) {
    _navigationStack.remove(index);
    if (_navigationStack.isNotEmpty) {
      _selectedIndex.value = _navigationStack.last;
      currentStackIndex = _navigationStack.last;
    }
  }
}

