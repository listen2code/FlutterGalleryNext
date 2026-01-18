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
    "repaint": (context) {
      return const DemoRepaint();
    },
    "intl": (context) {
      return const DemoIntl();
    },
    "theme": (context) {
      return const DemoTheme();
    },
    "auth": (context) {
      return const DemoEmpty();
    },
    "proxy": (context) {
      return const DemoProxy();
    },
    "dialog": (context) {
      return const DemoDialog();
    },
    "status bar": (context) {
      return const DemoStatusBarColor();
    },
    "drawer": (context) {
      return const DemoDrawer();
    },
    "expand float button": (context) {
      return const DemoExpandFloatButton();
    },
    "layout scrolling parallax": (context) {
      return const DemoLayoutScrollParallax();
    },
    "tab": (context) {
      return const DemoTab();
    },
    "anim": (context) {
      return const DemoAnim();
    },
    "button": (context) {
      return const DemoButton();
    },
    "db file": (context) {
      return DemoDbFile(storage: CounterStorage());
    },
    "db sp": (context) {
      return const DemoDbSp();
    },
    "grid": (context) {
      return const DemoGrid();
    },
    "list": (context) {
      return const DemoList();
    },
    "nav": (context) {
      return const DemoNav();
    },
    "net": (context) {
      return const DemoNet();
    },
    "text": (context) {
      return const DemoText();
    },
    "image": (context) {
      return const DemoImage();
    },
    "event bus": (context) {
      return const DemoEventBus();
    },
  };
}
