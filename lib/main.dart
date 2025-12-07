import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/pages.dart';
import 'package:flutter_gallery_next/base/widget/base/global_navigation.dart';
import 'package:flutter_gallery_next/base/widget/dialog/common_loading_widget.dart';
import 'package:flutter_gallery_next/base/widget/dialog/common_toast_widget.dart';
import 'package:flutter_gallery_next/biz/demos/loading/global_loading.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:package_libs/utils/app_links_util.dart';
import 'package:package_libs/utils/function_proxy_util.dart';
import 'package:package_libs/utils/logger_util.dart';

import 'base/common/app_init.dart';

const int mainRouteKey = -1;

void main() async {
  await appInit();
  assert(() {
    FlutterError.onError = (FlutterErrorDetails details) {
      LoggerUtil.error("############# FlutterError ############");
      LoggerUtil.error("\$details");
    };
    return true;
  }());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initAppLinks();
  }

  Future<void> _initAppLinks() async {
    await AppLinksUtil().init();
    AppLinksUtil().uriLinkStream.listen((uri) {
      if (!mounted) return;

      LoggerUtil.log('Received app link: \$uri');
    });
  }

  @override
  void dispose() {
    AppLinksUtil().dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: GlobalNavigation.navigatorKey,
      title: 'Listen Flutter Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textButtonTheme: const TextButtonThemeData(
          // 去掉 TextButton 的水波纹效果
          style: ButtonStyle(splashFactory: NoSplash.splashFactory),
        ),
      ),
      home: const HomePage(),
      routes: Constant.router,
      builder: FlutterSmartDialog.init(
        builder: (context, widget) {
          GlobalLoading.init();
          if (widget != null) {
            return MediaQuery.withNoTextScaling(child: widget);
          }
          throw StateError('widget is null');
        },
        loadingBuilder: (context) => const CommonLoadingWidget(),
        toastBuilder: (msg) => CommonToastWidget(msg: msg),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var routeLists = Constant.router.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("home"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(routeLists[index]);
            }.throttle(),
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              child: Text(Constant.router.keys.toList()[index]),
            ),
          );
        },
        itemCount: Constant.router.length,
      ),
    );
  }
}
