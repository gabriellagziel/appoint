import 'package:flutter/material.dart';

/// Color tokens used throughout the app with light and dark variants.
class AppColors {
  AppColors._();

  static const Color seed = Color(0xFF6750A4);

  // Light scheme colors
  static const Color primaryLight = Color(0xFF6750A4);
  static const Color secondaryLight = Color(0xFF625B71);
  static const Color backgroundLight = Color(0xFFF8F7FA);
  static const Color surfaceLight = Colors.white;
  static const Color errorLight = Color(0xFFB3261E);

  // Dark scheme colors
  static const Color primaryDark = Color(0xFFD0BCFF);
  static const Color secondaryDark = Color(0xFFCCC2DC);
  static const Color backgroundDark = Color(0xFF1C1B1F);
  static const Color surfaceDark = Color(0xFF1C1B1F);
  static const Color errorDark = Color(0xFFF2B8B5);
}
