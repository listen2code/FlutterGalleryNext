import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/biz/demos/demo_auth.dart';
import 'package:flutter_gallery_next/biz/demos/demo_imports.dart';
import 'package:flutter_gallery_next/biz/demos/demo_intl.dart';
import 'package:flutter_gallery_next/biz/demos/demo_repaint.dart';
import 'package:flutter_gallery_next/biz/demos/drawer/demo_drawer.dart';
import 'package:flutter_gallery_next/biz/demos/event_bus/demo_event_bus.dart';
import 'package:flutter_gallery_next/biz/demos/tab/demo_tab_bar.dart';
import 'package:flutter_gallery_next/biz/home_page.dart';

class Routers {
  static const String tab1 = "tab1";
  static const String tab11 = "tab11";
  static const String tab2 = "tab2";
  static const String tab21 = "tab21";
  static const String tab3 = "tab3";
  static const String tab31 = "tab31";
  static const String home = "home";
  static const String login = "login";
  static const String userInfo = "userInfo";
  static const String placeHolder = "placeHolder";
  static const String unknownPage = "unknownPage";

  // Demo routes
  static const String theme = "theme";
  static const String statusBar = "status bar";
  static const String intl = "intl";
  static const String repaint = "repaint";
  static const String tab = "tab";
  static const String drawer = "drawer";
  static const String parallax = "layout scrolling parallax";
  static const String grid = "grid";
  static const String list = "list";
  static const String anim = "anim";
  static const String dialog = "dialog";
  static const String expandFab = "expand float button";
  static const String eventBus = "event bus";
  static const String net = "net";
  static const String dbFile = "db file";
  static const String dbSp = "db sp";
  static const String proxy = "proxy";
  static const String auth = "auth";
  static const String image = "image";
}

/// Configuration for a demo item to centralize management
class DemoConfig {
  final String route;
  final String title;
  final IconData icon;
  final String category;
  final WidgetBuilder builder;

  const DemoConfig({
    required this.route,
    required this.title,
    required this.icon,
    required this.category,
    required this.builder,
  });
}

class Constant {
  static const String catCore = "Core & Theme";
  static const String catUI = "UI & Layout";
  static const String catLogic = "Interaction & Logic";
  static const String catStorage = "System & Storage";

  /// The master list of all demos. All routes are now managed here.
  static final List<DemoConfig> demoConfigs = [
    // Core & Theme
    DemoConfig(
        route: Routers.theme, title: "Theme", icon: Icons.color_lens, category: catCore, builder: (context) => const DemoTheme()),
    DemoConfig(
        route: Routers.statusBar,
        title: "Status Bar",
        icon: Icons.screenshot,
        category: catCore,
        builder: (context) => const DemoStatusBarColor()),
    DemoConfig(
        route: Routers.intl,
        title: "Internationalization",
        icon: Icons.language,
        category: catCore,
        builder: (context) => const DemoIntl()),

    // UI & Layout
    DemoConfig(
        route: Routers.repaint,
        title: "Repaint Boundary",
        icon: Icons.brush,
        category: catUI,
        builder: (context) => const DemoRepaint()),
    DemoConfig(route: Routers.tab, title: "TabBar", icon: Icons.tab, category: catUI, builder: (context) => const DemoTabBar()),
    DemoConfig(
        route: Routers.drawer, title: "Drawer", icon: Icons.menu_open, category: catUI, builder: (context) => const DemoDrawer()),
    DemoConfig(
        route: Routers.parallax,
        title: "Parallax Scroll",
        icon: Icons.view_day,
        category: catUI,
        builder: (context) => const DemoLayoutScrollParallax()),
    DemoConfig(
        route: Routers.grid, title: "Grid", icon: Icons.grid_view, category: catUI, builder: (context) => const DemoGrid()),
    DemoConfig(route: Routers.list, title: "List", icon: Icons.list, category: catUI, builder: (context) => const DemoList()),

    // Interaction & Logic
    DemoConfig(
        route: Routers.anim,
        title: "Animations",
        icon: Icons.animation,
        category: catLogic,
        builder: (context) => const DemoAnim()),
    DemoConfig(
        route: Routers.dialog,
        title: "Dialogs & Loading",
        icon: Icons.chat_bubble_outline,
        category: catLogic,
        builder: (context) => const DemoDialog()),
    DemoConfig(
        route: Routers.expandFab,
        title: "Expandable FAB",
        icon: Icons.add_circle_outline,
        category: catLogic,
        builder: (context) => const DemoExpandFloatButton()),
    DemoConfig(
        route: Routers.image,
        title: "Image Handling",
        icon: Icons.image_outlined,
        category: catLogic,
        builder: (context) => const DemoImage()),

    // System & Storage
    DemoConfig(
        route: Routers.eventBus,
        title: "Event Bus",
        icon: Icons.multiple_stop,
        category: catStorage,
        builder: (context) => const DemoEventBus()),
    DemoConfig(
        route: Routers.dbFile,
        title: "Database File",
        icon: Icons.description_outlined,
        category: catStorage,
        builder: (context) => DemoDbFile(storage: CounterStorage())),
    DemoConfig(
        route: Routers.dbSp,
        title: "Shared Prefs",
        icon: Icons.save_outlined,
        category: catStorage,
        builder: (context) => const DemoDbSp()),
    DemoConfig(
        route: Routers.proxy,
        title: "Proxy Settings",
        icon: Icons.settings_ethernet,
        category: catStorage,
        builder: (context) => const DemoProxy()),
    DemoConfig(
        route: Routers.auth, title: "Auth", icon: Icons.security, category: catStorage, builder: (context) => const DemoAuth()),
    DemoConfig(
        route: Routers.home, title: "MVVM", icon: Icons.home_outlined, category: catStorage, builder: (context) => HomePage()),
  ];

  /// Automatically generated router map from demoConfigs.
  static Map<String, WidgetBuilder> get router => {
        for (var config in demoConfigs) config.route: config.builder,
      };
}
