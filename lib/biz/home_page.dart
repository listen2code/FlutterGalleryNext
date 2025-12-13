import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/widget/base/base_stateless_page.dart';
import 'package:flutter_gallery_next/base/widget/bottom_navi/multi_navigator.dart';
import 'package:get/get.dart';

class HomePage extends BaseStatelessPage {
  final NavigationController navigationController = Get.put(NavigationController());

  HomePage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return Obx(() {
      return IndexedStack(
        index: navigationController.selectedIndex,
        children: navigationController.navigatorPages,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: MediaQuery(
            data: MediaQuery.of(context).removePadding(removeBottom: true),
            child: PopScope(
                canPop: canPop,
                onPopInvokedWithResult: (bool didPop, Object? result) {
                  if (didPop) {
                    return;
                  }
                  onSystemBackPressed(context, didPop);
                },
                child: buildContent(context)),
          ),
        ),
        createBottomNavigation(context)!,
      ],
    );
  }

  @override
  bool get canPop => false;
}
