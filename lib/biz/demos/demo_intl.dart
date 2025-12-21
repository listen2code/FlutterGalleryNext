import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/translations/app_translations.dart';
import 'package:flutter_gallery_next/main.dart';

class DemoIntl extends StatelessWidget {
  const DemoIntl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo intl"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "appName=${localizations.translate(AppLocalizations.applicationName)}\n"
              "hello=${localizations.translate(AppLocalizations.hello)}",
            ),
            ElevatedButton(
              onPressed: () {
                // Call the method in MyApp to change the language
                MyApp.of(context)?.changeLanguage(AppLocalizations.getJpaLocale());
              },
              child: const Text("jp"),
            ),
            ElevatedButton(
              onPressed: () {
                MyApp.of(context)?.changeLanguage(AppLocalizations.getEnLocale());
              },
              child: const Text("en"),
            ),
          ],
        ),
      ),
    );
  }
}
