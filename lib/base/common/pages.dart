import 'package:flutter/widgets.dart';
import 'package:flutter_gallery_next/biz/demos/demo_imports.dart';
import 'package:flutter_gallery_next/biz/demos/demo_intl.dart';

class Constant {
  static final Map<String, WidgetBuilder> router = {
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
    "drawer": (context) {
      return const DemoDrawer();
    },
    "drawer stagger": (context) {
      return const DemoDrawerStagger();
    },
    "demo expand float button": (context) {
      return const DemoExpandFloatButton();
    },
    "form submit": (context) {
      return const DemoFormSubmit();
    },
    "layout complex": (context) {
      return const DemoLayoutComplex();
    },
    "layout scrolling parallax": (context) {
      return const DemoLayoutScrollParallax();
    },
    "demo tabs": (context) {
      return const DemoTabs();
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
  };
}
