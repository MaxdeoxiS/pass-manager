import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

import 'category.entity.dart';

@entity
class Password {
  @PrimaryKey(autoGenerate: true)
  int? id;

  String name;
  String login;
  String value;
  String? url;
  String? comment;
  Category? category;
  Color color;
  DateTime updated;
  bool isFavorite;

  Password(this.name, this.login, this.value, this.url, this.comment, this.updated, this.color, this.category, [this.isFavorite = false, this.id]);
}