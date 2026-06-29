import 'package:flutter/material.dart';

import '../../core/config/colors.dart';
// import 'app_text_theme.dart';

class LightTheme {
  LightTheme._();
  static final ThemeData lightTheme = ThemeData(
    fontFamily: "outfit",
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
    ).copyWith(brightness: Brightness.light),
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    // scaffoldBackgroundColor: AppColors.background,
    // textTheme: AppTextTheme.lightTextTheme,
  );
}
