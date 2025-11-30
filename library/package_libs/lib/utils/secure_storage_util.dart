import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'logger_util.dart';

class SecureStorageUtil {
  static const String tag = "SecureStorageUtil";
  static final SecureStorageUtil _instance = SecureStorageUtil._private();

  SecureStorageUtil._private();

  factory SecureStorageUtil.instance() => _instance;

  late String accountName;

  void init({required String accountName}) {
    this.accountName = accountName;
  }

  FlutterSecureStorage createStorage() {
    FlutterSecureStorage storage = FlutterSecureStorage(
      iOptions: IOSOptions(accountName: accountName, synchronizable: false),
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    );
    return storage;
  }

  Future<bool> contains(String key) {
    log("$tag contains key:$key");
    return createStorage().containsKey(key: key);
  }

  Future<String?> get(String key) {
    log("$tag get key:$key");
    return createStorage().read(key: key);
  }

  void set(String key, String? value) {
    log("$tag set key:$key value:$value");
    createStorage().write(key: key, value: value);
  }

  void delete(String key) {
    log("$tag delete key:$key");
    createStorage().delete(key: key);
  }

  void deleteAll() {
    log("$tag deleteAll");
    createStorage().deleteAll();
  }
}
