import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/pages.dart';
import 'package:flutter_gallery_next/base/widget/base/global_navigation.dart';
import 'package:flutter_gallery_next/base/widget/dialog/common_dialog.dart';
import 'package:flutter_gallery_next/base/widget/dialog/common_loading_widget.dart';
import 'package:flutter_gallery_next/base/widget/dialog/common_toast_widget.dart';
import 'package:flutter_gallery_next/biz/demos/demo_empty.dart';
import 'package:flutter_gallery_next/biz/demos/loading/global_loading.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:package_base/function_proxy_util.dart';
import 'package:package_libs/utils/app_links_util.dart';
import 'package:package_libs/utils/connectivity_util.dart';
import 'package:package_libs/utils/logger_util.dart';

import 'base/common/app_init.dart';

const int mainRouteKey = -1;

void main() async {
  await appInit();
  assert(() {
    FlutterError.onError = (FlutterErrorDetails details) {
      LoggerUtil.error("############# FlutterError ############");
      LoggerUtil.error("$details");
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
    ConnectivityUtil.instance().onConnectivityChanged.listen((status) {
      GlobalDialog.showToast('onConnectivityChanged: $status');
    });
  }

  Future<void> _initAppLinks() async {
    await AppLinksUtil().init();
    AppLinksUtil().uriLinkStream.listen((uri) {
      if (!mounted) return;
      GlobalDialog.showToast('Received app link: $uri');
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
    return GetMaterialApp(
      navigatorKey: GlobalNavigation.navigatorKey,
      title: 'Listen Flutter Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(splashFactory: NoSplash.splashFactory),
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/tab1', page: () => DemoEmpty()),
        GetPage(name: '/tab2', page: () => DemoEmpty()),
        GetPage(name: '/tab3', page: () => DemoEmpty()),
        GetPage(name: '/placeHolder', page: () => DemoEmpty()),
      ],
      home: const SplashPage(),
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

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("splash"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(Constant.router.keys.toList()[index]);
            }.throttle(milliseconds: 2000),
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
