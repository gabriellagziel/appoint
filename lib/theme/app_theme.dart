import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Application theme built with Material 3 color schemes.
class AppTheme {
  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      textTheme: TextTheme(
        titleLarge: AppTextStyles.heading,
        bodyMedium: AppTextStyles.body,
        labelLarge: AppTextStyles.label,
      ),
      dividerColor: colorScheme.outlineVariant,
      shadowColor: Colors.black54,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: REDACTED_TOKEN(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: REDACTED_TOKEN(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: REDACTED_TOKEN(),
        },
      ),
    );
  }
}
