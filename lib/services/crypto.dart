import 'package:encrypt/encrypt.dart';

const passphrase = 'A7ju38EWg6mUZE2KA7ju38EWg6mUZE2K';

String encriptar(String encoded) {
  final key = Key.fromUtf8(passphrase);
  final iv = IV.fromUtf8(passphrase.substring(0,16));
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
  final res = encrypter.encrypt(encoded, iv: iv);

  return res.base64;
}

String desencriptar(String encoded) {
  final key = Key.fromUtf8(passphrase);
  final iv = IV.fromUtf8(passphrase.substring(0,16));
  final encrypted = Encrypted.fromBase64(encoded);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
  final decrypted = encrypter.decrypt(encrypted, iv: iv);

  return decrypted;
}