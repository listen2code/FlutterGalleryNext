import 'package:flutter/material.dart';

class AppTextTheme {
  static TextStyle defaultStyle({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
      color: color ?? Colors.black,
      fontSize: fontSize ?? 12,
      fontWeight: fontWeight ?? FontWeight.normal,
    );
  }
}

class AppTextFieldTheme {
  static OutlineInputBorder nonOutlineInputBorder() {
    return const OutlineInputBorder(
      gapPadding: 0,
      borderSide: BorderSide.none,
    );
  }

  static InputDecoration noneInputDecoration({
    String? hintText,
    TextStyle? hintStyle,
  }) {
    return InputDecoration(
      isCollapsed: true,
      hintText: hintText,
      hintStyle: hintStyle,
      border: nonOutlineInputBorder(),
      focusedBorder: nonOutlineInputBorder(),
      focusedErrorBorder: nonOutlineInputBorder(),
      enabledBorder: nonOutlineInputBorder(),
      disabledBorder: nonOutlineInputBorder(),
      errorBorder: nonOutlineInputBorder(),
    );
  }
}

class AppContainerTheme {
  static Decoration defaultDecoration(Color? color, double radius) {
    return ShapeDecoration(
      color: color ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
