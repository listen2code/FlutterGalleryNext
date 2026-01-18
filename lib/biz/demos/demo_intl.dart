import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/theme/app_theme.dart';
import 'package:flutter_gallery_next/base/common/translations/app_translations.dart';
import 'package:get/get.dart';

class DemoIntl extends StatelessWidget {
  const DemoIntl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.colors(context);
    final currentLocale = Get.locale ?? AppLocalizations.getEnLocale();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        // Use a fixed height container for the title to prevent jumping
        title: const Text("Demo intl"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Current Locale Info Card ---
            _buildInfoCard(
              context,
              title: "Current Language",
              content: "${_getLanguageName(currentLocale)} (${currentLocale.toString()})",
              icon: Icons.info_outline,
            ),
            const SizedBox(height: 24),

            // --- Translation Samples Section ---
            _buildSectionTitle(context, "Translation Samples"),
            const SizedBox(height: 12),
            _buildTranslationRow(AppLocalizations.hello.tr, "hello"),
            _buildTranslationRow(AppLocalizations.applicationName.tr, "applicationName"),
            _buildTranslationRow(AppLocalizations.btnOkName.tr, "btnOkName"),
            _buildTranslationRow(AppLocalizations.btnCancelName.tr, "btnCancelName"),
            const SizedBox(height: 32),

            // --- Language Switcher Section ---
            _buildSectionHeader(context, "Switch Language"),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildLocaleButton(
                    context,
                    label: "Japanese",
                    subLabel: "日本語",
                    locale: AppLocalizations.getJpaLocale(),
                    isSelected: currentLocale.languageCode == 'ja',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildLocaleButton(
                    context,
                    label: "English",
                    subLabel: "English",
                    locale: AppLocalizations.getEnLocale(),
                    isSelected: currentLocale.languageCode == 'en',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(Locale locale) {
    return locale.languageCode == 'ja' ? "Japanese" : "English";
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final colors = AppTheme.colors(context);
    return Container(
      height: 32, // Fixed height for header
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: colors.blue600,
          fontWeight: FontWeight.bold,
          fontSize: 18,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final colors = AppTheme.colors(context);
    return Container(
      height: 24, // Fixed height for title
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          color: colors.neutral700,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 1.1,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required String content, required IconData icon}) {
    final colors = AppTheme.colors(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.blue500,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.blue500.withAlpha(80),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.2)),
                Text(
                  content,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, height: 1.2),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTranslationRow(String translated, String key) {
    return Container(
      height: 48, // Fixed height to prevent UI jumping during language switch
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              translated,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.2),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(30),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(key, style: const TextStyle(fontSize: 10, color: Colors.grey, fontFamily: 'monospace')),
          ),
        ],
      ),
    );
  }

  Widget _buildLocaleButton(BuildContext context,
      {required String label, required String subLabel, required Locale locale, required bool isSelected}) {
    final colors = AppTheme.colors(context);

    return InkWell(
      onTap: () => AppLocalizations.change(changeLocale: locale),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? colors.blue100 : colors.background,
          border: Border.all(color: isSelected ? colors.blue500 : colors.neutral200, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(label,
                style:
                    TextStyle(color: isSelected ? colors.blue700 : colors.neutral800, fontWeight: FontWeight.bold, height: 1.2)),
            Text(subLabel, style: TextStyle(color: isSelected ? colors.blue500 : colors.neutral500, fontSize: 12, height: 1.2)),
          ],
        ),
      ),
    );
  }
}
