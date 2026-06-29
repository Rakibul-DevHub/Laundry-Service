import 'package:flutter/material.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

class AppTheme{
  AppTheme._();
  static ThemeData getTheme(ThemeMode themeMode) {
    if (themeMode == ThemeMode.dark) {
      return DarkTheme.darkTheme;
    } else if (themeMode == ThemeMode.light) {
      return LightTheme.lightTheme;
    }
    return LightTheme.lightTheme;
  }
}