import 'package:floor/floor.dart';
import 'package:flutter/material.dart';

class ColorConverter extends TypeConverter<Color, int> {
  @override
  Color decode(int colorValue) {
    if (colorValue == 0) {
      return null;
    }
    return Color(colorValue);
  }

  @override
  int encode(Color color) {
    if (color == null) {
      return 0;
    }
    return color.value;
  }
}