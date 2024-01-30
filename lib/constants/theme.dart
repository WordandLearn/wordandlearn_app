import 'package:flutter/material.dart';
import 'package:word_and_learn/constants/constants.dart';

class AppTheme {
  static ThemeData getTheme() {
    return ThemeData(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryColor,
          secondary: AppColors.secondaryColor,
          background: AppColors.backgroundColor,
          surface: AppColors.containerColor,
          onPrimary: AppColors.textColor,
          onSecondary: AppColors.textColor,
          onBackground: AppColors.textColor,
        ),
        textTheme: fredokaOneTextTheme,
        useMaterial3: true

        // Add more theme properties as needed
        );
  }
}
