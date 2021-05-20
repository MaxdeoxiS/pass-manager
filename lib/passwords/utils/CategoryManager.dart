import 'package:pass_manager/passwords/entity/category.entity.dart';
import 'package:pass_manager/utils/database/database.helper.dart';

class PasswordManager {
  PasswordManager._privateConstructor();

  static final PasswordManager instance = PasswordManager._privateConstructor();

  final dbHelper = DatabaseHelper.instance;

  Future<void> addCategory({required String name, required String icon}) async {
    final categoryDao = await dbHelper.getCategoryDao();
    final Category category = new Category(name, icon);
    categoryDao.insertCategory(category);
  }

  Future<List<Category>> getCategories() async {
    final categoryDao = await dbHelper.getCategoryDao();
    List<Category> categories = await categoryDao.findAllCategories();
    return categories;
  }

  Future<int> updatePassword(Category category) async {
    final categoryDao = await dbHelper.getCategoryDao();
    return await categoryDao.updateCategory(category);
  }

  Future<void> deleteCategory(int id) async {
    final categoryDao = await dbHelper.getCategoryDao();
    categoryDao.deleteCategory(id);
  }
}