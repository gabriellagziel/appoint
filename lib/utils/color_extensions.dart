import 'package:flutter/material.dart';

extension ColorValues on Color {
  Color withValues({double? alpha, double? red, double? green, double? blue}) {
    final a = ((alpha ?? this.a) * 255).round() & 0xff;
    final r = ((red ?? this.r) * 255).round() & 0xff;
    final g = ((green ?? this.g) * 255).round() & 0xff;
    final b = ((blue ?? this.b) * 255).round() & 0xff;

    return Color.fromARGB(a, r, g, b);
  }
}
