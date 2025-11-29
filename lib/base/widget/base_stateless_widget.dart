import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/color/theme_colors.dart';
import 'package:flutter_gallery_next/base/mvvm/view/base_view.dart';
import 'package:flutter_gallery_next/base/mvvm/view_mode/base_view_mode.dart';
import 'package:flutter_gallery_next/base/mvvm/view_mode/net_state_ext.dart';
import 'package:flutter_gallery_next/base/widget/dialog/design_dialog.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

abstract class BaseStatelessPage<VM extends ViewMode> extends StatelessWidget
    with BaseView, DesignDialog {
  const BaseStatelessPage({super.key});

  @protected
  VM get viewMode => Get.find<VM>();

  @protected
  String titleString() => "";

  @protected
  Widget? titleWidget() => null;

  @protected
  bool isCenterTitle() => false;

  @protected
  bool isFullScreenLoad() => false;

  @protected
  bool get navi => false;

  Widget buildContent(BuildContext context);

  @override
  void onSystemBackPressed(BuildContext context, bool didPop) {
    back(context: context);
  }

  @override
  void onBackPressed({BuildContext? context}) {
    back(context: context);
  }

  bool get canPop => true;

  bool get useStatusBar => false;

  bool get useBottomArea => false;

  bool get useNoticeArea => false;

  Color get statusBarColor => ThemeColors.grey200;

  Color get bottomAreaColor => ThemeColors.white;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: pageOnTap,
      child: Scaffold(
        backgroundColor: bgColor(),
        appBar: _createAppBar(context),
        body: SafeArea(
          top: !useStatusBar,
          bottom: !useBottomArea,
          child: PopScope(
              canPop: canPop,
              onPopInvokedWithResult: (bool didPop, Object? result) {
                if (didPop) {
                  return;
                }
                onSystemBackPressed(context, didPop);
              },
              child: VisibilityDetector(
                  onVisibilityChanged: (info) {
                    // todo && viewMode is! HomeViewMode
                    if (context.mounted && Get.isRegistered<VM>()) {
                      if (info.visibleFraction == 1) {
                        viewMode.onStackResume(context);
                      } else if (info.visibleFraction == 0) {
                        viewMode.onStackPause(context);
                      }
                    }
                  },
                  key: Key(hashCode.toString()),
                  child: Column(
                    children: [
                      Offstage(
                          offstage: !useStatusBar, child: statusBarWidget()),
                      Offstage(
                          offstage: !useNoticeArea, child: noticeAreaWidget()),
                      Expanded(child: _buildBody(context)),
                      Offstage(
                          offstage: !useBottomArea, child: bottomAreaWidget()),
                    ],
                  ))),
        ),
        drawer: _createDrawer(context),
        floatingActionButton: createFloatingActionButton(context),
        bottomNavigationBar: navi ? _createBottomNavigation(context) : null,
      ),
    );
  }

  Widget statusBarWidget() {
    return Builder(builder: (context) {
      return Container(
        color: statusBarColor,
        height: MediaQuery.of(context).padding.top,
      );
    });
  }

  Widget bottomAreaWidget() {
    return Builder(builder: (context) {
      return Container(
        color: bottomAreaColor,
        height: MediaQuery.of(context).padding.bottom,
      );
    });
  }

  Widget noticeAreaWidget() {
    return const SizedBox.shrink();
  }

  Widget? createFloatingActionButton(BuildContext context) => null;

  void pageOnTap() {
    closeKeyword();
  }

  void closeKeyword() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  PreferredSizeWidget? _createAppBar(BuildContext context) {
    AppBar? appBar = createAppBar(titleString(), isCenterTitle(),
        backButton: backButton(),
        actionWidget: appBarActionWidget(context),
        customTitleWidget: titleWidget());
    return appBar == null
        ? appBar
        : PreferredSize(
            preferredSize: Size.fromHeight(toolbarHeight ?? kToolbarHeight),
            child: Stack(
              children: [
                appBar,
                Offstage(offstage: !useStatusBar, child: statusBarWidget()),
              ],
            ),
          );
  }

  Widget? _createDrawer(context) {
    return createDrawer(context);
  }

  Widget _buildBody(BuildContext context) {
    if (isFullScreenLoad()) {
      return viewMode.observe((state) => buildContent(context));
    } else {
      return buildContent(context);
    }
  }

  Widget? _createBottomNavigation(context) {
    return createBottomNavigation(context);
  }
}
