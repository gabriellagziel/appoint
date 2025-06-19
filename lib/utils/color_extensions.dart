import 'package:flutter/material.dart';

extension ColorValues on Color {
  Color withValues({double? alpha, double? red, double? green, double? blue}) {
    final argb = value;
    final a = ((alpha ?? ((argb >> 24) & 0xff) / 255.0) * 255).round() & 0xff;
    final r = ((red ?? ((argb >> 16) & 0xff) / 255.0) * 255).round() & 0xff;
    final g = ((green ?? ((argb >> 8) & 0xff) / 255.0) * 255).round() & 0xff;
    final b = ((blue ?? (argb & 0xff) / 255.0) * 255).round() & 0xff;

    return Color.fromARGB(a, r, g, b);
  }
}
