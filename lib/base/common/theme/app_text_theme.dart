import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_styles.dart';
import 'package:flutter_gallery_next/base/common/theme/color/theme_colors.dart';

/// [describe] Text Style
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

  static TextStyle appBarTitleTextStyle({
    FontWeight? fontWeight,
    Color? colors,
    String? fontFamily,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      color: colors ?? ThemeColors.black,
      fontFamily: fontFamily ?? AppFontFamily.numberFont,
      fontSize: fontSize ?? 17,
      height: height ?? 1,
      letterSpacing: letterSpacing ?? 0,
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  static TextStyle getTextStyle({
    required FontWeight fontWeight,
    Color? colors,
    String? fontFamily,
    double? fontSize,
    double? height,
    double? letterSpacing,
  }) {
    return defaultStyle(
      colors: colors,
      fontFamily: fontFamily,
      fontSize: fontSize,
      height: height,
      letterSpacing: letterSpacing,
      fontWeight: fontWeight,
    );
  }

  static TextStyle numberFontW1({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return numberFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w100,
    );
  }

  static TextStyle numberFontW2({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return numberFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w200,
    );
  }

  static TextStyle numberFontW3({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return numberFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle numberFontW4({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return numberFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle numberFontW5({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return numberFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle numberFontW6({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return numberFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle numberFontW7({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return numberFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle numberFontW8({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return numberFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w800,
    );
  }

  static TextStyle numberFontW9({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return numberFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w900,
    );
  }

  static TextStyle numberFont({
    required Color color,
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    double height = 0,
  }) {
    return defaultStyle(
      colors: color,
      fontFamily: AppFontFamily.numberFont,
      fontSize: fontSize,
      height: height,
      fontWeight: fontWeight,
    );
  }

  static TextStyle charactersFontW1({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return charactersFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w100,
    );
  }

  static TextStyle charactersFontW2({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return charactersFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w200,
    );
  }

  static TextStyle charactersFontW3({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return charactersFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w300,
    );
  }

  static TextStyle charactersFontW4({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return charactersFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle charactersFontW5({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return charactersFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle charactersFontW6({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return charactersFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle charactersFontW7({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return charactersFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle charactersFontW8({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return charactersFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w800,
    );
  }

  static TextStyle charactersFontW9({
    required Color color,
    required double fontSize,
    double height = 0,
  }) {
    return charactersFont(
      color: color,
      fontSize: fontSize,
      height: height,
      fontWeight: FontWeight.w900,
    );
  }

  static TextStyle charactersFont({
    required Color color,
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    double height = 0,
  }) {
    return defaultStyle(
      colors: color,
      fontFamily: AppFontFamily.charactersFont,
      fontSize: fontSize,
      height: height,
      fontWeight: fontWeight,
    );
  }

  static TextStyle loginPageStyleW300(
      Color color, double fontSize, double height) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: AppFontFamily.charactersFont,
      fontWeight: FontWeight.w300,
      height: height,
    );
  }

  static TextStyle loginPageStyleW400(
      Color color, double fontSize, double height) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: AppFontFamily.charactersFont,
      fontWeight: FontWeight.w400,
      height: height,
    );
  }

  static TextStyle loginPageStyleW500(
      Color color, double fontSize, double height) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: AppFontFamily.charactersFont,
      fontWeight: FontWeight.w500,
      height: height,
    );
  }

  static TextStyle loginPageStyleW500None(
      Color color, double fontSize, double height) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: AppFontFamily.charactersFont,
      fontWeight: FontWeight.w500,
      height: height,
      decoration: TextDecoration.none,
    );
  }

  static TextStyle loginPageStyleW600(
      Color color, double fontSize, double height) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: AppFontFamily.charactersFont,
      fontWeight: FontWeight.w600,
      height: height,
    );
  }

  static TextStyle loginPageStyleW700(
      Color color, double fontSize, double height) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: AppFontFamily.numberFont,
      fontWeight: FontWeight.w700,
      height: height,
    );
  }

  static TextStyle loginPageStyleW900(
      Color color, double fontSize, double height) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontFamily: AppFontFamily.numberFont,
      fontWeight: FontWeight.w900,
      height: height,
    );
  }
}

class AppTextFieldTheme {
  /// 枠なし
  static OutlineInputBorder noneOutlineInputBorder() {
    return const OutlineInputBorder(
      gapPadding: 0,
      borderSide: BorderSide.none,
    );
  }

  static TextStyle defaultStyle({
    Color? colors,
    String fontFamily = AppFontFamily.numberFont,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w600,
    double letterSpacing = 0,
    double height = 1,
  }) {
    return TextStyle(
      color: colors ?? ThemeColors.grey900,
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: height,
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

  static Decoration onlyRoundedCornersDecoration({
    Color? colors,
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) {
    return BoxDecoration(
      color: colors ?? ThemeColors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      ),
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

  static Padding horizontalLine(
      {double? left, double? top, double? right, double? bottom}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          left ?? 0.0, top ?? 1.0, right ?? 0.0, bottom ?? 13.0),
      child: Container(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignCenter,
              color: ThemeColors.grey200,
            ),
          ),
        ),
      ),
    );
  }
}
