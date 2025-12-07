import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'logger_util.dart';

class SecureStorageUtil {
  static const String tag = "SecureStorageUtil";
  static final SecureStorageUtil _instance = SecureStorageUtil._internal();

  SecureStorageUtil._internal();

  static SecureStorageUtil get instance => _instance;

  FlutterSecureStorage? _storage;

  /// Initializes the storage instance. This must be called before any other method.
  void init({required String accountName}) {
    _storage = FlutterSecureStorage(
      iOptions: IOSOptions(accountName: accountName, synchronizable: false),
      aOptions: const AndroidOptions(encryptedSharedPreferences: true),
    );
    log("$tag init for account: $accountName");
  }

  // Helper to check for initialization and get storage
  FlutterSecureStorage get _getStorage {
    if (_storage == null) {
      throw StateError('SecureStorageUtil has not been initialized. Call init() first.');
    }
    return _storage!;
  }

  Future<bool> contains(String key) {
    log("$tag contains key:$key");
    return _getStorage.containsKey(key: key);
  }

  Future<String?> get(String key) {
    log("$tag get key:$key");
    return _getStorage.read(key: key);
  }

  Future<void> set(String key, String? value) async {
    log("$tag set key:$key value:$value");
    await _getStorage.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    log("$tag delete key:$key");
    await _getStorage.delete(key: key);
  }

  Future<void> deleteAll() async {
    log("$tag deleteAll");
    await _getStorage.deleteAll();
  }
}
