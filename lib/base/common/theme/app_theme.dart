import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/color/base_theme_colors.dart';
import 'package:flutter_gallery_next/base/common/theme/color/black_theme_colors.dart';
import 'package:flutter_gallery_next/base/common/theme/color/white_theme_colors.dart';

enum AppThemes {
  light,
  dark,
}

class AppTheme {
  final BaseThemeColors appColors;

  const AppTheme(this.appColors);

  static AppTheme of(AppThemes theme) {
    switch (theme) {
      case AppThemes.light:
        return AppTheme(const WhiteThemeColors());
      case AppThemes.dark:
        return AppTheme(const BlackThemeColors());
    }
  }

  ThemeData get themeData {
    return ThemeData(
      // Use ColorScheme for modern Flutter themes
      colorScheme: ColorScheme.fromSeed(
        seedColor: appColors.blue500,
        // Use a base color to generate a palette
        primary: appColors.blue500,
        secondary: appColors.green500,
        background: appColors.white,
        surface: appColors.grey100,
        onPrimary: appColors.white,
        onSecondary: appColors.white,
        onBackground: appColors.black,
        onSurface: appColors.black,
        error: appColors.red500,
        onError: appColors.white,
      ),

      // Define other theme properties
      scaffoldBackgroundColor: appColors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: appColors.blue600,
        foregroundColor: appColors.white,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: appColors.black),
        titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color: appColors.black),
        bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind', color: appColors.grey900),
      ),
    );
  }
}
