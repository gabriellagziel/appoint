import 'package:flutter/material.dart';

class AppTypography {
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 16,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: Colors.grey,
  );

  static const TextTheme textTheme = TextTheme(
    headlineLarge: headline1,
    headlineMedium: headline2,
    bodyMedium: bodyText,
    bodySmall: caption,
  );
}
