import 'package:flutter/material.dart';
import 'dart:math';

import 'package:tinycolor2/tinycolor2.dart';

class ColorUtils {
  static const Color seedColor = Color(0xFFE3DAFF);
  static double _randomHue() {
    return Random().nextInt(360).toDouble();
  }

  static Color randomHueFromColor({Color color = seedColor}) {
    HSLColor hslColor = HSLColor.fromColor(color);

    HSLColor newColor = HSLColor.fromAHSL(
        1.0, _randomHue(), hslColor.saturation, hslColor.lightness);

    return newColor.toColor();
  }

  static Color darkenColor({required Color color, int level = 10}) {
    return TinyColor.fromColor(color).darken(level).color;
  }

  static List<Color> cardColors = [];
}
