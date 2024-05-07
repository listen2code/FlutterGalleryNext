import 'package:flutter/material.dart';
import 'package:flutter_base/flutter_base.dart';
import 'package:flutter_gallery_next/demos/anim/demo_anim_opacity.dart';
import 'package:flutter_gallery_next/demos/anim/demo_anim_physics_drag.dart';
import 'package:flutter_gallery_next/demos/anim/demo_anim_random.dart';
import 'package:flutter_gallery_next/demos/anim/demo_anim_transition.dart';
import 'package:flutter_gallery_next/demos/button/demo_button_common.dart';
import 'package:flutter_gallery_next/demos/button/demo_button_inkwell.dart';
import 'package:flutter_gallery_next/demos/button/demo_button_ontap.dart';
import 'package:flutter_gallery_next/demos/db/demo_db_file.dart';
import 'package:flutter_gallery_next/demos/demo_expand_floatbutton.dart';
import 'package:flutter_gallery_next/demos/demo_form_submit.dart';
import 'package:flutter_gallery_next/demos/demo_statusbar_color.dart';
import 'package:flutter_gallery_next/demos/grid/demo_grid_basic.dart';
import 'package:flutter_gallery_next/demos/image/demo_image_cache.dart';
import 'package:flutter_gallery_next/demos/image/demo_image_network.dart';
import 'package:flutter_gallery_next/demos/layout/demo_layout_complex.dart';
import 'package:flutter_gallery_next/demos/demo_tabs.dart';
import 'package:flutter_gallery_next/demos/demo_theme.dart';
import 'package:flutter_gallery_next/demos/list/demo_list_basic.dart';
import 'package:flutter_gallery_next/demos/list/demo_list_dismiss.dart';
import 'package:flutter_gallery_next/demos/list/demo_list_horizontal.dart';
import 'package:flutter_gallery_next/demos/list/demo_list_long.dart';
import 'package:flutter_gallery_next/demos/list/demo_list_refresh.dart';
import 'package:flutter_gallery_next/demos/list/demo_list_silver_bar.dart';
import 'package:flutter_gallery_next/demos/list/demo_list_silver_header.dart';
import 'package:flutter_gallery_next/demos/loading/demo_dialog.dart';
import 'package:flutter_gallery_next/demos/loading/demo_dialog_stateless.dart';
import 'package:flutter_gallery_next/demos/loading/global_loading.dart';
import 'package:flutter_gallery_next/demos/nav/demo_nav_hero.dart';
import 'package:flutter_gallery_next/demos/net/demo_net_async.dart';
import 'package:flutter_gallery_next/demos/net/demo_net_basic.dart';
import 'package:flutter_gallery_next/demos/net/demo_net_complex_add.dart';
import 'package:flutter_gallery_next/demos/net/demo_net_complex_del.dart';
import 'package:flutter_gallery_next/demos/net/demo_net_complex_update.dart';
import 'package:flutter_gallery_next/demos/page_route/page_1.dart';
import 'package:flutter_gallery_next/demos/text/demo_text_fetch.dart';
import 'package:flutter_gallery_next/demos/text/demo_text_focus.dart';
import 'package:flutter_gallery_next/demos/text/demo_text_tag.dart';

import 'demos/button/demo_button_download.dart';
import 'demos/db/demo_db_sp.dart';
import 'demos/drawer/demo_drawer.dart';
import 'demos/drawer/demo_drawer_stagger.dart';
import 'demos/grid/demo_grid_orientation.dart';
import 'demos/image/demo_image_radius.dart';
import 'demos/layout/demo_layout_scroll_parallax.dart';
import 'demos/list/demo_list_multi.dart';
import 'demos/nav/demo_nav_complex.dart';
import 'demos/nav/demo_nav_name.dart';
import 'demos/nav/demo_nav_param.dart';
import 'demos/nav/demo_nav_push_pop.dart';
import 'demos/nav/demo_nav_selection.dart';
import 'demos/nav/demo_nav_todos.dart';
import 'demos/state/demo_state.dart';
import 'demos/text/demo_text_basic.dart';
import 'demos/text/demo_text_bubble.dart';


void main() {
  runApp(const MyApp());
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
  "demo dialog": (context) {
    return const DemoDialog();
  },
  "demo dialog stateless": (context) {
    return DemoDialogStateless();
  },
  "page route": (context) {
    return const DemoPageRoute();
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
  "expand float button": (context) {
    return const DemoExpandFloatButton();
  },
  "form submit": (context) {
    return const DemoFormSubmit();
  },
  "layout complex": (context) {
    return const DemoLayoutComplex();
  },
  "scrolling parallax": (context) {
    return const DemoLayoutScrollParallax();
  },
  "tabs": (context) {
    return const DemoTabs();
  },
  "theme": (context) {
    return const DemoTheme();
  },
  "anim opacity": (context) {
    return const DemoAnimOpacity();
  },
  "anim physics drag": (context) {
    return const DemoAnimPhysicsDrag();
  },
  "anim random": (context) {
    return const DemoAnimRandom();
  },
  "anim transition": (context) {
    return DemoAnimTransition();
  },
  "button inkwell": (context) {
    return const DemoButtonInkWell();
  },
  "button onTap": (context) {
    return const DemoButtonOnTap();
  },
  "button download": (context) {
    return const DemoButtonDownload();
  },
  "button common": (context) {
    return const DemoButtonCommon();
  },
  "db file": (context) {
    return DemoDbFile(storage: CounterStorage());
  },
  "db sp": (context) {
    return const DemoDbSp();
  },
  "grid basic": (context) {
    return const DemoGridBasic();
  },
  "grid orientation": (context) {
    return const DemoGridOrientation();
  },
  "list basic": (context) {
    return const DemoListBasic();
  },
  "list dismiss": (context) {
    return const DemoListDismiss();
  },
  "list horizontal": (context) {
    return const DemoListHorizontal();
  },
  "list long": (context) {
    return DemoListLong(items: List<String>.generate(10000, (i) => 'Item $i'));
  },
  "list multi": (context) {
    return DemoListMulti(
      items: List<ListItem>.generate(
        1000,
            (i) => i % 6 == 0
            ? HeadingItem('Heading $i')
            : MessageItem('Sender $i', 'Message body $i'),
      ),
    );
  },
  "list silver bar": (context) {
    return const DemoListSilverBar();
  },
  "list fix header": (context) {
    return const DemoListFixHeader();
  },
  "list refresh": (context) {
    return const DemoListRefresh();
  },
  "nav complex": (context) {
    return const DemoNavComplex();
  },
  "nav hero": (context) {
    return const DemoNavHero();
  },
  "nav name": (context) {
    return const DemoNavName();
  },
  "nav param": (context) {
    return const DemoNavParam();
  },
  "nav push pop": (context) {
    return const DemoNavPushPop();
  },
  "nav selection": (context) {
    return const DemoNavSelection();
  },
  "nav todos": (context) {
    return const DemoNavTodos();
  },
  "net async": (context) {
    return const DemoNetAsync();
  },
  "net basic": (context) {
    return const DemoNetBasic();
  },
  "net complex add": (context) {
    return const DemoNetComplexAdd();
  },
  "net complex del": (context) {
    return const DemoNetComplexDel();
  },
  "net complex update": (context) {
    return const DemoNetComplexUpdate();
  },
  "text basic": (context) {
    return const DemoTextBasic();
  },
  "text fetch": (context) {
    return const DemoTextFetch();
  },
  "text focus": (context) {
    return const DemoTextFocus();
  },
  "text bubble": (context) {
    return DemoTextBubble();
  },
  "text tag": (context) {
    return DemoTextTag();
  },
  "image net": (context) {
    return const DemoImageNetwork();
  },
  "image cache": (context) {
    return const DemoImageCache();
  },
  "image radius": (context) {
    return const DemoImageRadius();
  },
};