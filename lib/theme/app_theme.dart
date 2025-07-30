import 'package:appoint/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Application theme built with Material 3 color schemes.
class AppTheme {
  static ThemeData lightTheme(Color seedColor) =>
      _buildTheme(seedColor: seedColor, brightness: Brightness.light);

  static ThemeData darkTheme(Color seedColor) =>
      _buildTheme(seedColor: seedColor, brightness: Brightness.dark);

  static ThemeData fromSeed(
    final Color seedColor, {
    Brightness brightness = Brightness.light,
  }) =>
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
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
