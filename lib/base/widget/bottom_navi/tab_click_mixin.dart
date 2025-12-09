import 'package:flutter/foundation.dart';
import 'package:flutter_gallery_next/base/network/base/base_service.dart';
import 'package:flutter_gallery_next/base/view_model/base_action.dart';
import 'package:flutter_gallery_next/base/view_model/base_view_model.dart';
import 'package:flutter_gallery_next/base/widget/bottom_navi/bottom_navi.dart';
import 'package:flutter_gallery_next/base/widget/bottom_navi/route_ext.dart';
import 'package:get/get_core/src/get_main.dart';

mixin TabClickMixin<Actions extends BaseAction, Service extends BaseService> on ViewModel<Actions, Service> {
  TabClickListener? tabClickListener;

  @override
  void onReady() {
    super.onReady();
    BottomNaviImpl.instance().registerOnTabClickListener(onTabClick);
  }

  @override
  void dispose() {
    BottomNaviImpl.instance().unRegisterOnTabClickListener(onTabClick);
    super.dispose();
  }

  @mustCallSuper
  void onTabClick(int to, bool isTop) {
    if (isFront && Get.currentStackIndex == to) {
      tabClickListener?.call(to, isTop);
    }
  }
}
