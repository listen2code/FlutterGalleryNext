import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/color/theme_colors.dart';
import 'package:flutter_gallery_next/base/mvvm/view/base_view.dart';
import 'package:flutter_gallery_next/base/mvvm/vm/base_view_model.dart';
import 'package:flutter_gallery_next/base/mvvm/vm/net_state_ext.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

abstract class BaseStatefulPage extends StatefulWidget {
  const BaseStatefulPage({super.key});

  @override
  BaseState createState();
}

abstract class BaseState<VM extends ViewModel, T extends BaseStatefulPage>
    extends State<T> with AutomaticKeepAliveClientMixin<T>, BaseView {
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

  @override
  bool get wantKeepAlive => true;

  bool get canPop => true;

  bool get useStatusBar => false;

  bool get useBottomBar => false;

  Color get statusBarColor => ThemeColors.grey200;

  Color get bottomBarColor => ThemeColors.white;

  Widget buildContent(BuildContext context);

  @override
  void onSystemBackPressed(BuildContext context, bool didPop) {
    back(context: context);
  }

  @override
  void onBackPressed({BuildContext? context}) {
    back(context: context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: pageOnTap,
      child: Scaffold(
        backgroundColor: bgColor(),
        appBar: _createAppBar(context),
        body: SafeArea(
          top: !useStatusBar,
          bottom: !useBottomBar,
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
                      offstage: !useStatusBar, child: createStatusBar(context)),
                  Expanded(child: _buildBody(context)),
                  Offstage(
                      offstage: !useBottomBar, child: createBottomBar(context)),
                ],
              ),
            ),
          ),
        ),
        drawer: _createDrawer(context),
        floatingActionButton: createFloatingActionButton(context),
        bottomNavigationBar: navi ? _createBottomNavigation(context) : null,
      ),
    );
  }

  Widget? createStatusBar(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
        color: statusBarColor,
        height: MediaQuery.of(context).padding.top,
      );
    });
  }

  Widget? createBottomBar(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
        color: bottomBarColor,
        height: MediaQuery.of(context).padding.bottom,
      );
    });
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
                Offstage(
                    offstage: !useStatusBar, child: createStatusBar(context)),
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
