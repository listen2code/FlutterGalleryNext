import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/translations/en_us_translations.dart';
import 'package:flutter_gallery_next/base/common/translations/ja_jp_translations.dart';

// The class that holds the localized strings.
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to access the localizations object from any widget
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Static member to have a simple access to the delegate from MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, String> _localizedStrings;

  Future<bool> load() {
    // All supported translations
    Map<String, Map<String, String>> _allTranslations = {
      'en': en,
      'ja': jp,
    };
    // Load the translations for the current language code
    _localizedStrings = _allTranslations[locale.languageCode]!;
    return Future.value(true);
  }

  // Translates a key into the localized string.
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  // Keep string constants for type safety
  static const String applicationName = "applicationName";
  static const String hello = "hello";
  static const String btnOkName = "btnOkName";
  static const String backBtnName = "backBtnName";
  static const String btnCancelName = "btnCancelName";

  static Locale getJpaLocale() {
    return const Locale('ja', 'JP');
  }

  static Locale getEnLocale() {
    return const Locale('en', 'US');
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ja'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => true;
}
