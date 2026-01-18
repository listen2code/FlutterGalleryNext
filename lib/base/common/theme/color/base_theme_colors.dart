import 'dart:ui';

abstract class BaseThemeColors {
  const BaseThemeColors({
    required this.brightness,

    /// Role-based colors (instead of absolute black/white)
    required this.foreground, // Primary text and icons
    required this.background, // Main application background

    /// Neutral (Formerly Grey)
    required this.neutral100,
    required this.neutral200,
    required this.neutral300,
    required this.neutral400,
    required this.neutral500,
    required this.neutral600,
    required this.neutral700,
    required this.neutral800,
    required this.neutral900,
    required this.neutral1000,

    /// Rose (Formerly Salmon - Pinkish Red)
    required this.rose100,
    required this.rose200,
    required this.rose300,
    required this.rose400,
    required this.rose500,
    required this.rose600,
    required this.rose700,
    required this.rose800,
    required this.rose900,
    required this.rose1000,

    /// Standard Categories
    required this.red100,
    required this.red200,
    required this.red300,
    required this.red400,
    required this.red500,
    required this.red600,
    required this.red700,
    required this.red800,
    required this.red900,
    required this.red1000,
    required this.amber100,
    required this.amber200,
    required this.amber300,
    required this.amber400,
    required this.amber500,
    required this.amber600,
    required this.amber700,
    required this.amber800,
    required this.amber900,
    required this.amber1000,
    required this.orange100,
    required this.orange200,
    required this.orange300,
    required this.orange400,
    required this.orange500,
    required this.orange600,
    required this.orange700,
    required this.orange800,
    required this.orange900,
    required this.orange1000,
    required this.yellow100,
    required this.yellow200,
    required this.yellow300,
    required this.yellow400,
    required this.yellow500,
    required this.yellow600,
    required this.yellow700,
    required this.yellow800,
    required this.yellow900,
    required this.yellow1000,
    required this.lime100,
    required this.lime200,
    required this.lime300,
    required this.lime400,
    required this.lime500,
    required this.lime600,
    required this.lime700,
    required this.lime800,
    required this.lime900,
    required this.lime1000,
    required this.green100,
    required this.green200,
    required this.green300,
    required this.green400,
    required this.green500,
    required this.green600,
    required this.green700,
    required this.green800,
    required this.green900,
    required this.green1000,
    required this.emerald100,
    required this.emerald200,
    required this.emerald300,
    required this.emerald400,
    required this.emerald500,
    required this.emerald600,
    required this.emerald700,
    required this.emerald800,
    required this.emerald900,
    required this.emerald1000,
    required this.teal100,
    required this.teal200,
    required this.teal300,
    required this.teal400,
    required this.teal500,
    required this.teal600,
    required this.teal700,
    required this.teal800,
    required this.teal900,
    required this.teal1000,
    required this.cyan100,
    required this.cyan200,
    required this.cyan300,
    required this.cyan400,
    required this.cyan500,
    required this.cyan600,
    required this.cyan700,
    required this.cyan800,
    required this.cyan900,
    required this.cyan1000,
    required this.blue100,
    required this.blue200,
    required this.blue300,
    required this.blue400,
    required this.blue500,
    required this.blue600,
    required this.blue700,
    required this.blue800,
    required this.blue900,
    required this.blue1000,
    required this.indigo100,
    required this.indigo200,
    required this.indigo300,
    required this.indigo400,
    required this.indigo500,
    required this.indigo600,
    required this.indigo700,
    required this.indigo800,
    required this.indigo900,
    required this.indigo1000,
    required this.violet100,
    required this.violet200,
    required this.violet300,
    required this.violet400,
    required this.violet500,
    required this.violet600,
    required this.violet700,
    required this.violet800,
    required this.violet900,
    required this.violet1000,
    required this.purple100,
    required this.purple200,
    required this.purple300,
    required this.purple400,
    required this.purple500,
    required this.purple600,
    required this.purple700,
    required this.purple800,
    required this.purple900,
    required this.purple1000,
    required this.pink100,
    required this.pink200,
    required this.pink300,
    required this.pink400,
    required this.pink500,
    required this.pink600,
    required this.pink700,
    required this.pink800,
    required this.pink900,
    required this.pink1000,

    /// Success
    required this.successMain,
    required this.successDarker,
    required this.successBackground,

    /// Info
    required this.infoMain,
    required this.infoDarker,
    required this.infoBackground,

    /// Warning
    required this.warningMain,
    required this.warningDarker,
    required this.warningBackground,

    /// Danger
    required this.dangerMain,
    required this.dangerDarker,
    required this.dangerBackground,
  });

  final Brightness brightness;
  final Color foreground;
  final Color background;

  final Color neutral100;
  final Color neutral200;
  final Color neutral300;
  final Color neutral400;
  final Color neutral500;
  final Color neutral600;
  final Color neutral700;
  final Color neutral800;
  final Color neutral900;
  final Color neutral1000;

  final Color rose100;
  final Color rose200;
  final Color rose300;
  final Color rose400;
  final Color rose500;
  final Color rose600;
  final Color rose700;
  final Color rose800;
  final Color rose900;
  final Color rose1000;

  final Color red100;
  final Color red200;
  final Color red300;
  final Color red400;
  final Color red500;
  final Color red600;
  final Color red700;
  final Color red800;
  final Color red900;
  final Color red1000;

  final Color amber100;
  final Color amber200;
  final Color amber300;
  final Color amber400;
  final Color amber500;
  final Color amber600;
  final Color amber700;
  final Color amber800;
  final Color amber900;
  final Color amber1000;

  final Color orange100;
  final Color orange200;
  final Color orange300;
  final Color orange400;
  final Color orange500;
  final Color orange600;
  final Color orange700;
  final Color orange800;
  final Color orange900;
  final Color orange1000;

  final Color yellow100;
  final Color yellow200;
  final Color yellow300;
  final Color yellow400;
  final Color yellow500;
  final Color yellow600;
  final Color yellow700;
  final Color yellow800;
  final Color yellow900;
  final Color yellow1000;

  final Color lime100;
  final Color lime200;
  final Color lime300;
  final Color lime400;
  final Color lime500;
  final Color lime600;
  final Color lime700;
  final Color lime800;
  final Color lime900;
  final Color lime1000;

  final Color green100;
  final Color green200;
  final Color green300;
  final Color green400;
  final Color green500;
  final Color green600;
  final Color green700;
  final Color green800;
  final Color green900;
  final Color green1000;

  final Color emerald100;
  final Color emerald200;
  final Color emerald300;
  final Color emerald400;
  final Color emerald500;
  final Color emerald600;
  final Color emerald700;
  final Color emerald800;
  final Color emerald900;
  final Color emerald1000;

  final Color teal100;
  final Color teal200;
  final Color teal300;
  final Color teal400;
  final Color teal500;
  final Color teal600;
  final Color teal700;
  final Color teal800;
  final Color teal900;
  final Color teal1000;

  final Color cyan100;
  final Color cyan200;
  final Color cyan300;
  final Color cyan400;
  final Color cyan500;
  final Color cyan600;
  final Color cyan700;
  final Color cyan800;
  final Color cyan900;
  final Color cyan1000;

  final Color blue100;
  final Color blue200;
  final Color blue300;
  final Color blue400;
  final Color blue500;
  final Color blue600;
  final Color blue700;
  final Color blue800;
  final Color blue900;
  final Color blue1000;

  final Color indigo100;
  final Color indigo200;
  final Color indigo300;
  final Color indigo400;
  final Color indigo500;
  final Color indigo600;
  final Color indigo700;
  final Color indigo800;
  final Color indigo900;
  final Color indigo1000;

  final Color violet100;
  final Color violet200;
  final Color violet300;
  final Color violet400;
  final Color violet500;
  final Color violet600;
  final Color violet700;
  final Color violet800;
  final Color violet900;
  final Color violet1000;

  final Color purple100;
  final Color purple200;
  final Color purple300;
  final Color purple400;
  final Color purple500;
  final Color purple600;
  final Color purple700;
  final Color purple800;
  final Color purple900;
  final Color purple1000;

  final Color pink100;
  final Color pink200;
  final Color pink300;
  final Color pink400;
  final Color pink500;
  final Color pink600;
  final Color pink700;
  final Color pink800;
  final Color pink900;
  final Color pink1000;

  final Color successMain;
  final Color successDarker;
  final Color successBackground;
  final Color infoMain;
  final Color infoDarker;
  final Color infoBackground;
  final Color warningMain;
  final Color warningDarker;
  final Color warningBackground;
  final Color dangerMain;
  final Color dangerDarker;
  final Color dangerBackground;
}
