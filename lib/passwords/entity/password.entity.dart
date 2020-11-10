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
  final String color;
  final DateTime updated;

  Password(this.id, this.name, this.login, this.value, this.url, this.comment, this.color, this.updated);
}