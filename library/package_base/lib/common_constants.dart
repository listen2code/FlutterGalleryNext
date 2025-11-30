import 'dart:io';

class CommonSymbols {
  CommonSymbols._private();

  static const String zero = '0';
  static const String one = '1';
  static const String empty = '';
  static const String halfSpace = ' ';
  static const String fullSpace = '　';
  static const String dot = '.';
  static const String comma = ',';
  static const String backTick = '`';
  static const String colon = ':';
  static const String equal = '=';
  static const String plus = '+';
  static const String minus = '-';
  static const String dash = 'ー';
  static const String percent = '%';
  static const String question = '?';
  static const String ampersand = '&';
  static const String hash = '#';
  static const String tilde = '~';
  static const String slash = '/';
  static const String maskSign = '•';
  static const String bracketsLeft = '(';
  static const String bracketsRight = ')';
}

class LineSeparators {
  LineSeparators._private();

  static const String unix = '\n';
  static const String windows = '\r\n';
  static const String oldMac = '\r';
}

class DisplayFormats {
  DisplayFormats._private();

  static const String currencyFormat = '0.00';
  static const String slashDateFormat = 'yyyy/MM/dd';
  static const String hyphenDateFormat = 'yyyy-MM-dd';
  static const String dateTimeMilliFormat = 'yyyy-MM-dd HH:mm:ss.SSS';
  static const String slashDateTime = 'yyyy/MM/dd HH:mm';
  static const String jpDateDowTime = 'yyyy年MM月dd日 (E) HH:mm';
  static const String jpDateMonthTime = 'MM/dd HH:mm';
  static const String dateTimeFormat = 'yyyyMMddHHmmss';
  static const String jpYearMonthDay = 'yyyy年M月d日';
  static const String assetsTrendMonth = 'M';
  static const String assetsTrendYear = 'Y';
  static const String yearMonthDay = 'yyyy/MM/dd';
  static const String monthDay = 'MM/dd';
  static const String timeMinute = 'HH:mm';
  static const String jpDateYearMonthTime = 'yy/MM/dd HH:mm';
}

class AppStoreAddress {
  AppStoreAddress._private();

  static get appStore => Platform.isAndroid ? _android : _ios;

  static const String _android = "https://play.google.com/store/apps/details?id=";
  static const String _ios = "https://apps.apple.com/jp/app/";
}
