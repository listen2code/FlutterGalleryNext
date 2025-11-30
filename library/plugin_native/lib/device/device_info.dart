class DeviceInfo {
  DeviceInfo({
    required this.appName,
    required this.packageName,
    required this.appVersionName,
    required this.appVersionCode,
    required this.model,
    required this.product,
    required this.deviceVersion,
    required this.uuid,
  });

  /// The app name. `CFBundleDisplayName` on iOS, `application/label` on Android.
  final String appName;

  /// The package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
  final String packageName;

  /// The app versionName. `CFBundleShortVersionString` on iOS, `versionName` on Android.
  final String appVersionName;

  /// The app versionCode. `CFBundleVersion` on iOS, `versionCode` on Android.
  final String appVersionCode;

  /// The model name of device.
  final String model;

  /// The product name of device.
  final String product;

  /// The version of device is running.
  final String deviceVersion;

  /// The UUID.
  final String uuid;
}
