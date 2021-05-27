import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:pass_manager/passwords/entity/category.entity.dart';

class CategoryConverter extends TypeConverter<Category?, String?> {
  @override
  Category? decode(String? name) {
    // Can't fetch real category asynchronously in converter so create a temporary category with no icon
    if (null != name) {
      return Category(name, 0);
    }
    return null;
  }

  @override
  String? encode(Category? category) {
    return category?.name ?? null;
  }
}