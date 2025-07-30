import 'package:flutter/material.dart';

/// Minimal replacement for the old [ChartColor] class that was removed from
/// `fl_chart`. It simply wraps a [Color] so tests depending on the type still
/// compile.
class ChartColor {
  const ChartColor(this.color);
  final Color color;
}

/// Flutter 3.19 removed the `a`, `r`, `g`, and `b` getters from [Color] that
/// older versions of `fl_chart` rely on. Add shims so the package continues to
/// compile without modification.
extension ColorChannelShims on Color {
  // ignore: deprecated_member_use
  double get a => alpha / 255.0;
  // ignore: deprecated_member_use
  double get r => red / 255.0;
  // ignore: deprecated_member_use
  double get g => green / 255.0;
  // ignore: deprecated_member_use
  double get b => blue / 255.0;

  Color withValues({
    final double? alpha,
    final double? red,
    final double? green,
    double? blue,
  }) =>
      Color.fromARGB(
        (255 * (alpha ?? a)).round(),
        (255 * (red ?? r)).round(),
        (255 * (green ?? g)).round(),
        (255 * (blue ?? b)).round(),
      );
}

/// Adds missing color getters used by tests.
///
/// Recent versions of `fl_chart` removed the old `ChartColor.*` getters. Tests
/// still reference them, so this extension maps those getters to the
/// corresponding [Colors] constants.
extension ChartColorMaterialShim on ChartColor {
  static ChartColor get blue => const ChartColor(Colors.blue);
  static ChartColor get red => const ChartColor(Colors.red);
  static ChartColor get green => const ChartColor(Colors.green);
  static ChartColor get orange => const ChartColor(Colors.orange);
  static ChartColor get yellow => const ChartColor(Colors.yellow);
  static ChartColor get purple => const ChartColor(Colors.purple);
  static ChartColor get pink => const ChartColor(Colors.pink);
  static ChartColor get cyan => const ChartColor(Colors.cyan);
  static ChartColor get teal => const ChartColor(Colors.teal);
  static ChartColor get indigo => const ChartColor(Colors.indigo);
  static ChartColor get brown => const ChartColor(Colors.brown);
  static ChartColor get grey => const ChartColor(Colors.grey);
  static ChartColor get black => const ChartColor(Colors.black);
  static ChartColor get white => const ChartColor(Colors.white);
}
