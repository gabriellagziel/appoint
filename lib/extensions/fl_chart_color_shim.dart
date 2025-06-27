import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
