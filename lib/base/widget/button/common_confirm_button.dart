import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_styles.dart';
import 'package:flutter_gallery_next/base/common/theme/color/theme_colors.dart';

import 'common_button.dart';

class CommonConfirmButton extends StatelessWidget {
  final ConfirmButtonType type;

  final double height;

  final double widthRatio;

  final List<String> text;

  final double horizontalSpacing;

  final double verticalSpacing;

  final List<int>? flex;

  final List<VoidCallback> onPressed;

  final List<ButtonOptions>? options;

  final List<ButtonOptions>? notEnabledOptions;

  final List<bool>? isEnabled;

  const CommonConfirmButton({
    super.key,
    this.type = ConfirmButtonType.twoToneAvg,
    required this.text,
    required this.onPressed,
    this.options,
    this.notEnabledOptions,
    this.flex,
    this.height = 30,
    this.widthRatio = 0.7,
    this.horizontalSpacing = 5,
    this.verticalSpacing = 5,
    this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ConfirmButtonType.monochromeAvg:
        return buildMonochromeAvg();
      case ConfirmButtonType.monochromeUneven:
        return buildMonochromeUneven();
      case ConfirmButtonType.twoToneAvg:
        return buildTwoToneAvg();
      case ConfirmButtonType.twoToneUneven:
        return buildTwoToneUneven();
      case ConfirmButtonType.redBlue:
        return buildRedBlue();
      case ConfirmButtonType.redWhiteUneven:
        return buildRedWhite();
      case ConfirmButtonType.blackWhiteVertical:
        return buildBlackWhite();
      case ConfirmButtonType.other:
        return buildOther();
    }
  }

  List<bool> createEnabledList() {
    List<bool> result = [];
    for (var _ in text) {
      result.add(true);
    }
    return result;
  }

  List<ButtonOptions> createNotEnabledOptions(List<ButtonOptions> enabledOptions) {
    List<ButtonOptions> result = [];
    for (ButtonOptions opt in enabledOptions) {
      result.add(ButtonOptions(
        width: opt.width,
        height: opt.height,
        color: opt.color.withAlpha((255 * 0.3).toInt()),
        fontColor: opt.fontColor,
        borderColor: opt.borderColor,
        elevation: opt.elevation,
        borderWidth: opt.borderWidth,
        fontSize: opt.fontSize,
        fontHeight: opt.fontHeight,
        fontWeight: opt.fontWeight,
        fontFamily: opt.fontFamily,
        borderRadius: opt.borderRadius,
        padding: opt.padding,
      ));
    }
    return result;
  }

  FractionallySizedBox createFractionallySizedBox(
    List<ButtonOptions> optionsList,
    List<ButtonOptions> notOptionsList,
    List<int> flexList,
    List<bool> enabled,
  ) {
    return FractionallySizedBox(
      widthFactor: widthRatio,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: createButtonList(optionsList, notOptionsList, flexList, enabled),
      ),
    );
  }

  Widget buildMonochromeAvg() {
    var optionsList = options ?? blueButtonOptions();
    var flexList = flex ?? avgFlex();
    var enabled = isEnabled ?? createEnabledList();
    return createFractionallySizedBox(optionsList, optionsList, flexList, enabled);
  }

  Widget buildMonochromeUneven() {
    var optionsList = options ?? blueButtonOptions();
    var flexList = flex ?? unevenFlex();
    var enabled = isEnabled ?? createEnabledList();
    return createFractionallySizedBox(optionsList, optionsList, flexList, enabled);
  }

  Widget buildTwoToneAvg() {
    var optionsList = options ?? twoToneButtonOptions();
    var flexList = flex ?? avgFlex();
    var enabled = isEnabled ?? createEnabledList();
    return createFractionallySizedBox(optionsList, optionsList, flexList, enabled);
  }

  Widget buildTwoToneUneven() {
    var optionsList = options ?? twoToneButtonOptions();
    var flexList = flex ?? unevenFlex();
    var enabled = isEnabled ?? createEnabledList();
    return createFractionallySizedBox(optionsList, optionsList, flexList, enabled);
  }

  Widget buildRedBlue() {
    var optionsList = options ?? redBlueButtonOptions();
    var flexList = flex ?? unevenFlex();
    var enabled = isEnabled ?? createEnabledList();
    return createFractionallySizedBox(optionsList, optionsList, flexList, enabled);
  }

  Widget buildRedWhite() {
    var optionsList = options ?? whiteRedButtonOptions();
    var notOptionsList = notEnabledOptions ?? createNotEnabledOptions(optionsList);
    var flexList = flex ?? unevenFlex();
    var enabled = isEnabled ?? createEnabledList();
    return createFractionallySizedBox(optionsList, notOptionsList, flexList, enabled);
  }

  Widget buildBlackWhite() {
    var optionsList = options ?? blackWhiteButtonOptions();
    var notOptionsList = notEnabledOptions ?? createNotEnabledOptions(optionsList);
    var enabled = isEnabled ?? createEnabledList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: createButtonListVertical(optionsList, notOptionsList, enabled),
    );
  }

  Widget buildOther() {
    var optionsList = options!;
    var flexList = flex!;
    var enabled = isEnabled ?? createEnabledList();
    return createFractionallySizedBox(optionsList, optionsList, flexList, enabled);
  }

  List<Widget> createButtonList(
    List<ButtonOptions> options,
    List<ButtonOptions> notOptions,
    List<int> flex,
    List<bool> isEnabled,
  ) {
    List<Widget> list = [];
    for (var i = 0; i < text.length; i++) {
      list.add(
        Expanded(
          flex: flex[i],
          child: Container(
            margin: EdgeInsets.fromLTRB(horizontalSpacing, 0, horizontalSpacing, 0),
            child: CommonButton(
              text: text[i],
              onPressed: createOnPresses(isEnabled[i], onPressed[i]),
              options: isEnabled[i] ? options[i] : notOptions[i],
            ),
          ),
        ),
      );
    }
    return list;
  }

  List<Widget> createButtonListVertical(
    List<ButtonOptions> options,
    List<ButtonOptions> notOptions,
    List<bool> isEnabled,
  ) {
    List<Widget> list = [];
    for (var i = 0; i < text.length; i++) {
      list.add(
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, verticalSpacing),
          child: CommonButton(
            text: text[i],
            onPressed: createOnPresses(isEnabled[i], onPressed[i]),
            options: isEnabled[i] ? options[i] : notOptions[i],
          ),
        ),
      );
    }
    return list;
  }

  void closeKeyword() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  VoidCallback? createOnPresses(bool enabled, VoidCallback presses) {
    if (enabled) {
      return () {
        closeKeyword();
        presses();
      };
    } else {
      return null;
    }
  }

  List<ButtonOptions> blueButtonOptions() {
    List<ButtonOptions> options = [];
    for (var _ in text) {
      options.add(blueAndWhiteButtonOptions());
    }
    return options;
  }

  List<ButtonOptions> twoToneButtonOptions() {
    List<ButtonOptions> options = [];
    for (var i = 0; i < text.length - 1; i++) {
      options.add(whiteAndBlueButtonOptions());
    }
    options.add(blueAndWhiteButtonOptions());
    return options;
  }

  List<ButtonOptions> redBlueButtonOptions() {
    List<ButtonOptions> options = [];
    options.add(redAndWhiteButtonOptions());
    for (var i = 1; i < text.length; i++) {
      options.add(blueAndWhiteButtonOptions());
    }
    return options;
  }

  List<ButtonOptions> whiteRedButtonOptions() {
    List<ButtonOptions> options = [];
    options.add(doubleColorButtonOptions(
      ThemeColors.white,
      ThemeColors.red700,
      ThemeColors.red700,
    ));
    ThemeColors.white;
    for (var i = 1; i < text.length; i++) {
      options.add(doubleColorButtonOptions(
        ThemeColors.red700,
        ThemeColors.white,
        ThemeColors.white,
      ));
    }
    return options;
  }

  List<ButtonOptions> blackWhiteButtonOptions() {
    List<ButtonOptions> options = [];
    options.add(doubleColorButtonOptions(
      ThemeColors.grey1000,
      ThemeColors.white,
      ThemeColors.white,
      fontSize: 14,
    ));
    for (var i = 1; i < text.length; i++) {
      options.add(doubleColorButtonOptions(
        ThemeColors.white,
        ThemeColors.grey1000,
        ThemeColors.grey1000,
        fontSize: 14,
      ));
    }
    return options;
  }

  List<int> avgFlex() {
    List<int> options = [];
    for (var _ in text) {
      options.add(1);
    }
    return options;
  }

  List<int> unevenFlex() {
    List<int> options = [];
    for (var i = 0; i < text.length - 1; i++) {
      options.add(1);
    }
    options.add(2);
    return options;
  }

  ButtonOptions blueAndWhiteButtonOptions() {
    return ButtonOptions(
      height: height,
      color: const Color(0xFF007AFF),
      fontColor: ThemeColors.white,
      fontSize: 14,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      padding: const EdgeInsets.all(5),
    );
  }

  ButtonOptions redAndWhiteButtonOptions() {
    return ButtonOptions(
      height: height,
      color: ThemeColors.red800,
      fontColor: ThemeColors.white,
      fontSize: 14,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      padding: const EdgeInsets.all(5),
    );
  }

  ButtonOptions doubleColorButtonOptions(Color bgColor, Color fontColor, Color borderColor, {double fontSize = 16.0}) {
    return ButtonOptions(
      height: height,
      color: bgColor,
      fontColor: fontColor,
      fontSize: fontSize,
      fontFamily: AppFontFamily.characters,
      fontWeight: FontWeight.w300,
      borderWidth: 0,
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      padding: const EdgeInsets.all(5),
    );
  }

  ButtonOptions whiteAndBlueButtonOptions() {
    return ButtonOptions(
      height: height,
      color: ThemeColors.white,
      fontColor: const Color(0xFF007AFF),
      borderColor: const Color(0xFF007AFF),
      borderWidth: 1,
      fontSize: 14,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      padding: const EdgeInsets.all(5),
    );
  }
}

enum ConfirmButtonType {
  // 色が一種(青い)で平均に幅
  monochromeAvg,
  // 色が一種(青い)で非平均に幅（最後のボタンが大きい）
  monochromeUneven,
  // 色が二種(白い、青い)で平均に幅
  twoToneAvg,
  // 色が二種(白い、青い)で非平均に幅（最後のボタンが大きい）
  twoToneUneven,
  // 色が二種(赤い、青い)で平均に幅
  redBlue,
  // 左白い、右赤い、非平均に幅（最後のボタンが大きい）
  redWhiteUneven,
  // 上黒い、下白い、縦型表示
  blackWhiteVertical,
  // 色、幅などは自分で設定可能
  other,
}
