import 'package:floor/floor.dart';
import 'package:pass_manager/passwords/entity/password.entity.dart';

@dao
abstract class PasswordDao {
  @Query('SELECT * FROM Password')
  Future<List<Password>> findAllPasswords();

  @Query('SELECT * FROM Password WHERE id = :id')
  Stream<Password> findPasswordById(int id);

  @insert
  Future<void> insertPassword(Password password);

  @update
  Future<void> updatePassword(Password password);

  @delete
  Future<void> deletePassword(Password password);
}