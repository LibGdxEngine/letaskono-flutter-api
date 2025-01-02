import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class SecureStorage {
  static final String _key = _generateKey(
      "بسم الله الذي لا يضر مع اسمه شيء في الأرض ولا في السماء وهو السميع العليم");

  // Generate a 256-bit key
  static String _generateKey(String input) {
    final keyHash = sha256.convert(utf8.encode(input));
    return base64
        .encode(keyHash.bytes)
        .substring(0, 32); // Take the first 32 characters
  }

  // Encrypt text with a random IV
  static String encryptText(String plainText) {
    final key = encrypt.Key.fromUtf8(_key);
    final iv = encrypt.IV.fromLength(16); // Generate a random IV
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);

    // Concatenate IV and encrypted text, separated by ':'
    return "${base64.encode(iv.bytes)}:${encrypted.base64}";
  }

  // Decrypt text using the extracted IV
  static String decryptText(String encryptedText) {
    final key = encrypt.Key.fromUtf8(_key);

    // Split the stored string to get the IV and the ciphertext
    final parts = encryptedText.split(':');
    if (parts.length != 2) {
      throw ArgumentError("Invalid encrypted text format");
    }

    final iv = encrypt.IV.fromBase64(parts[0]); // Extract the IV
    final ciphertext = parts[1]; // Extract the ciphertext
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    return encrypter.decrypt64(ciphertext, iv: iv);
  }
}
