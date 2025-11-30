import 'dart:io';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gallery_next/base/widget/refresh/refresh_manager.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:package_libs/utils/logger_util.dart';
import 'package:plugin_native/device/device_util.dart';
import 'package:plugin_native/plugin_native.dart';
import 'package:plugin_native/proxy/proxy_util.dart';

Future<void> appInit() async {
  initErrorHandler();
  initOrientations();
  initRefresh();
  initEnv();
  initDeviceInfo();
  await initIntl();
  await ProxyUtil.instance().init();
  await initDebug();
}

void initErrorHandler() {
  // Ensure the Flutter framework is initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  // This catches all errors that happen within the Flutter framework (e.g., layout errors).
  FlutterError.onError = (FlutterErrorDetails details) {
    // Print the error to the console in a structured format.
    FlutterError.dumpErrorToConsole(details);

    // In release mode, force the app to exit.
    // This is a "fail-fast" strategy to prevent the app from running in a broken state.
    if (kReleaseMode) exit(1);
  };

  // This is a global error handler for all other unhandled errors
  // that were not caught by the Flutter framework (e.g., in async code).
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    // In a real app, you would typically report the error to a service like Firebase Crashlytics here.
    // For now, we just log it.
    LoggerUtil.error('Caught unhandled error: $error stack=$stack');

    // Returning true tells the framework that the error has been handled,
    // which prevents the application from crashing.
    return true;
  };
}

/// force to portrait
void initOrientations() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

void initRefresh() {
  EasyRefresh.defaultHeaderBuilder = () {
    return RefreshManager.instance().defaultHeader;
  };
  EasyRefresh.defaultFooterBuilder = () {
    return RefreshManager.instance().defaultFooter;
  };
}

Future<void> initEnv() async {
  if (dotenv.isInitialized) {
    // ENVファイル読み込み完了
    debugPrint("ENVファイル読み込み完了");
  } else {
    String env = const String.fromEnvironment("env");
    debugPrint("loadEnv=$env");
    if (env == "stg") {
      await dotenv.load(fileName: 'env/.env.stg');
    } else {
      await dotenv.load(fileName: 'env/.env');
    }
    debugPrint("loadEnv NAME=${dotenv.env['NAME']}");
  }
}

Future<void> initDeviceInfo() async {
  await DeviceUtil.instance().init();
}

Future<void> initIntl() async {
  // --- Intl (Internationalization) Initialization ---
  // This function sets up the app's localization for formatting dates, times, and numbers.

  // STRATEGY: Pre-load data for all supported locales at startup.
  //
  // Pro: This approach is more robust. It prevents the app from crashing if the user
  //      changes the system language (e.g., from English to Japanese) while the app is
  //      running, because all necessary formatting data is already in memory.
  //
  // Con: Slightly more work is done at startup. However, the performance impact is
  //      negligible on modern devices due to parallel loading with `Future.wait`.

  // Define the locales that the application supports for date formatting.
  final supportedLocales = ['en_US', 'ja_JP'];

  // Asynchronously load the date formatting data (e.g., month names, day names) for all supported locales.
  // This is a REQUIRED step before any date formatting can be done.
  //
  // EXAMPLE: What happens if initializeDateFormatting is NOT called?
  //
  // void main() async {
  //   Intl.defaultLocale = 'en_US';
  //   // await initializeDateFormatting('en_US', null); // <-- Missing this line
  //   var now = DateTime.now();
  //   // The next line will CRASH with a `LocaleDataException` because the "dictionary" for "en_US" was never loaded.
  //   print(DateFormat.yMMMMd().format(now));
  // }
  //
  await Future.wait(supportedLocales.map((locale) => initializeDateFormatting(locale, null)));

  // Get the device's current system locale (e.g., 'en_US', 'ja_JP').
  final systemLocale = Platform.localeName;

  // Set the default locale for the entire application.
  // If the system locale is one of our supported locales, use it.
  // Otherwise, fall back to a default locale (e.g., 'en_US') to ensure stability.
  if (supportedLocales.contains(systemLocale)) {
    Intl.defaultLocale = systemLocale;
  } else {
    Intl.defaultLocale = 'en_US';
  }

  // Log the final default locale for debugging purposes.
  debugPrint('Intl default locale set to: ${Intl.defaultLocale}');
}

Future<void> initDebug() async {
  // Unhandled Exception: Binding has not yet been initialized.
  // The "instance" getter on the ServicesBinding binding mixin is only available once that binding has been initialized.
  // Typically, this is done by calling "WidgetsFlutterBinding.ensureInitialized()" or "runApp()" (the latter calls the former).
  // Typically this call is done in the "void main()" method. The "ensureInitialized" method is idempotent;
  // calling it multiple times is not harmful. After calling that method, the "instance" getter will return the binding.
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("getPlatformVersion=${await PluginNative().getPlatformVersion()}");
}
