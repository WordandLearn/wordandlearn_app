import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:word_and_learn/utils/color_utils.dart';

class ColorModel {
  Color? color;

  Color get colorValue {
    if (color != null) {
      return color!;
    } else {
      color = ColorUtils.randomHueFromColor();
      return color!;
    }
  }

  Color get darkerColor {
    return TinyColor.fromColor(colorValue).darken(10).color;
  }
}
