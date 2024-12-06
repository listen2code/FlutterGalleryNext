import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/color/theme_colors.dart';

class CommonRadio extends StatelessWidget {
  const CommonRadio({
    super.key,
    required this.index,
    required this.isSelected,
    this.isEnabled = true,
    this.width = 24,
    required this.onChanged,
  });

  final int index;
  final bool isSelected;
  final bool isEnabled;
  final double width;
  final Function(int, bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isEnabled) {
          onChanged(index, !isSelected);
        }
      },
      child: _iconImage(),
    );
  }

  Widget _iconImage() => Container(
        width: width,
        height: width,
        alignment: Alignment.center,
        child: isSelected ? _selectedWidget() : _unselectedWidget(),
      );

  Widget _selectedWidget() => Stack(
        alignment: Alignment.center,
        children: [
          _unselectedWidget(),
          Container(
            width: 8,
            height: 8,
            decoration: ShapeDecoration(
              color: ThemeColors.grey1000,
              shape: const OvalBorder(),
            ),
          )
        ],
      );

  Widget _unselectedWidget() => Container(
        width: 14,
        height: 14,
        decoration: ShapeDecoration(
          color: ThemeColors.grey100,
          shape: OvalBorder(
            side: BorderSide(width: 1, color: ThemeColors.grey500),
          ),
        ),
      );
}
