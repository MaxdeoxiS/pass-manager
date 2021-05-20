import 'package:floor/floor.dart';

@entity
class Category {
  @PrimaryKey(autoGenerate: true)
  int? id;

  String name;
  String icon;

  Category(this.name, this.icon, [this.id]);
}