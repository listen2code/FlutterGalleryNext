import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/demos/anim/demo_anim.dart';
import 'package:flutter_gallery_next/demos/button/demo_button.dart';
import 'package:flutter_gallery_next/demos/db/demo_db_file.dart';
import 'package:flutter_gallery_next/demos/demo_empty.dart';
import 'package:flutter_gallery_next/demos/demo_expand_floatbutton.dart';
import 'package:flutter_gallery_next/demos/demo_form_submit.dart';
import 'package:flutter_gallery_next/demos/demo_proxy.dart';
import 'package:flutter_gallery_next/demos/demo_statusbar_color.dart';
import 'package:flutter_gallery_next/demos/demo_tabs.dart';
import 'package:flutter_gallery_next/demos/demo_theme.dart';
import 'package:flutter_gallery_next/demos/grid/demo_grid.dart';
import 'package:flutter_gallery_next/demos/image/demo_image.dart';
import 'package:flutter_gallery_next/demos/layout/demo_layout_complex.dart';
import 'package:flutter_gallery_next/demos/list/demo_list.dart';
import 'package:flutter_gallery_next/demos/loading/demo_dialog.dart';
import 'package:flutter_gallery_next/demos/loading/global_loading.dart';
import 'package:flutter_gallery_next/demos/nav/demo_nav.dart';
import 'package:flutter_gallery_next/demos/net/demo_net.dart';
import 'package:flutter_gallery_next/demos/text/demo_text.dart';
import 'package:package_base/package_base.dart';
import 'package:plugin_native/plugin_native.dart';

import 'demos/db/demo_db_sp.dart';
import 'demos/drawer/demo_drawer.dart';
import 'demos/drawer/demo_drawer_stagger.dart';
import 'demos/layout/demo_layout_scroll_parallax.dart';
import 'demos/state/demo_state.dart';

void main() async {
  runApp(const MyApp());
  await initDebug();
}

Future<void> initDebug() async {
  debugPrint("getPlatformVersion=${await PluginNative().getPlatformVersion()}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Calculator c = Calculator();
    c.addOne(1);
    return MaterialApp(
      title: 'Listen Flutter Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textButtonTheme: const TextButtonThemeData(
          // 去掉 TextButton 的水波纹效果
          style: ButtonStyle(splashFactory: NoSplash.splashFactory),
        ),
      ),
      home: const MyHomePage(title: 'Listen Flutter Gallery'),
      routes: routers,
      builder: GlobalLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var routeLists = routers.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(routeLists[index]);
            },
            child: Card(
              child: Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                child: Text(routers.keys.toList()[index]),
              ),
            ),
          );
        },
        itemCount: routers.length,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Map<String, WidgetBuilder> routers = {
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
