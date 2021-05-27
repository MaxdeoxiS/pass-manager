// @dart=2.12
import 'package:floor/floor.dart';
import 'package:pass_manager/passwords/entity/category.entity.dart';

@dao
abstract class CategoryDao {
  @Query('SELECT * FROM Category')
  Future<List<Category>> findAllCategories();

  @Query('SELECT * FROM Category WHERE id = :id')
  Future<Category?> findCategoryById(int id);

  @Query('SELECT * FROM Category WHERE name = :name')
  Future<Category?> findCategoryByName(String name);

  @insert
  Future<void> insertCategory(Category category);

  @update
  Future<int> updateCategory(Category category);

  @Query('DELETE FROM Category WHERE id = :id')
  Future<void> deleteCategory(int id);
}