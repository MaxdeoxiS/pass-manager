import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

class ColorConverter extends TypeConverter<Color, int> {
  @override
  Color decode(int colorValue) {
    return Color(colorValue);
  }

  @override
  int encode(Color color) {
    return color.value;
  }
}