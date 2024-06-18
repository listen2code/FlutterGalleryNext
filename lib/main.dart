import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/init.dart';
import 'package:flutter_gallery_next/base/common/pages.dart';
import 'package:flutter_gallery_next/biz/demos/demo_imports.dart';

void main() async {
  await appInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      builder: GlobalLoading.init(),
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
            },
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              child: Text(Constant.router.keys.toList()[index]),
            ),
          );
        },
        itemCount: Constant.router.length,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
