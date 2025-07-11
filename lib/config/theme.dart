import 'package:appoint/theme/app_colors.dart';
import 'package:appoint/theme/typography.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Color constants centralized in [AppColors]
  static const Color primaryColor = AppColors.primary;
  static const Color secondaryColor = AppColors.secondary;
  static const Color accentColor = Colors.orange;
  static const Color backgroundColor = AppColors.background;
  static const Color surfaceColor = Colors.grey;
  static const Color errorColor = AppColors.error;

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.background,
      error: AppColors.error,
    ),
    textTheme: AppTypography.textTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.background,
      error: AppColors.error,
    ),
    textTheme: AppTypography.textTheme,
  );
}
