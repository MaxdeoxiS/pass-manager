import 'package:floor/floor.dart';

@entity
class Password {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final String name;
  final String login;
  final String value;
  final String url;
  final String comment;

  Password(this.id, this.name, this.login, this.value, this.url, this.comment);
}