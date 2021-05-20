import 'package:pass_manager/passwords/dao/category.dao.dart';
import 'package:pass_manager/passwords/dao/password.dao.dart';
import 'package:pass_manager/passwords/entity/category.entity.dart';

import 'database.dart';

class DatabaseHelper {

  static final _databaseName = "pass_manager.db";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static  AppDatabase? _database;
  Future<AppDatabase> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await $FloorAppDatabase.databaseBuilder(_databaseName).build();
    return _database!;
  }

  Future<PasswordDao> getPasswordDao() async {
    AppDatabase db = await instance.database;
    return db.passwordDao;
  }

  Future<CategoryDao> getCategoryDao() async {
    AppDatabase db = await instance.database;
    return db.categoryDao;
  }
}