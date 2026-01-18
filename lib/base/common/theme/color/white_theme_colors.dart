import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/color/base_theme_colors.dart';

class WhiteThemeColors extends BaseThemeColors {
  const WhiteThemeColors()
      : super(
          brightness: Brightness.light,

          /// Roles
          foreground: const Color(0xFF000000),
          background: const Color(0xFFFFFFFF),

          /// Neutral (Light to Dark)
          neutral100: const Color(0xFFF7F7F7),
          neutral200: const Color(0xFFEBEBEB),
          neutral300: const Color(0xFFD1D1D1),
          neutral400: const Color(0xFFB6B6B6),
          neutral500: const Color(0xFF9C9C9C),
          neutral600: const Color(0xFF828282),
          neutral700: const Color(0xFF686868),
          neutral800: const Color(0xFF4D4D4D),
          neutral900: const Color(0xFF333333),
          neutral1000: const Color(0xFF1E1E1E),

          /// Rose (Light to Dark)
          rose100: const Color(0xFFFFE9ED),
          rose200: const Color(0xFFFFDAE0),
          rose300: const Color(0xFFFFACBA),
          rose400: const Color(0xFFFF798F),
          rose500: const Color(0xFFFF4161),
          rose600: const Color(0xFFEF0A30),
          rose700: const Color(0xFFCB0022),
          rose800: const Color(0xFFA2001B),
          rose900: const Color(0xFF830016),
          rose1000: const Color(0xFF5A000F),

          /// Standard Colors (Kept as requested)
          red100: const Color(0xFFFFE8E8), red200: const Color(0xFFFFD3D3), red300: const Color(0xFFFB9A9A),
          red400: const Color(0xFFF76B6B), red500: const Color(0xFFF53A3A), red600: const Color(0xFFEC0606),
          red700: const Color(0xFFD80000), red800: const Color(0xFFBF0000), red900: const Color(0xFF8C0000), red1000: const Color(0xFF590000),

          amber100: const Color(0xFFFFF0E8), amber200: const Color(0xFFFFE2D3), amber300: const Color(0xFFFBBA9A),
          amber400: const Color(0xFFF79A6B), amber500: const Color(0xFFF5783A), amber600: const Color(0xFFEC5306),
          amber700: const Color(0xFFD84800), amber800: const Color(0xFFBF4000), amber900: const Color(0xFF8C2F00), amber1000: const Color(0xFF591E00),

          orange100: const Color(0xFFFFEFD6), orange200: const Color(0xFFFFDBA3), orange300: const Color(0xFFFFC870),
          orange400: const Color(0xFFFFB238), orange500: const Color(0xFFF59600), orange600: const Color(0xFFDB8600),
          orange700: const Color(0xFFB87100), orange800: const Color(0xFF995E00), orange900: const Color(0xFF7B4B00), orange1000: const Color(0xFF5C3800),

          yellow100: const Color(0xFFFFF5CC), yellow200: const Color(0xFFFFEB99), yellow300: const Color(0xFFFFE066),
          yellow400: const Color(0xFFFFD633), yellow500: const Color(0xFFFFCC00), yellow600: const Color(0xFFDBAF00),
          yellow700: const Color(0xFFB89300), yellow800: const Color(0xFF947600), yellow900: const Color(0xFF705A00), yellow1000: const Color(0xFF4D3D00),

          lime100: const Color(0xFFEEFAD1), lime200: const Color(0xFFDCF5A3), lime300: const Color(0xFFCBF075),
          lime400: const Color(0xFFBAEB47), lime500: const Color(0xFFA8E519), lime600: const Color(0xFF91C516),
          lime700: const Color(0xFF61A612), lime800: const Color(0xFF62850F), lime900: const Color(0xFF4A650B), lime1000: const Color(0xFF334508),

          green100: const Color(0xFFD9F8D9), green200: const Color(0xFFBFF4BF), green300: const Color(0xFF8DE98D),
          green400: const Color(0xFF5FD95F), green500: const Color(0xFF2AC72A), green600: const Color(0xFF00B900),
          green700: const Color(0xFF009500), green800: const Color(0xFF006C00), green900: const Color(0xFF005300), green1000: const Color(0xFF003900),

          emerald100: const Color(0xFFD9F8EE), emerald200: const Color(0xFFBFF4E2), emerald300: const Color(0xFF8DE9CA),
          emerald400: const Color(0xFF5FD9B0), emerald500: const Color(0xFF2AC793), emerald600: const Color(0xFF00B97B),
          emerald700: const Color(0xFF07835A), emerald800: const Color(0xFF006C48), emerald900: const Color(0xFF005337), emerald1000: const Color(0xFF003926),

          teal100: const Color(0xFFD9F8F8), teal200: const Color(0xFFBFF4F4), teal300: const Color(0xFF8DE9E9),
          teal400: const Color(0xFF5FD9D9), teal500: const Color(0xFF2AC7C7), teal600: const Color(0xFF00B9B9),
          teal700: const Color(0xFF078383), teal800: const Color(0xFF006C6C), teal900: const Color(0xFF005353), teal1000: const Color(0xFF003939),

          cyan100: const Color(0xFFDCF3FF), cyan200: const Color(0xFFAEE4FF), cyan300: const Color(0xFF7BD3FF),
          cyan400: const Color(0xFF4DC4FF), cyan500: const Color(0xFF1FB4FF), cyan600: const Color(0xFF00A0F0),
          cyan700: const Color(0xFF0085C7), cyan800: const Color(0xFF006A9E), cyan900: const Color(0xFF004E76), cyan1000: const Color(0xFF00334D),

          blue100: const Color(0xFFE8EEFF), blue200: const Color(0xFFC9D7FF), blue300: const Color(0xFFA0B9FF),
          blue400: const Color(0xFF82A3FF), blue500: const Color(0xFF6C92FB), blue600: const Color(0xFF3A6DFA),
          blue700: const Color(0xFF134FF3), blue800: const Color(0xFF053ACE), blue900: const Color(0xFF002896), blue1000: const Color(0xFF001D6D),

          indigo100: const Color(0xFFEBE8FF), indigo200: const Color(0xFFD0C9FF), indigo300: const Color(0xFFADA0FF),
          indigo400: const Color(0xFF9382FF), indigo500: const Color(0xFF7F6CFB), indigo600: const Color(0xFF543AFA),
          indigo700: const Color(0xFF3113F3), indigo800: const Color(0xFF2005CE), indigo900: const Color(0xFF140096), indigo1000: const Color(0xFF0F006D),

          violet100: const Color(0xFFEAE5FA), violet200: const Color(0xFFDAD2F6), violet300: const Color(0xFFBDAEEF),
          violet400: const Color(0xFFA590E9), violet500: const Color(0xFF9077E4), violet600: const Color(0xFF7859DE),
          violet700: const Color(0xFF6440D9), violet800: const Color(0xFF4F29CD), violet900: const Color(0xFF370BC6), violet1000: const Color(0xFF170096),

          purple100: const Color(0xFFF1E5FA), purple200: const Color(0xFFE6D2F6), purple300: const Color(0xFFD3AEEF),
          purple400: const Color(0xFFC390E9), purple500: const Color(0xFFB577E4), purple600: const Color(0xFFA459DE),
          purple700: const Color(0xFF9640D9), purple800: const Color(0xFF8529CD), purple900: const Color(0xFF740BC6), purple1000: const Color(0xFF490096),

          pink100: const Color(0xFFFEEAF8), pink200: const Color(0xFFFDDCF1), pink300: const Color(0xFFFBB0E2),
          pink400: const Color(0xFFFB80CF), pink500: const Color(0xFFF64BBB), pink600: const Color(0xFFD42598),
          pink700: const Color(0xFFC10A82), pink800: const Color(0xFF9A0867), pink900: const Color(0xFF7C0754), pink1000: const Color(0xFF55053A),


          /// Semantic
          successMain: const Color(0xFF047205), successDarker: const Color(0xFF034B03), successBackground: const Color(0xFFEBF7EC),
          infoMain: const Color(0xFF006497), infoDarker: const Color(0xFF00496E), infoBackground: const Color(0xFFEBF7FE),
          warningMain: const Color(0xFFA35E04), warningDarker: const Color(0xFF7B4703), warningBackground: const Color(0xFFFEF0DD),
          dangerMain: const Color(0xFFDF0101), dangerDarker: const Color(0xFFB60100), dangerBackground: const Color(0xFFFFF0F0),
        );
}
