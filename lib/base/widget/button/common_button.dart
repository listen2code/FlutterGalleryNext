import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_styles.dart';
import 'package:flutter_gallery_next/base/widget/text/common_text.dart';

class CommonButton extends StatelessWidget {
  final String text;

  final VoidCallback? onPressed;

  final ButtonOptions? options;

  final ButtonOptions defaultOptions = ButtonOptions();

  CommonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.options,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: options?.width,
      height: options?.height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: createTButtonStyle(),
        child: createDesignText(),
      ),
    );
  }

  CommonText createDesignText() {
    return CommonText(
      text,
      style: TextStyle(
        color: options?.fontColor ?? defaultOptions.fontColor,
        fontSize: options?.fontSize ?? defaultOptions.fontSize,
        height: options?.fontHeight ?? defaultOptions.fontHeight,
        fontFamily: options?.fontFamily ?? defaultOptions.fontFamily,
        fontWeight: options?.fontWeight ?? defaultOptions.fontWeight,
      ),
    );
  }

  ButtonStyle createTButtonStyle() {
    return ButtonStyle(
      elevation: WidgetStateProperty.all<double>(options?.elevation ?? defaultOptions.elevation),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        options?.padding ?? defaultOptions.padding,
      ),
      backgroundColor: WidgetStateProperty.all<Color>(options?.color ?? defaultOptions.color),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: options?.borderRadius ?? defaultOptions.borderRadius,
        ),
      ),
      side: WidgetStateProperty.all<BorderSide>(
        BorderSide(
          color: options?.borderColor ?? defaultOptions.borderColor,
          width: options?.borderWidth ?? defaultOptions.borderWidth,
        ),
      ),
    );
  }
}

class IconCommonButton extends CommonButton {
  IconCommonButton({
    super.key,
    required super.text,
    super.onPressed,
    super.options,
    this.icon,
  });

  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: options?.width,
      height: options?.height,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: createTButtonStyle(),
        label: createDesignText(),
        icon: icon,
      ),
    );
  }
}

/// [describe] ボタンのスタイル
class ButtonOptions {
  late final double? width;

  late final double? height;

  late final Color color;

  late final EdgeInsets padding;

  late final double elevation;

  late final Color fontColor;

  late final double fontSize;

  late final double fontHeight;

  late final String fontFamily;

  late final FontWeight fontWeight;

  late final Color borderColor;

  late final double borderWidth;

  late final BorderRadius borderRadius;

  ButtonOptions(
      {this.width,
      this.height,
      this.color = Colors.white70,
      this.fontColor = Colors.black,
      this.borderColor = Colors.transparent,
      this.elevation = 0.0,
      this.borderWidth = 0.0,
      this.fontSize = 14.0,
      this.fontHeight = 1.0,
      this.fontWeight = FontWeight.normal,
      this.fontFamily = AppFontFamily.characters,
      this.borderRadius = const BorderRadius.all(Radius.circular(5)),
      this.padding = const EdgeInsets.all(5)});
}
