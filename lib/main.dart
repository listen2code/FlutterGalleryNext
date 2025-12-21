import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/pages.dart';
import 'package:flutter_gallery_next/base/widget/base/global_navigation.dart';
import 'package:flutter_gallery_next/base/widget/dialog/common_dialog.dart';
import 'package:flutter_gallery_next/base/widget/dialog/common_loading_widget.dart';
import 'package:flutter_gallery_next/base/widget/dialog/common_toast_widget.dart';
import 'package:flutter_gallery_next/biz/demos/bottom_navi/tab1.dart';
import 'package:flutter_gallery_next/biz/demos/bottom_navi/tab2.dart';
import 'package:flutter_gallery_next/biz/demos/bottom_navi/tab3.dart';
import 'package:flutter_gallery_next/biz/demos/demo_empty.dart';
import 'package:flutter_gallery_next/biz/demos/loading/global_loading.dart';
import 'package:flutter_gallery_next/biz/login/view/login_page.dart';
import 'package:flutter_gallery_next/biz/user_info/view/user_info_page.dart';
import 'package:flutter_gallery_next/splash.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
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
        GetPage(name: '/${Routers.tab1}', page: () => Tab1()),
        GetPage(name: '/${Routers.tab11}', page: () => DemoEmpty(title: Routers.tab11)),
        GetPage(name: '/${Routers.tab2}', page: () => Tab2()),
        GetPage(name: '/${Routers.tab21}', page: () => DemoEmpty(title: Routers.tab21)),
        GetPage(name: '/${Routers.tab3}', page: () => Tab3()),
        GetPage(name: '/${Routers.tab31}', page: () => DemoEmpty(title: Routers.tab31)),
        GetPage(name: '/${Routers.placeHolder}', page: () => DemoEmpty(title: Routers.placeHolder)),
        GetPage(name: '/${Routers.login}', page: () => LoginPage()),
        GetPage(name: '/${Routers.userInfo}', page: () => UserInfoPage()),
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
