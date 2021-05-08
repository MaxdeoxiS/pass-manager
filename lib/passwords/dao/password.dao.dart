// @dart=2.12
import 'package:floor/floor.dart';
import 'package:pass_manager/passwords/entity/password.entity.dart';

@dao
abstract class PasswordDao {
  @Query('SELECT * FROM Password')
  Future<List<Password>> findAllPasswords();

  @Query('SELECT * FROM Password WHERE id = :id')
  Future<Password?> findPasswordById(int id);

  @insert
  Future<int> insertPassword(Password password);

  @update
  Future<int> updatePassword(Password password);

  @Query('DELETE FROM Password WHERE id = :id')
  Future<void> deletePassword(int id);
}