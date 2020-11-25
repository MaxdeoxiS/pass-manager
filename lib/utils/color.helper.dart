import 'package:flutter/material.dart';

class ColorHelper {
  static Color getTextContrastedColor(Color backgroundColor) {
    int d = 0;

    // Counting the perceptive luminance - human eye favors green color... 
    double luminance = ( 0.299 * backgroundColor.red + 0.587 * backgroundColor.green + 0.114 * backgroundColor.blue)/255;

    if (luminance > 0.5)
      d = 0; // bright colors - black font
    else
      d = 255; // dark colors - white font

    return Color.fromARGB(255, d, d, d);
  }
}