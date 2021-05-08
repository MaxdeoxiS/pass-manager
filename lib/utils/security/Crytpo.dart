import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Crypto {
  final FlutterSecureStorage storage = new FlutterSecureStorage();
  IV iv = IV.fromLength(16);
  Encrypter? encryptor;

  static final Crypto _instance = Crypto._internal();

  factory Crypto() {
    return _instance;
  }

  Crypto._internal();

  Future<String> encrypt(String valueToEncrypt) async {
    final encryptor = await getEncryptor();
    final encrypted = encryptor.encrypt(valueToEncrypt, iv: iv);

    return encrypted.base64;
  }

  Future<String> decrypt(String valueToDecrypt) async {
    final encryptor = await getEncryptor();
    final decrypted = encryptor.decrypt(Encrypted.from64(valueToDecrypt), iv: iv);

    return decrypted;
  }

  Future<Encrypter> getEncryptor() async {
    if (null == this.encryptor) {
      String stringKey = (await storage.read(key: 'privateKey'))!;
      final key = Key.fromUtf8(stringKey);
      this.encryptor = Encrypter(AES(key));
    }
    return this.encryptor!;
  }
}