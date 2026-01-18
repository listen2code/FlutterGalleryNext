import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';
import 'package:flutter_gallery_next/base/common/theme/color/base_theme_colors.dart';
import 'package:flutter_gallery_next/main.dart';

class DemoTheme extends StatelessWidget {
  const DemoTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return const DemoThemePage();
  }
}

class DemoThemePage extends StatelessWidget {
  const DemoThemePage({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = AppTheme.colors(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDark = MyApp.of(context)?.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Demo theme'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
              MyApp.of(context)?.changeTheme(newMode);
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          /// 1. Standard ThemeData ColorScheme Roles
          _buildSectionHeader(context, 'ThemeData ColorScheme (Standard)'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildThemeRoleBox('Primary', colorScheme.primary, colorScheme.onPrimary),
                _buildThemeRoleBox('Secondary', colorScheme.secondary, colorScheme.onSecondary),
                _buildThemeRoleBox('Surface', colorScheme.surface, colorScheme.onSurface),
                _buildThemeRoleBox('Error', colorScheme.error, colorScheme.onError),
                _buildThemeRoleBox('Outline', colorScheme.outline, colorScheme.onSurface.withOpacity(0.6)),
              ],
            ),
          ),
          const Divider(height: 48),

          /// 2. Role-based primary colors (Background/Foreground)
          _buildSectionHeader(context, 'Core Roles'),
          _buildRoleSection(context, colors),
          const Divider(height: 48),

          /// 3. Semantic Components
          _buildSectionHeader(context, 'Semantic Tokens'),
          _buildSemanticSection(context, colors),
          const Divider(height: 48),

          /// 4. Complete Palette Gradients (All 16 Scales)
          _buildSectionHeader(context, 'Complete Palette (100-1000)'),
          
          _buildPaletteRow(context, 'Neutral (Grey)', [
            colors.neutral100, colors.neutral200, colors.neutral300, colors.neutral400, colors.neutral500,
            colors.neutral600, colors.neutral700, colors.neutral800, colors.neutral900, colors.neutral1000,
          ]),
          _buildPaletteRow(context, 'Rose (Salmonish)', [
            colors.rose100, colors.rose200, colors.rose300, colors.rose400, colors.rose500,
            colors.rose600, colors.rose700, colors.rose800, colors.rose900, colors.rose1000,
          ]),
          _buildPaletteRow(context, 'Red', [
            colors.red100, colors.red200, colors.red300, colors.red400, colors.red500,
            colors.red600, colors.red700, colors.red800, colors.red900, colors.red1000,
          ]),
          _buildPaletteRow(context, 'Amber', [
            colors.amber100, colors.amber200, colors.amber300, colors.amber400, colors.amber500,
            colors.amber600, colors.amber700, colors.amber800, colors.amber900, colors.amber1000,
          ]),
          _buildPaletteRow(context, 'Orange', [
            colors.orange100, colors.orange200, colors.orange300, colors.orange400, colors.orange500,
            colors.orange600, colors.orange700, colors.orange800, colors.orange900, colors.orange1000,
          ]),
          _buildPaletteRow(context, 'Yellow', [
            colors.yellow100, colors.yellow200, colors.yellow300, colors.yellow400, colors.yellow500,
            colors.yellow600, colors.yellow700, colors.yellow800, colors.yellow900, colors.yellow1000,
          ]),
          _buildPaletteRow(context, 'Lime', [
            colors.lime100, colors.lime200, colors.lime300, colors.lime400, colors.lime500,
            colors.lime600, colors.lime700, colors.lime800, colors.lime900, colors.lime1000,
          ]),
          _buildPaletteRow(context, 'Green', [
            colors.green100, colors.green200, colors.green300, colors.green400, colors.green500,
            colors.green600, colors.green700, colors.green800, colors.green900, colors.green1000,
          ]),
          _buildPaletteRow(context, 'Emerald', [
            colors.emerald100, colors.emerald200, colors.emerald300, colors.emerald400, colors.emerald500,
            colors.emerald600, colors.emerald700, colors.emerald800, colors.emerald900, colors.emerald1000,
          ]),
          _buildPaletteRow(context, 'Teal', [
            colors.teal100, colors.teal200, colors.teal300, colors.teal400, colors.teal500,
            colors.teal600, colors.teal700, colors.teal800, colors.teal900, colors.teal1000,
          ]),
          _buildPaletteRow(context, 'Cyan', [
            colors.cyan100, colors.cyan200, colors.cyan300, colors.cyan400, colors.cyan500,
            colors.cyan600, colors.cyan700, colors.cyan800, colors.cyan900, colors.cyan1000,
          ]),
          _buildPaletteRow(context, 'Blue', [
            colors.blue100, colors.blue200, colors.blue300, colors.blue400, colors.blue500,
            colors.blue600, colors.blue700, colors.blue800, colors.blue900, colors.blue1000,
          ]),
          _buildPaletteRow(context, 'Indigo', [
            colors.indigo100, colors.indigo200, colors.indigo300, colors.indigo400, colors.indigo500,
            colors.indigo600, colors.indigo700, colors.indigo800, colors.indigo900, colors.indigo1000,
          ]),
          _buildPaletteRow(context, 'Violet', [
            colors.violet100, colors.violet200, colors.violet300, colors.violet400, colors.violet500,
            colors.violet600, colors.violet700, colors.violet800, colors.violet900, colors.violet1000,
          ]),
          _buildPaletteRow(context, 'Purple', [
            colors.purple100, colors.purple200, colors.purple300, colors.purple400, colors.purple500,
            colors.purple600, colors.purple700, colors.purple800, colors.purple900, colors.purple1000,
          ]),
          _buildPaletteRow(context, 'Pink', [
            colors.pink100, colors.pink200, colors.pink300, colors.pink400, colors.pink500,
            colors.pink600, colors.pink700, colors.pink800, colors.pink900, colors.pink1000,
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
    );
  }

  Widget _buildThemeRoleBox(String label, Color bg, Color onColor) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 60,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Center(
            child: Text('Aa', style: TextStyle(color: onColor, fontWeight: FontWeight.bold, fontSize: 18)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
        Text('on$label', style: TextStyle(fontSize: 10, color: onColor.withOpacity(0.7))),
      ],
    );
  }

  Widget _buildRoleSection(BuildContext context, BaseThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildLargeColorBox('Background', colors.background, colors.foreground),
          const SizedBox(width: 16),
          _buildLargeColorBox('Foreground', colors.foreground, colors.background),
        ],
      ),
    );
  }

  Widget _buildLargeColorBox(String label, Color bg, Color text) {
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(color: text, fontWeight: FontWeight.bold)),
            Text(bg.toString().substring(10, 16).toUpperCase(), 
                 style: TextStyle(color: text.withOpacity(0.6), fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildSemanticSection(BuildContext context, BaseThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildStatusBanner('SUCCESS', colors.successMain, colors.successBackground, colors.successDarker, Icons.check_circle),
          const SizedBox(height: 8),
          _buildStatusBanner('DANGER', colors.dangerMain, colors.dangerBackground, colors.dangerDarker, Icons.error),
          const SizedBox(height: 8),
          _buildStatusBanner('WARNING', colors.warningMain, colors.warningBackground, colors.warningDarker, Icons.warning),
          const SizedBox(height: 8),
          _buildStatusBanner('INFO', colors.infoMain, colors.infoBackground, colors.infoDarker, Icons.info),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(String label, Color main, Color bg, Color text, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: main.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: main, size: 20),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: text, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
          const Spacer(),
          Text('on$label', style: TextStyle(color: text.withOpacity(0.6), fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildPaletteRow(BuildContext context, String title, List<Color> scale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        ),
        SizedBox(
          height: 85,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: scale.length,
            itemBuilder: (context, index) {
              final color = scale[index];
              final step = (index + 1) * 100;
              final textColor = color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black.withOpacity(0.05)),
                      ),
                      child: Center(
                        child: Text('$step', style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w900)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(color.toString().substring(10, 16).toUpperCase(), style: const TextStyle(fontSize: 8, color: Colors.grey)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
