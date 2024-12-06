import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/translations/app_translations.dart';
import 'package:get/get.dart';

class DemoIntl extends StatefulWidget {
  const DemoIntl({Key? key}) : super(key: key);

  @override
  State<DemoIntl> createState() => _DemoIntlState();
}

class _DemoIntlState extends State<DemoIntl> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo intl"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("appName=${AppLocalizations.applicationName.tr}\n"
                "hello=${AppLocalizations.hello.tr}"),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    AppLocalizations.change(
                        changeLocale: AppLocalizations.getJpaLocale());
                  });
                },
                child: const Text("jp")),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    AppLocalizations.change(
                        changeLocale: AppLocalizations.getEnLocale());
                  });
                },
                child: const Text("en")),
          ],
        ),
      ),
    );
  }
}
