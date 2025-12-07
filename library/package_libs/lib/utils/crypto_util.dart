import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' as material;

class CryptoUtil {
  static CryptoUtil? _instance;

  factory CryptoUtil() {
    if (_instance == null) {
      throw StateError('CryptoUtil has not been initialized. Call CryptoUtil.init() first.');
    }
    return _instance!;
  }

  late final Encrypter _encrypter;
  late final IV _iv;

  CryptoUtil._internal({required String keyString, String? ivString}) {
    final key = Key.fromUtf8(keyString);
    _iv = ivString != null ? IV.fromUtf8(ivString) : IV.fromUtf8('my 16 length iv.');
    _encrypter = Encrypter(AES(key));
  }

  static void init({required String keyString, String? ivString}) {
    if (_instance != null) {
      return;
    }
    _instance = CryptoUtil._internal(keyString: keyString, ivString: ivString);
  }

  String aesEncrypt({required String plainText}) {
    try {
      final encrypted = _encrypter.encrypt(plainText, iv: _iv);
      return encrypted.base64;
    } catch (e) {
      material.debugPrint('Error during AES encryption: $e');
      return '';
    }
  }

  String aesDecrypt({required String base64Encoded}) {
    try {
      if (base64Encoded.isEmpty) {
        material.debugPrint('Error during AES decryption: input string is empty.');
        return '';
      }
      final encrypted = Encrypted.fromBase64(base64Encoded);
      final decrypted = _encrypter.decrypt(encrypted, iv: _iv);
      return decrypted;
    } catch (e) {
      material.debugPrint('Error during AES decryption: $e');
      return '';
    }
  }
}
