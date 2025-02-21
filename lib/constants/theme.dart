import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class AppTheme {
  static ThemeData getTheme() {
    return ThemeData(
        scaffoldBackgroundColor: AppColors.containerColor,
        colorScheme: const ColorScheme.light(
          primary: AppColors.buttonColor,
          secondary: AppColors.secondaryColor,
          surface: AppColors.containerColor,
          // onPrimary: AppColors.textColor,
          // onSecondary: AppColors.textColor,
          // onSurface: AppColors.textColor,
        ),
        textTheme: fredokaOneTextTheme,
        useMaterial3: true

        // Add more theme properties as needed
        );
  }
}
