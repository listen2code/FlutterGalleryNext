import 'package:flutter/material.dart';
import 'package:flutter_gallery_next/base/common/app_localizations.dart';

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
            Text("appName=${AppLocalizations.appName.tr}\n"
                "hello=${AppLocalizations.hello.tr}"),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    AppLocalizations.defaultSupportedLocale = AppLocalizations.jpSupportedLocale;
                  });
                },
                child: const Text("jp")),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    AppLocalizations.defaultSupportedLocale = AppLocalizations.enSupportedLocale;
                  });
                },
                child: const Text("en")),
          ],
        ),
      ),
    );
  }
}
