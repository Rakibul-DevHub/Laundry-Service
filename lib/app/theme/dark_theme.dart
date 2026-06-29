import 'package:flutter/material.dart';

import '../../core/config/colors.dart';
// import 'app_text_theme.dart';

/// [DarkTheme] change the color from light to dark if needed
class DarkTheme {
  DarkTheme._();
  static final ThemeData darkTheme = ThemeData(
    fontFamily: "outfit",
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
    ).copyWith(brightness: Brightness.dark),
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    // scaffoldBackgroundColor: AppColors.background,
    // textTheme: AppTextTheme.darkTextTheme,
  );
}
