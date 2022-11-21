import 'package:encrypt/encrypt.dart';

class EncryptionService {
  static final _key = Key.fromUtf8('ss3ExBI6ggHzrWiZGJl0iAASIUX6uBzU');
  static final _iv = IV.fromUtf8('0000000000000000');

  static Future<String> encrypt(String variable) async {
    // log('IV: ${_iv.bytes}');
    final encryptor = Encrypter(AES(_key, mode: AESMode.cbc));
    final encrypted = encryptor.encrypt(variable, iv: _iv);
    // log('Encrypted: ${encrypted.base64}');
    return encrypted.base64;
  }
}
