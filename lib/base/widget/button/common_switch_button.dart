import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_resource.dart';
import 'package:flutter_gallery_next/base/common/theme/color/theme_colors.dart';

class CommonSwitchButton extends StatefulWidget {
  final List<String> values;

  final ValueChanged onToggleCallback;

  final Color? backgroundColor;

  final Color? buttonColor;

  final double viewWidth;

  final double viewHeight;

  final double emptyArea;

  final double bottomFontSize;

  final FontWeight bottomFontThickness;

  final Color? bottomTextColor;

  final double topFontSize;

  final FontWeight topFontThickness;

  final Color? topTextColor;

  final double borderRadian;

  final bool initState1;

  const CommonSwitchButton({
    super.key,
    required this.values,
    required this.onToggleCallback,
    this.backgroundColor,
    this.buttonColor,
    this.viewWidth = 118,
    this.viewHeight = 28,
    this.emptyArea = 10,
    this.bottomFontSize = 17,
    this.bottomFontThickness = FontWeight.normal,
    this.bottomTextColor,
    this.topFontSize = 17,
    this.topFontThickness = FontWeight.normal,
    this.topTextColor,
    this.borderRadian = 5,
    this.initState1 = false,
  });

  @override
  State<CommonSwitchButton> createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<CommonSwitchButton> {
  late bool initialPosition;
  late int count;

  @override
  void initState() {
    super.initState();
    initialPosition = widget.initState1;
  }

  @override
  Widget build(BuildContext context) {
    count = widget.values.fold(0, (prev, element) => prev + element.length);
    return Container(
      width: widget.viewWidth,
      height: widget.viewHeight,
      margin: EdgeInsets.all(widget.emptyArea),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              initialPosition = !initialPosition;
              var index = 0;
              if (!initialPosition) {
                index = 1;
              }
              widget.onToggleCallback(index);
              setState(() {});
            },
            child: Container(
              width: widget.viewWidth,
              height: widget.viewHeight,
              decoration: ShapeDecoration(
                color: widget.backgroundColor ?? ThemeColors.grey200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadian),
                ),
              ),
              child: Row(
                /// 主軸位置合わせ
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  widget.values.length,
                  (index) => Padding(
                    /// 下部文字の左右余白
                    padding: EdgeInsets.symmetric(
                        horizontal: ((widget.viewWidth -
                                    widget.bottomFontSize * count) /
                                4)
                            .truncateToDouble()),
                    child: Text(
                      widget.values[index],
                      style: AppTextTheme.defaultStyle(
                        fontSize: widget.bottomFontSize,
                        colors: widget.bottomTextColor ?? ThemeColors.black,
                        fontWeight: widget.bottomFontThickness,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 200),
            curve: Curves.decelerate,
            alignment: initialPosition
                ? const Alignment(-0.95, 0.0)
                : const Alignment(0.95, 0.0),
            child: Container(
              width: widget.viewWidth / 2,
              height: widget.viewHeight - 5,
              decoration: ShapeDecoration(
                color: widget.buttonColor ?? ThemeColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadian),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                initialPosition ? widget.values[0] : widget.values[1],
                style: AppTextTheme.defaultStyle(
                  fontSize: widget.topFontSize,
                  colors: widget.topTextColor ?? ThemeColors.black,
                  fontWeight: widget.topFontThickness,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
