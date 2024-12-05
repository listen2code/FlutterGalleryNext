import 'package:flutter/material.dart';

import 'common_button.dart';

class CommonCheckableButton extends StatelessWidget {
  final String text;

  final ValueChanged<bool> onPressed;

  final ButtonOptions checkOptions;

  final ButtonOptions uncheckOptions;

  final bool isChecked;

  const CommonCheckableButton({
    super.key,
    this.isChecked = false,
    required this.onPressed,
    required this.text,
    required this.checkOptions,
    required this.uncheckOptions,
  });

  @override
  Widget build(BuildContext context) {
    return CommonButton(
      text: text,
      onPressed: () {
        onPressed(isChecked);
      },
      options: isChecked ? checkOptions : uncheckOptions,
    );
  }
}
