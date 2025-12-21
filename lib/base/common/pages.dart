import 'package:flutter/widgets.dart';
import 'package:flutter_gallery_next/biz/demos/demo_imports.dart';
import 'package:flutter_gallery_next/biz/demos/demo_intl.dart';
import 'package:flutter_gallery_next/biz/demos/demo_repaint.dart';
import 'package:flutter_gallery_next/biz/demos/drawer/demo_drawer.dart';
import 'package:flutter_gallery_next/biz/demos/event_bus/demo_event_bus.dart';
import 'package:flutter_gallery_next/biz/demos/tab/demo_tab.dart';
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
}

class Constant {
  static final Map<String, WidgetBuilder> router = {
    "home": (context) {
      return HomePage();
    },
    "demo repaint": (context) {
      return const DemoRepaint();
    },
    "demo intl": (context) {
      return const DemoIntl();
    },
    "demo auth": (context) {
      return const DemoEmpty();
    },
    "demo proxy": (context) {
      return const DemoProxy();
    },
    "demo dialog": (context) {
      return const DemoDialog();
    },
    "status bar": (context) {
      return const DemoStatusBarColor();
    },
    "state": (context) {
      return const DemoState();
    },
    "demo drawer": (context) {
      return const DemoDrawer();
    },
    "demo expand float button": (context) {
      return const DemoExpandFloatButton();
    },
    "layout complex": (context) {
      return const DemoLayoutComplex();
    },
    "layout scrolling parallax": (context) {
      return const DemoLayoutScrollParallax();
    },
    "demo tab": (context) {
      return const DemoTab();
    },
    "demo theme": (context) {
      return const DemoTheme();
    },
    "demo anim": (context) {
      return const DemoAnim();
    },
    "demo button": (context) {
      return const DemoButton();
    },
    "demo db file": (context) {
      return DemoDbFile(storage: CounterStorage());
    },
    "demo db sp": (context) {
      return const DemoDbSp();
    },
    "demo grid": (context) {
      return const DemoGrid();
    },
    "demo list": (context) {
      return const DemoList();
    },
    "demo nav": (context) {
      return const DemoNav();
    },
    "demo net": (context) {
      return const DemoNet();
    },
    "demo text": (context) {
      return const DemoText();
    },
    "demo image": (context) {
      return const DemoImage();
    },
    "demo event bus": (context) {
      return const DemoEventBus();
    },
  };
}
