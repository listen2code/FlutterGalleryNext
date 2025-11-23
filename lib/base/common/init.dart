import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:plugin_native/plugin_native.dart';

Future<void> appInit() async {
  initErrorHandler();
  initOrientations();
  initEnv();
  initIntl();
  await initDebug();
}

void initIntl() {}

Future<void> initEnv() async {}

void initErrorHandler() {
  // Ensure the Flutter framework is initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  // This catches all errors that happen within the Flutter framework (e.g., layout errors).
  FlutterError.onError = (FlutterErrorDetails details) {
    // Print the error to the console in a structured format.
    FlutterError.dumpErrorToConsole(details);

    // In release mode, force the app to exit.
    // This is a "fail-fast" strategy to prevent the app from running in a broken state.
    if (kReleaseMode) {
      exit(1);
    }
  };

  // This is a global error handler for all other unhandled errors
  // that were not caught by the Flutter framework (e.g., in async code).
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    // In a real app, you would typically report the error to a service like Firebase Crashlytics here.
    // For now, we just log it.
    print('Caught unhandled error: $error');

    // Returning true tells the framework that the error has been handled,
    // which prevents the application from crashing.
    return true;
  }

void initOrientations() {}

Future<void> initDebug() async {
  // Unhandled Exception: Binding has not yet been initialized.
  // The "instance" getter on the ServicesBinding binding mixin is only available once that binding has been initialized.
  // Typically, this is done by calling "WidgetsFlutterBinding.ensureInitialized()" or "runApp()" (the latter calls the former).
  // Typically this call is done in the "void main()" method. The "ensureInitialized" method is idempotent;
  // calling it multiple times is not harmful. After calling that method, the "instance" getter will return the binding.
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint("getPlatformVersion=${await PluginNative().getPlatformVersion()}");
}
