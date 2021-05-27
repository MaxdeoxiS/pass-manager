import 'dart:ui';

import 'package:pass_manager/passwords/entity/category.entity.dart';
import 'package:pass_manager/passwords/entity/password.entity.dart';
import 'package:pass_manager/utils/database/database.helper.dart';
import 'package:pass_manager/utils/security/Crypto.dart';

import 'CategoryManager.dart';

class PasswordManager {
  PasswordManager._privateConstructor();

  static final PasswordManager instance = PasswordManager._privateConstructor();

  final dbHelper = DatabaseHelper.instance;

  final crypto = Crypto();

  Future<void> addPassword(
      {required String login,
      required String value,
      required String name,
      String? url,
      String? comment,
      Category? category,
      required Color color,
      required bool isFavorite}) async {
    final passwordDao = await dbHelper.getPasswordDao();
    final encryptedLogin = await crypto.encrypt(login);
    final encryptedPassword = await crypto.encrypt(value);
    print(category);
    final Password password =
        new Password(name, encryptedLogin, encryptedPassword, url, comment, DateTime.now(), color, category, isFavorite);
    passwordDao.insertPassword(password);
  }

  Future<Password?> getPassword(int id) async {
    final passwordDao = await dbHelper.getPasswordDao();
    return await passwordDao.findPasswordById(id);
  }

  Future<List<Password>> getPasswords() async {
    final passwordDao = await dbHelper.getPasswordDao();
    final _categoryManager = CategoryManager.instance;
    List<Password> passwords = await passwordDao.findAllPasswords();
    passwords.forEach((p) async => {
      p.login = await crypto.decrypt(p.login),
      p.value = await crypto.decrypt(p.value),
      // if (null != p.category && null != p.category?.name) {
      //   p.category = await _categoryManager.getCategory(p.category?.name)
      // }
      p.category = (null != p.category?.name) ? await _categoryManager.getCategory(p.category?.name) : null
    });
    return passwords;
  }

  Future<int> updatePassword(Password password) async {
    final passwordDao = await dbHelper.getPasswordDao();
    password.login = await crypto.encrypt(password.login);
    password.value = await crypto.encrypt(password.value);
    return await passwordDao.updatePassword(password);
  }

  Future<int> toggleFavorite(Password password) async {
    password.isFavorite = !password.isFavorite;
    return this.updatePassword(password);
  }

  Future<void> deletePassword(int id) async {
    final passwordDao = await dbHelper.getPasswordDao();
    passwordDao.deletePassword(id);
  }
}
