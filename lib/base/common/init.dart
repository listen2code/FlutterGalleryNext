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

void initErrorHandler() {}

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
