import 'package:flutter/material.dart';

class LineChart extends StatelessWidget {
  const LineChart(this.data, {super.key});
  final LineChartData data;

  @override
  Widget build(final BuildContext context) => const SizedBox.shrink();
}

class LineChartData {
  const LineChartData({
    required this.gridData,
    required this.titlesData,
    required this.borderData,
    required this.lineBarsData,
  });
  final FlGridData gridData;
  final FlTitlesData titlesData;
  final FlBorderData borderData;
  final List<LineChartBarData> lineBarsData;
}

class FlGridData {
  const FlGridData({required this.show});
  final bool show;
}

class FlTitlesData {
  const FlTitlesData({
    required this.show,
    this.rightTitles,
    this.topTitles,
    this.bottomTitles,
    this.leftTitles,
  });
  final bool show;
  final AxisTitles? rightTitles;
  final AxisTitles? topTitles;
  final AxisTitles? bottomTitles;
  final AxisTitles? leftTitles;
}

class FlBorderData {
  const FlBorderData({required this.show});
  final bool show;
}

class LineChartBarData {
  const LineChartBarData({
    required this.spots,
    required this.color,
    required this.dotData,
    this.isCurved = false,
    this.barWidth = 2,
  });
  final List<FlSpot> spots;
  final bool isCurved;
  final Color color;
  final double barWidth;
  final FlDotData dotData;
}

class FlDotData {
  const FlDotData({required this.show});
  final bool show;
}

class FlSpot {
  const FlSpot(this.x, this.y);
  final double x;
  final double y;
}

// Pie chart stubs
class PieChart extends StatelessWidget {
  const PieChart(this.data, {super.key});
  final PieChartData data;

  @override
  Widget build(final BuildContext context) => const SizedBox.shrink();
}

class PieChartData {
  const PieChartData({required this.sections, this.centerSpaceRadius});
  final List<PieChartSectionData> sections;
  final double? centerSpaceRadius;
}

class PieChartSectionData {
  const PieChartSectionData({
    required this.value,
    this.title,
    this.color,
    this.radius,
  });
  final double value;
  final String? title;
  final Color? color;
  final double? radius;
}

// Bar chart stubs
enum BarChartAlignment { spaceAround }

class BarChart extends StatelessWidget {
  const BarChart(this.data, {super.key});
  final BarChartData data;

  @override
  Widget build(final BuildContext context) => const SizedBox.shrink();
}

class BarChartData {
  const BarChartData({
    this.alignment,
    this.maxY,
    this.barTouchData,
    this.titlesData,
    this.borderData,
    this.barGroups,
  });
  final BarChartAlignment? alignment;
  final double? maxY;
  final BarTouchData? barTouchData;
  final FlTitlesData? titlesData;
  final FlBorderData? borderData;
  final List<BarChartGroupData>? barGroups;
}

class BarTouchData {
  const BarTouchData({this.enabled = true});
  final bool enabled;
}

class BarChartGroupData {
  const BarChartGroupData({required this.x, required this.barRods});
  final int x;
  final List<BarChartRodData> barRods;
}

class BarChartRodData {
  const BarChartRodData({required this.toY, this.color, this.width});
  final double toY;
  final Color? color;
  final double? width;
}

class AxisTitles {
  const AxisTitles({required this.sideTitles});
  final SideTitles sideTitles;
}

class SideTitles {
  const SideTitles({
    this.showTitles = true,
    this.reservedSize,
    this.getTitlesWidget,
  });
  final bool showTitles;
  final double? reservedSize;
  final Widget Function(
    double,
  )? getTitlesWidget;
}
