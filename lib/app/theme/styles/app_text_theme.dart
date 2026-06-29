import 'package:flutter/material.dart';

import '../../../core/config/colors.dart';
import '../../../core/config/sizes.dart';

class AppTextTheme {
  AppTextTheme._();
  static const TextTheme lightTextTheme = TextTheme(
    // display text theme
    // displayLarge: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold, color: AppColors.title),
    displaySmall: TextStyle(
      fontSize: AppSizes.fontSizeL,
      fontWeight: FontWeight.w600,
      color: AppColors.title,
    ),

    // headline text theme
    headlineLarge: TextStyle(
      fontSize: AppSizes.fontSizeH1,
      fontWeight: FontWeight.w500,
      color: AppColors.title,
    ),
    headlineMedium: TextStyle(
      fontSize: AppSizes.fontSizeH2,
      fontWeight: FontWeight.w500,
      color: AppColors.title,
    ),
    // headlineSmall: TextStyle(fontSize: AppSizes.fontSizeH3, fontWeight: FontWeight.w500, color: AppColors.title),

    // body text theme
    bodyLarge: TextStyle(
      fontSize: AppSizes.fontSizeBodyL,
      fontWeight: FontWeight.w400,
      color: AppColors.title,
    ),
    bodyMedium: TextStyle(
      fontSize: AppSizes.fontSizeBodyM,
      fontWeight: FontWeight.w400,
      color: AppColors.title,
    ),
    bodySmall: TextStyle(
      fontSize: AppSizes.fontSizeBodyS,
      fontWeight: FontWeight.w400,
      color: AppColors.title,
    ),

    // label text theme
    // labelLarge: TextStyle(fontSize: AppSizes.fontSizeBtn, fontWeight: FontWeight.w500, color: AppColors.title),
  );

  static const TextTheme darkTextTheme = TextTheme(
    // display text theme
    // displayLarge: TextStyle(fontSize: AppSizes.fontSizeXl, fontWeight: FontWeight.bold, color: AppColors.title),
    displaySmall: TextStyle(
      fontSize: AppSizes.fontSizeL,
      fontWeight: FontWeight.w600,
      color: AppColors.title,
    ),

    // headline text theme
    headlineLarge: TextStyle(
      fontSize: AppSizes.fontSizeH1,
      fontWeight: FontWeight.w500,
      color: AppColors.title,
    ),
    headlineMedium: TextStyle(
      fontSize: AppSizes.fontSizeH2,
      fontWeight: FontWeight.w500,
      color: AppColors.title,
    ),
    // headlineSmall: TextStyle(fontSize: AppSizes.fontSizeH3, fontWeight: FontWeight.w500, color: AppColors.title),

    // body text theme
    bodyLarge: TextStyle(
      fontSize: AppSizes.fontSizeBodyL,
      fontWeight: FontWeight.w400,
      color: AppColors.title,
    ),
    bodyMedium: TextStyle(
      fontSize: AppSizes.fontSizeBodyM,
      fontWeight: FontWeight.w400,
      color: AppColors.title,
    ),
    bodySmall: TextStyle(
      fontSize: AppSizes.fontSizeBodyS,
      fontWeight: FontWeight.w400,
      color: AppColors.title,
    ),

    // label text theme
    // labelLarge: TextStyle(fontSize: AppSizes.fontSizeBtn, fontWeight: FontWeight.w500, color: AppColors.title),
  );
}
