import 'package:flutter/material.dart';

extension ColorValues on Color {
  /// Returns a copy of this [Color] with the provided channel values replaced.
  ///
  /// Each parameter expects a value in the range `0.0`–`1.0`. When a parameter
  /// is omitted the current channel value is used.
  Color withValues({
    final double? alpha,
    final double? red,
    final double? green,
    double? blue,
  }) {
    int toInt(double value) => (value.clamp(0.0, 1.0) * 255.0).round() & 0xff;

    return Color.fromARGB(
      toInt(alpha ?? (this.alpha / 255.0)), // ignore: deprecated_member_use
      toInt(red ?? (this.red / 255.0)), // ignore: deprecated_member_use
      toInt(green ?? (this.green / 255.0)), // ignore: deprecated_member_use
      toInt(blue ?? (this.blue / 255.0)), // ignore: deprecated_member_use
    );
  }
}

extension BuildContextColorTheme on BuildContext {
  /// Shorthand access to the current [ColorScheme].
  ColorScheme get colorTheme => Theme.of(this).colorScheme;
}
