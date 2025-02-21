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
      return color!; //Returns a random color
    }
  }

  Color get darkerColor {
    return TinyColor.fromColor(colorValue).darken(10).color;
  }

  Color get darkerTextColor {
    //Generates a color depending on the color value that passes accecisbility test, not black or white, just darker colorvalue or lighter
    return TinyColor.fromColor(colorValue).isLight()
        ? TinyColor.fromColor(colorValue).darken(50).color
        : TinyColor.fromColor(colorValue).lighten(50).color;
  }
}
