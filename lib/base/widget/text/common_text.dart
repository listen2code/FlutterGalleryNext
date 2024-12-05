import 'package:flutter/material.dart';

class CommonText extends Text {
  const CommonText(
    super.data, {
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaler,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
    this.commonFit,
    this.alignment,
  });

  final BoxFit? commonFit;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return _commonText(context);
  }

  Widget _commonText(BuildContext context) => FittedBox(
        fit: commonFit ?? BoxFit.contain,
        alignment: alignment ?? Alignment.center,
        child: super.build(context),
      );
}

class ContainerOptions {
  ContainerOptions({
    this.height,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.decoration,
    this.alignment,
  });

  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Decoration? decoration;
  final AlignmentGeometry? alignment;
}
