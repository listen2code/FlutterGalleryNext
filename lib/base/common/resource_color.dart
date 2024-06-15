import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/resource.dart';

class AppColor {
  static ThemeType defaultTheme = ThemeType.white;

  static const Map<String, Color> whiteThemeMapping = {
    _colorBackground: Color(0xFFFFFFFF)
  };

  static const Map<String, Color> blackThemeMapping = {
    _colorBackground: Color(0xFF000000)
  };

  static Color colorFFFFFFFF = _showColor(_colorBackground);
  static const String _colorBackground = "_colorBackground";

  static Color _showColor(String key) {
    if (defaultTheme == ThemeType.white) {
      return whiteThemeMapping[key] ?? Colors.white;
    } else if (defaultTheme == ThemeType.black) {
      return blackThemeMapping[key] ?? Colors.black;
    }
    return whiteThemeMapping[key] ?? Colors.white;
  }
}
