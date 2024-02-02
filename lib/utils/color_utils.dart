import 'package:flutter/material.dart';
import 'dart:math';

class ColorUtils {
  static const Color seedColor = Color(0xFF41C88E);
  static double _randomHue() {
    return Random().nextInt(360).toDouble();
  }

  static Color randomHueFromColor({Color color = seedColor}) {
    HSLColor hslColor = HSLColor.fromColor(color);

    HSLColor newColor = HSLColor.fromAHSL(
        1.0, _randomHue(), hslColor.saturation, hslColor.lightness);

    return newColor.toColor();
  }

  static List<Color> cardColors = [];
}
