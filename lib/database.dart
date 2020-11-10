// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:pass_manager/utils/datetime-converter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'passwords/dao/password.dao.dart';
import 'passwords/entity/password.entity.dart';

part 'database.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [Password])
abstract class AppDatabase extends FloorDatabase {
  PasswordDao get passwordDao;
}