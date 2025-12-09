import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/utils/app_constants.dart';
import 'package:flutter_gallery_next/base/widget/bottom_navi/route_ext.dart';
import 'package:flutter_gallery_next/generated/r.dart';
import 'package:flutter_gallery_next/main.dart';
import 'package:get/get.dart';
import 'package:package_libs/utils/logger_util.dart';
import 'package:package_libs/utils/sp_util.dart';

import 'multi_navigator.dart';

enum BottomNavigationType { defaultType, customType }

typedef TabClickListener = void Function(int to, bool isTop);

sealed class BottomNavigationButton {
  final IBottomNavi tab;
  final String iconPath;
  final String activeIconPath;
  final String label;
  final String top;
  String page;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BottomNavigationButton &&
          runtimeType == other.runtimeType &&
          iconPath == other.iconPath &&
          activeIconPath == other.activeIconPath &&
          label == other.label &&
          top == other.top;

  @override
  int get hashCode => iconPath.hashCode ^ activeIconPath.hashCode ^ label.hashCode ^ top.hashCode;

  void gotoOtherTab(int to) {
    tab.gotoOtherTab(to);
  }

  BottomNavigationButton(
      {required this.tab,
      required this.iconPath,
      required this.activeIconPath,
      required this.label,
      required this.top,
      required this.page});
}

class Tab1 extends BottomNavigationButton {
  Tab1._private({
    required super.tab,
  }) : super(
          iconPath: R.imagesLake,
          activeIconPath: R.imagesLake,
          label: "tab1",
          top: "/tab1",
          page: "/tab1",
        );
}

class Tab2 extends BottomNavigationButton {
  Tab2._private({
    required super.tab,
  }) : super(
          iconPath: R.imagesLake,
          activeIconPath: R.imagesLake,
          label: "tab2",
          top: "/tab2",
          page: "/tab2",
        );
}

class Tab3 extends BottomNavigationButton {
  Tab3._private({
    required super.tab,
  }) : super(
          iconPath: R.imagesLake,
          activeIconPath: R.imagesLake,
          label: "tab3",
          top: "/tab3",
          page: "/tab3",
        );
}

abstract class IBottomNavi {
  Iterable<BottomNavigationButton> get tabs;

  MultiRouting get multiRouting;

  BottomNavigationButton get currentTab;

  MultiRouting getRoutingByIndex(int index);

  void gotoOtherTab(int to);

  BottomNavigationButton getTabByIndex(int index);
}

class BottomNaviImpl implements IBottomNavi {
  late final List<BottomNavigationButton> _list = <BottomNavigationButton>[];
  late final List<MultiRouting> _routing = <MultiRouting>[];
  late Iterable<BottomNavigationButton> _tabs = <BottomNavigationButton>[];
  late final List<TabClickListener> _tabOnClickListeners = [];

  late final Tab1 _assets;

  late final Tab2 _order;

  late final Tab3 _feed;

  late final MultiRouting _assetRouting;

  late final MultiRouting _orderRouting;

  late final MultiRouting _feedRouting;

  late final MultiRouting _myPageRouting;

  final Map<int, dynamic> _initialRoutesArgs = {};

  static BottomNaviImpl? _instance;

  factory BottomNaviImpl.instance({BottomNavigationType? type}) {
    return _instance ??= BottomNaviImpl._private(BottomNavigationType.defaultType);
  }

  BottomNaviImpl._private(BottomNavigationType type) {
    switch (type) {
      case BottomNavigationType.defaultType:
        _assets = Tab1._private(tab: this);
        _order = Tab2._private(tab: this);
        _feed = Tab3._private(tab: this);
        _list.add(_assets);
        _list.add(_order);
        _list.add(_feed);
        _tabs = Iterable.castFrom(_list);

        _assetRouting = MultiRouting();
        _orderRouting = MultiRouting();
        _feedRouting = MultiRouting();
        _myPageRouting = MultiRouting();
        _routing.add(_assetRouting);
        _routing.add(_orderRouting);
        _routing.add(_feedRouting);
        _routing.add(_myPageRouting);
        break;
      case BottomNavigationType.customType:
      // load menu form disk
    }
  }

  @override
  void gotoOtherTab(int to) async {
    if (_list.length > to) {
      bool canGoto = true;
      Get.find<NavigationController>().isFromBottomNaviClick = true;
      if (Get.currentStackIndex == to && getTabByIndex(to).top != multiRouting.current) {
        bool routeExists = false;
        Get.until((r) {
          if (r.settings.name == _list[to].top) {
            routeExists = true;
            return true;
          }
          return false;
        }, id: to);
        if (!routeExists) {
          Get.toNamedWithNavi(_list[to].top, id: to, preventDuplicates: false);
        }
      } else if (Get.currentStackIndex == to) {
        canGoto = false;
      } else {
        bool isTopIntent = (BottomNaviImpl.instance().getRoutingByIndex(to).history.isEmpty ||
            BottomNaviImpl.instance().getRoutingByIndex(to).history.first.settings.name == "/placeHolder");
        if (isTopIntent) {
          Get.toNamedWithNavi(BottomNaviImpl.instance().getTabByIndex(to).top, id: to);
        }
      }
      for (TabClickListener tabClick in _tabOnClickListeners) {
        tabClick.call(to, !canGoto);
      }
      if (canGoto) {
        Get.find<NavigationController>().changePage(to, isRoute: false);
        _list[Get.currentStackIndex].page = multiRouting.current;
      }
    }
  }

  void registerOnTabClickListener(TabClickListener listener) {
    _tabOnClickListeners.add(listener);
  }

  void unRegisterOnTabClickListener(TabClickListener listener) {
    _tabOnClickListeners.remove(listener);
  }

  @override
  MultiRouting getRoutingByIndex(int index) => _routing[index];

  @override
  BottomNavigationButton getTabByIndex(int index) => _list[index];

  @override
  MultiRouting get multiRouting => getRoutingByIndex(Get.currentStackIndex);

  @override
  BottomNavigationButton get currentTab => getTabByIndex(Get.currentStackIndex);

  @override
  Iterable<BottomNavigationButton> get tabs => _tabs;

  List<Navigator> createMultiNavigator() {
    return List.generate(tabs.length, (index) {
      return MultiNavigator(
        key: Get.nestedKey(index),
        routingNavi: getRoutingByIndex(index),
        initialRoute: index != getNavigatorSelectedIndex() ? "/placeHolder" : getTabByIndex(index).top,
        onGenerateInitialRoutes: (navi, name) =>
            initialRoutesGenerate(name, unknownRoute: unknownPage, args: _initialRoutesArgs[index]),
        onGenerateRoute: (routeSettings) => findNavigatorRoute(routeSettings, unknownRoute: unknownPage),
      );
    });
  }

  GetPageRoute findNavigatorRoute(RouteSettings routeSettings, {GetPage? unknownRoute}) {
    Get.find<NavigationController>().isFromBottomNaviClick = false;
    return PageRedirect(settings: routeSettings, unknownRoute: unknownRoute).page();
  }

  List<Route<dynamic>> initialRoutesGenerate(String name, {GetPage? unknownRoute, dynamic args}) {
    return [
      PageRedirect(
        settings: RouteSettings(name: name, arguments: args),
        unknownRoute: unknownRoute,
      ).page()
    ];
  }

  void removeHolderPageIfTop(int to, bool isTopIntent) {
    if (isTopIntent &&
        BottomNaviImpl.instance().getRoutingByIndex(to).history.isNotEmpty &&
        BottomNaviImpl.instance().getRoutingByIndex(to).history.first.settings.name == "/placeHolder") {
      Get.global(to).currentState?.removeRoute(BottomNaviImpl.instance().getRoutingByIndex(to).history.first);
    }
  }

  int get assets => _currentIndex(_assets);

  int get order => _currentIndex(_order);

  int get feeds => _currentIndex(_feed);

  MultiRouting get assetRouting => _assetRouting;

  MultiRouting get orderRouting => _orderRouting;

  MultiRouting get feedRouting => _feedRouting;

  set assetsInitialRoutesArgs(dynamic args) => _initialRoutesArgs[assets] = args;

  set orderInitialRoutesArgs(dynamic args) => _initialRoutesArgs[order] = args;

  set feedsInitialRoutesArgs(dynamic args) => _initialRoutesArgs[feeds] = args;

  int _currentIndex(BottomNavigationButton tab) {
    return _list.indexOf(tab);
  }

  void restartApp() {
    for (var action in tabs) {
      Get.until((r) {
        return r.settings.name == action.top;
      }, id: _currentIndex(action));
    }

    Get.until((r) {
      return r.settings.name == "/home";
    }, id: mainRouteKey);

    gotoOtherTab(assets);
  }
}

int getNavigatorSelectedIndex() {
  int selectedIndex = SpUtil.instance.getInt(SpKey.navigatorSelectedIndex, defaultValue: BottomNaviImpl.instance().assets);
  LoggerUtil.log("getNavigatorSelectedIndex：$selectedIndex", type: LoggerType.easy);
  return selectedIndex;
}

void saveNavigatorSelectedIndex(int selectedIndex) {
  LoggerUtil.log("saveNavigatorSelectedIndex：$selectedIndex", type: LoggerType.easy);
  SpUtil.instance.set(SpKey.navigatorSelectedIndex, selectedIndex);
}

final unknownPage = GetPage(
  name: "/unknownPage",
  page: () => const Text("unknownPage"),
);
