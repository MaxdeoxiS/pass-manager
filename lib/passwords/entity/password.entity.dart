import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

@entity
class Password {
  @PrimaryKey(autoGenerate: true)
  final int id;

  String name;
  String login;
  String value;
  String url;
  String comment;
  Color color;
  DateTime updated;
  bool isFavorite;

  Password(this.name, this.login, this.value, this.url, this.comment, this.updated, [this.color, this.isFavorite = false, this.id]);
}