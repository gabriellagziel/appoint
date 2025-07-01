import 'package:flutter/material.dart';

import 'package:appoint/theme/app_text_styles.dart';

/// Application theme built with Material 3 color schemes.
class AppTheme {
  static ThemeData lightTheme(final Color seedColor) =>
      _buildTheme(seedColor: seedColor, brightness: Brightness.light);

  static ThemeData darkTheme(final Color seedColor) =>
      _buildTheme(seedColor: seedColor, brightness: Brightness.dark);

  static ThemeData fromSeed(final Color seedColor,
          {final Brightness brightness = Brightness.light}) =>
      _buildTheme(seedColor: seedColor, brightness: brightness);

  static ThemeData _buildTheme({
    required final Color seedColor,
    required final Brightness brightness,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      textTheme: const TextTheme(
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
