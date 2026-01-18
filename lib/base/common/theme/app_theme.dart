import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/color/base_theme_colors.dart';
import 'package:flutter_gallery_next/base/common/theme/color/black_theme_colors.dart';
import 'package:flutter_gallery_next/base/common/theme/color/white_theme_colors.dart';

class AppTheme {
  final BaseThemeColors appColors;

  const AppTheme(this.appColors);

  /// Helper to get the full color set based on the current context's theme.
  static BaseThemeColors colors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const BlackThemeColors() : const WhiteThemeColors();
  }

  static AppTheme fromMode(ThemeMode mode) {
    if (mode == ThemeMode.dark) {
      return const AppTheme(BlackThemeColors());
    }
    return const AppTheme(WhiteThemeColors());
  }

  ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      brightness: appColors.brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: appColors.blue500,
        brightness: appColors.brightness,
        primary: appColors.blue500,
        onPrimary: appColors.foreground,
        secondary: appColors.green500,
        onSecondary: appColors.foreground,
        error: appColors.red500,
        onError: appColors.foreground,
        surface: appColors.background,
        onSurface: appColors.foreground,
      ),
      scaffoldBackgroundColor: appColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: appColors.blue600,
        foregroundColor: appColors.foreground,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: appColors.blue500,
        foregroundColor: appColors.foreground,
      ),
    );
  }
}
