import 'package:flutter/widgets.dart';
import 'package:flutter_gallery_next/base/common/translations/en_us_translations.dart';
import 'package:flutter_gallery_next/base/common/translations/ja_jp_translations.dart';
import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        "ja_JP": jp,
        "en_US": en,
      };
}

class AppLocalizations {
  static const String applicationName = "applicationName";

  static const String hello = "hello";
  static const String btnOkName = "btnOkName";
  static const String backBtnName = "backBtnName";
  static const String btnCancelName = "btnCancelName";

  static Locale getLocale() {
    var locale = Get.deviceLocale;
    locale ??= getJpaLocale();
    return locale;
  }

  static void change({Locale? changeLocale}) {
    var locale = changeLocale ?? getLocale();
    Get.updateLocale(locale);
  }

  static Locale getJpaLocale() {
    return const Locale('ja', 'JP');
  }

  static Locale getEnLocale() {
    return const Locale('en', 'US');
  }
}
