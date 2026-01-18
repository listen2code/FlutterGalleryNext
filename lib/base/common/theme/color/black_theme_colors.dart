import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/color/base_theme_colors.dart';

class BlackThemeColors extends BaseThemeColors {
  const BlackThemeColors()
      : super(
    brightness: Brightness.dark,

    /// Roles (Swapped)
    foreground: const Color(0xFFFFFFFF),
    background: const Color(0xFF121212),

    /// Neutral (Dark to Light)
    neutral100: const Color(0xFF1E1E1E),
    neutral200: const Color(0xFF2C2C2C),
    neutral300: const Color(0xFF3D3D3D),
    neutral400: const Color(0xFF4F4D4D),
    neutral500: const Color(0xFF616161),
    neutral600: const Color(0xFF757575),
    neutral700: const Color(0xFF9E9E9E),
    neutral800: const Color(0xFFBDBDBD),
    neutral900: const Color(0xFFE0E0E0),
    neutral1000: const Color(0xFFF5F5F5),

    /// Rose (Dark to Light)
    rose100: const Color(0xFF451010),
    rose200: const Color(0xFF661515),
    rose300: const Color(0xFF991B1B),
    rose400: const Color(0xFFB91C1C),
    rose500: const Color(0xFFF43F5E),
    rose600: const Color(0xFFFB7185),
    rose700: const Color(0xFFFDA4AF),
    rose800: const Color(0xFFFECDD3),
    rose900: const Color(0xFFFFE4E6),
    rose1000: const Color(0xFFFFF1F2),

    /// Red
    red100: const Color(0xFF451010), red200: const Color(0xFF661515), red300: const Color(0xFF991B1B),
    red400: const Color(0xFFB91C1C), red500: const Color(0xFFEF4444), red600: const Color(0xFFF87171),
    red700: const Color(0xFFFCA5A5), red800: const Color(0xFFFECACA), red900: const Color(0xFFFEE2E2), red1000: const Color(0xFFFEF2F2),

    /// Amber
    amber100: const Color(0xFF452010), amber200: const Color(0xFF662F15), amber300: const Color(0xFF99461B),
    amber400: const Color(0xFFB95A1C), amber500: const Color(0xFFF59E0B), amber600: const Color(0xFFFBBF24),
    amber700: const Color(0xFFFCD34D), amber800: const Color(0xFFFDE68A), amber900: const Color(0xFFFEF3C7), amber1000: const Color(0xFFFFFBEB),

    /// Orange
    orange100: const Color(0xFF452510), orange200: const Color(0xFF663715), orange300: const Color(0xFF99521B),
    orange400: const Color(0xFFB9631C), orange500: const Color(0xFFF97316), orange600: const Color(0xFFFB923C),
    orange700: const Color(0xFFFDBA74), orange800: const Color(0xFFFED7AA), orange900: const Color(0xFFFFEDD5), orange1000: const Color(0xFFFFF7ED),

    /// Yellow
    yellow100: const Color(0xFF423A10), yellow200: const Color(0xFF615715), yellow300: const Color(0xFF92831B),
    yellow400: const Color(0xFFB1A01C), yellow500: const Color(0xFFEAB308), yellow600: const Color(0xFFFACC15),
    yellow700: const Color(0xFFFDE047), yellow800: const Color(0xFFFEF08A), yellow900: const Color(0xFFFEF9C3), yellow1000: const Color(0xFFFEFCE8),

    /// Lime
    lime100: const Color(0xFF203510), lime200: const Color(0xFF304F15), lime300: const Color(0xFF48761B),
    lime400: const Color(0xFF57901C), lime500: const Color(0xFF84CC16), lime600: const Color(0xFFA3E635),
    lime700: const Color(0xFFBEF264), lime800: const Color(0xFFD9F99D), lime900: const Color(0xFFECFCCB), lime1000: const Color(0xFFF7FEE7),

    /// Green
    green100: const Color(0xFF103518), green200: const Color(0xFF154F24), green300: const Color(0xFF1B7635),
    green400: const Color(0xFF1C9041), green500: const Color(0xFF22C55E), green600: const Color(0xFF4ADE80),
    green700: const Color(0xFF86EFAC), green800: const Color(0xFFBBF7D0), green900: const Color(0xFFDCFCE7), green1000: const Color(0xFFF0FDF4),

    /// Emerald
    emerald100: const Color(0xFF10352A), emerald200: const Color(0xFF154F3E), emerald300: const Color(0xFF1B765D),
    emerald400: const Color(0xFF1C9071), emerald500: const Color(0xFF10B981), emerald600: const Color(0xFF34D399),
    emerald700: const Color(0xFF6EE7B7), emerald800: const Color(0xFFA7F3D0), emerald900: const Color(0xFFD1FAE5), emerald1000: const Color(0xFFECFDF5),

    /// Teal
    teal100: const Color(0xFF103535), teal200: const Color(0xFF154F4F), teal300: const Color(0xFF1B7676),
    teal400: const Color(0xFF1C9090), teal500: const Color(0xFF14B8A6), teal600: const Color(0xFF2DD4BF),
    teal700: const Color(0xFF5EEAD4), teal800: const Color(0xFF99F6E4), teal900: const Color(0xFFCCFBF1), teal1000: const Color(0xFFF0FDFA),

    /// Cyan
    cyan100: const Color(0xFF103045), cyan200: const Color(0xFF154766), cyan300: const Color(0xFF1B6B99),
    cyan400: const Color(0xFF1C82B9), cyan500: const Color(0xFF06B6D4), cyan600: const Color(0xFF22D3EE),
    cyan700: const Color(0xFF67E8F9), cyan800: const Color(0xFFA5F3FC), cyan900: const Color(0xFFCFFAFE), cyan1000: const Color(0xFFECFEFF),

    /// Blue
    blue100: const Color(0xFF102545), blue200: const Color(0xFF153766), blue300: const Color(0xFF1B5299),
    blue400: const Color(0xFF1C63B9), blue500: const Color(0xFF3B82F6), blue600: const Color(0xFF60A5FA),
    blue700: const Color(0xFF93C5FD), blue800: const Color(0xFFBFDBFE), blue900: const Color(0xFFDBEAFE), blue1000: const Color(0xFFEFF6FF),

    /// Indigo
    indigo100: const Color(0xFF1E1B4B), indigo200: const Color(0xFF312E81), indigo300: const Color(0xFF3730A3),
    indigo400: const Color(0xFF4338CA), indigo500: const Color(0xFF6366F1), indigo600: const Color(0xFF818CF8),
    indigo700: const Color(0xFFA5B4FC), indigo800: const Color(0xFFC7D2FE), indigo900: const Color(0xFFE0E7FF), indigo1000: const Color(0xFFEEF2FF),

    /// Violet
    violet100: const Color(0xFF2E1065), violet200: const Color(0xFF4C1D95), violet300: const Color(0xFF5B21B6),
    violet400: const Color(0xFF6D28D9), violet500: const Color(0xFF8B5CF6), violet600: const Color(0xFFA78BFA),
    violet700: const Color(0xFFC4B5FD), violet800: const Color(0xFFDDD6FE), violet900: const Color(0xFFEDE9FE), violet1000: const Color(0xFFF5F3FF),

    /// Purple
    purple100: const Color(0xFF3B0764), purple200: const Color(0xFF581C87), purple300: const Color(0xFF6B21A8),
    purple400: const Color(0xFF7E22CE), purple500: const Color(0xFFA855F7), purple600: const Color(0xFFC084FC),
    purple700: const Color(0xFFD8B4FE), purple800: const Color(0xFFE9D5FF), purple900: const Color(0xFFF3E8FF), purple1000: const Color(0xFFFAF5FF),

    /// Pink
    pink100: const Color(0xFF500724), pink200: const Color(0xFF831843), pink300: const Color(0xFF9D174D),
    pink400: const Color(0xFFBE185D), pink500: const Color(0xFFEC4899), pink600: const Color(0xFFF472B6),
    pink700: const Color(0xFFF9A8D4), pink800: const Color(0xFFFBCFE8), pink900: const Color(0xFFFCE7F3), pink1000: const Color(0xFFFDF2F8),

    /// Semantic
    successMain: const Color(0xFF22C55E), successDarker: const Color(0xFF15803D), successBackground: const Color(0xFF052E16),
    infoMain: const Color(0xFF3B82F6), infoDarker: const Color(0xFF1D4ED8), infoBackground: const Color(0xFF1E3A8A),
    warningMain: const Color(0xFFEAB308), warningDarker: const Color(0xFFA16207), warningBackground: const Color(0xFF422006),
    dangerMain: const Color(0xFFEF4444), dangerDarker: const Color(0xFFB91C1C), dangerBackground: const Color(0xFF450A0A),
  );
}
