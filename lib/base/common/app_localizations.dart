import 'dart:ui';

class AppLocalizations {
  static const hello = "hello";
  static const appName = "appName";

  static Locale defaultSupportedLocale = jpSupportedLocale;
  static Locale jpSupportedLocale = const Locale('jp', '');
  static Locale enSupportedLocale = const Locale('en', '');

  static List<Locale> supportedLocales = [
    jpSupportedLocale,
    enSupportedLocale,
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'hello': 'Hello',
      'appName': 'ListenFlutterGallery',
    },
    'jp': {
      'hello': 'こんにちは',
      'appName': 'Listen Flutter ギャラリー',
    },
  };

  static String? of(String key) {
    return _localizedValues[defaultSupportedLocale.languageCode]?[key];
  }
}

extension IntlExtension on String {
  String get tr {
    return AppLocalizations.of(this) ?? this;
  }
}
