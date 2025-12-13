import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gallery_next/base/common/theme/app_resource.dart';
import 'package:flutter_gallery_next/base/widget/bottom_navi/bottom_navi.dart';
import 'package:flutter_gallery_next/base/widget/bottom_navi/multi_navigator.dart';
import 'package:get/get.dart';

bool isFullScreen = false;

// todo
mixin BaseView {
  SystemUiOverlayStyle systemOverLayoutStyle() {
    return SystemUiOverlayStyle.dark;
  }

  AppBar? createAppBar(
    String titleString,
    bool centerTitle, {
    Widget? backButton,
    List<Widget>? actionWidget,
    Widget? customTitleWidget,
  }) {
    return AppBar(
      backgroundColor: ThemeColors.white,
      title: customTitleWidget ?? titleView(titleString),
      centerTitle: centerTitle,
      scrolledUnderElevation: 0,
      elevation: 0,
      systemOverlayStyle: systemOverLayoutStyle(),
      leading: backButton,
      leadingWidth: leadingWidth,
      automaticallyImplyLeading: backButton != null,
      toolbarHeight: toolbarHeight,
      bottom: createAppBarBottomView(),
      actions: actionWidget,
    );
  }

  Widget? backButton({Widget? icon}) {
    return Builder(builder: (context) {
      return IconButton(
        icon: icon ?? const Icon(Icons.arrow_back_ios_new),
        onPressed: () => onBackPressed(context: context),
      );
    });
  }

  double? get leadingWidth {
    return 56;
  }

  double? get toolbarHeight {
    return 64;
  }

  PreferredSizeWidget? createAppBarBottomView() {
    return null;
  }

  void onBackPressed({BuildContext? context}) {
    back(context: context);
  }

  void onSystemBackPressed(BuildContext context, bool didPop) {
    back(context: context);
  }

  Widget? createDrawer(BuildContext context) => null;

  List<Widget>? appBarActionWidget(BuildContext context) => null;

  Widget? titleView(String titleString) {
    return Text(titleString,
        textAlign: TextAlign.center,
        style: AppTextTheme.defaultStyle(
          fontFamily: AppFontFamily.characters,
          fontWeight: FontWeight.w600,
          fontSize: AppFontSize.base,
        ));
  }

  /// 背景色設定
  Color bgColor() {
    return ThemeColors.white;
  }

  // todo BottomNaviImpl
  Widget? createBottomNavigation(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: const BoxDecoration(border: Border(top: BorderSide(width: 1, color: Color(0xFFF0F2F3)))),
        child: BottomNavigationBar(
          items: List.generate(BottomNaviImpl.instance().tabs.length, (index) {
            return BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(bottom: 3),
                child: Image(
                  image: AssetImage(BottomNaviImpl.instance().tabs.elementAt(index).iconPath),
                  width: 24,
                  height: 24,
                ),
              ),
              activeIcon: Container(
                  margin: const EdgeInsets.only(bottom: 3),
                  child: Image(
                      image: AssetImage(BottomNaviImpl.instance().tabs.elementAt(index).activeIconPath), width: 24, height: 24)),
              label: BottomNaviImpl.instance().tabs.elementAt(index).label,
            );
          }),
          currentIndex: Get.find<NavigationController>().selectedIndex,
          onTap: (to) {
            BottomNaviImpl.instance().gotoOtherTab(to);
          },
          selectedFontSize: 10,
          unselectedFontSize: 10,
          selectedItemColor: ThemeColors.red800,
          unselectedItemColor: ThemeColors.grey1000,
          selectedLabelStyle: AppTextTheme.defaultStyle(
            fontWeight: FontWeight.w300,
          ),
          unselectedLabelStyle: AppTextTheme.defaultStyle(
            fontWeight: FontWeight.w300,
          ),
          backgroundColor: ThemeColors.white,
          type: BottomNavigationBarType.fixed,
        ),
      );
    });
  }

  void back<T>({T? result, BuildContext? context}) {
    pageBack(result: result, context: context);
  }

  void backFullScreen<T>({T? result, BuildContext? context}) {
    fullScreenPageBack(result: result, context: context);
  }

  Widget? createLoadingWidget() => null;
}

// todo
void pageBack<T>({T? result, BuildContext? context}) {
  // if (isFullScreen && routeHistoryObserver.history.length > 1) {
  //   // 全画面ページ
  //   fullScreenPageBack(result: result, context: context);
  //   return;
  // }
  // var canPop = Get.currentNaviState?.canPop();
  // if (canPop != null && canPop) {
  //   Get.back(id: Get.currentStackIndex, result: result);
  //   Get.find<NavigationController>().tryRestoreStackPosition();
  // } else {
  //   if (Get.currentStackIndex == 0) {
  //     SystemNavigator.pop();
  //   } else {
  //     Get.find<NavigationController>().remove(Get.currentStackIndex);
  //   }
  // }
  Navigator.of(context!).pop(result);
}

void fullScreenPageBack<T>({T? result, BuildContext? context}) {
  Get.back(result: result);
}
