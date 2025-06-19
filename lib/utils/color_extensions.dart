import 'package:flutter/material.dart';

extension ColorValues on Color {
  Color withValues({double? alpha, double? red, double? green, double? blue}) {
    final color = this;
    final a = ((alpha ?? color.alpha) * 255.0).round() & 0xff;
    final r = ((red ?? color.red) * 255.0).round() & 0xff;
    final g = ((green ?? color.green) * 255.0).round() & 0xff;
    final b = ((blue ?? color.blue) * 255.0).round() & 0xff;

    return Color.fromARGB(a, r, g, b);
  }
}
