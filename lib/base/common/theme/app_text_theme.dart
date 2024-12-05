import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_styles.dart';
import 'package:flutter_gallery_next/base/common/theme/color/theme_colors.dart';

class AppTextTheme {
  static TextStyle defaultStyle({
    Color? colors,
    String? fontFamily,
    double? fontSize,
    double? height,
    double? letterSpacing,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
      color: colors ?? ThemeColors.black,
      fontFamily: fontFamily ?? AppFontFamily.numberFont,
      fontSize: fontSize ?? 12,
      height: height ?? 1,
      letterSpacing: letterSpacing ?? 0,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }
}

class AppTextFieldTheme {
  static OutlineInputBorder noneOutlineInputBorder() {
    return const OutlineInputBorder(
      gapPadding: 0,
      borderSide: BorderSide.none,
    );
  }

  static InputDecoration decorationBorderless({
    String? hintText,
    TextStyle? hintStyle,
  }) {
    return InputDecoration(
      isCollapsed: true,
      hintText: hintText,
      hintStyle: hintStyle,
      border: noneOutlineInputBorder(),
      focusedBorder: noneOutlineInputBorder(),
      focusedErrorBorder: noneOutlineInputBorder(),
      enabledBorder: noneOutlineInputBorder(),
      disabledBorder: noneOutlineInputBorder(),
      errorBorder: noneOutlineInputBorder(),
    );
  }
}

class AppContainerTheme {
  static BoxDecoration bottomLineBoxDecoration({
    double width = 1,
    Color? colors,
    Color? backgroundColor,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? ThemeColors.white,
      border: Border(
        bottom: BorderSide(
          width: width,
          color: colors ?? ThemeColors.grey200,
        ),
      ),
    );
  }

  static List<BoxShadow> defaultShadows() {
    return [
      const BoxShadow(
        color: Color(0x19000000),
        blurRadius: 5,
        offset: Offset(0, 1),
        spreadRadius: 0,
      ),
      const BoxShadow(
        color: Color(0x05000000),
        blurRadius: 4,
        offset: Offset(0, 3),
        spreadRadius: 0,
      ),
      const BoxShadow(
        color: Color(0x0A000000),
        blurRadius: 4,
        offset: Offset(0, 2),
        spreadRadius: 0,
      )
    ];
  }

  static Decoration defaultDecoration({
    Color? colors,
    double radius = 4,
    List<BoxShadow>? shadows,
  }) {
    return ShapeDecoration(
      color: colors ?? ThemeColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      shadows: shadows ?? defaultShadows(),
    );
  }

  static Decoration allRoundedCornersDecoration({
    Color? colors,
    double radius = 4,
  }) {
    return BoxDecoration(
      color: colors ?? ThemeColors.white,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static Decoration roundedRectangleDecoration({
    Color? colors,
    double borderWidth = 1.0,
    Color? borderColor,
    double radius = 4.0,
  }) {
    return ShapeDecoration(
      color: colors ?? ThemeColors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: borderWidth,
          color: borderColor ?? const Color(0xFF8E8E8E),
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
