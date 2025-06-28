import 'package:flutter/material.dart';

/// Minimal replacement for the old [ChartColor] class that was removed from
/// `fl_chart`. It simply wraps a [Color] so tests depending on the type still
/// compile.
class ChartColor {
  final Color color;
  const ChartColor(this.color);
}

/// Flutter 3.19 removed the `a`, `r`, `g`, and `b` getters from [Color] that
/// older versions of `fl_chart` rely on. Add shims so the package continues to
/// compile without modification.
extension ColorChannelShims on Color {
  double get a => alpha / 255.0;
  double get r => red / 255.0;
  double get g => green / 255.0;
  double get b => blue / 255.0;

  Color withValues({double? alpha, double? red, double? green, double? blue}) {
    return Color.fromARGB(
      (255 * (alpha ?? a)).round(),
      (255 * (red ?? r)).round(),
      (255 * (green ?? g)).round(),
      (255 * (blue ?? b)).round(),
    );
  }
}

/// Adds missing color getters used by tests.
///
/// Recent versions of `fl_chart` removed the old `ChartColor.*` getters. Tests
/// still reference them, so this extension maps those getters to the
/// corresponding [Colors] constants.
extension ChartColorMaterialShim on ChartColor {
  static ChartColor get blue => ChartColor(Colors.blue);
  static ChartColor get red => ChartColor(Colors.red);
  static ChartColor get green => ChartColor(Colors.green);
  static ChartColor get orange => ChartColor(Colors.orange);
  static ChartColor get yellow => ChartColor(Colors.yellow);
  static ChartColor get purple => ChartColor(Colors.purple);
  static ChartColor get pink => ChartColor(Colors.pink);
  static ChartColor get cyan => ChartColor(Colors.cyan);
  static ChartColor get teal => ChartColor(Colors.teal);
  static ChartColor get indigo => ChartColor(Colors.indigo);
  static ChartColor get brown => ChartColor(Colors.brown);
  static ChartColor get grey => ChartColor(Colors.grey);
  static ChartColor get black => ChartColor(Colors.black);
  static ChartColor get white => ChartColor(Colors.white);
}
