// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:pass_manager/passwords/dao/category.dao.dart';
import 'package:pass_manager/passwords/entity/category.entity.dart';
import 'package:pass_manager/utils/database/converter/color-converter.dart';
import 'package:pass_manager/utils/database/converter/datetime-converter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../../passwords/dao/password.dao.dart';
import '../../passwords/entity/password.entity.dart';
import 'converter/category-converter.dart';

part 'database.g.dart'; // the generated code will be there

// For custom types
@TypeConverters([DateTimeConverter, ColorConverter, CategoryConverter])
// Switch version when model changes
@Database(version: 1, entities: [Password, Category])
abstract class AppDatabase extends FloorDatabase {
  PasswordDao get passwordDao;
  CategoryDao get categoryDao;
}