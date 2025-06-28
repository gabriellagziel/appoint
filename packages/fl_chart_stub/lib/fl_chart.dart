import 'package:flutter/material.dart';

class LineChart extends StatelessWidget {
  final LineChartData data;
  const LineChart(this.data, {super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class LineChartData {
  final FlGridData gridData;
  final FlTitlesData titlesData;
  final FlBorderData borderData;
  final List<LineChartBarData> lineBarsData;
  const LineChartData({
    required this.gridData,
    required this.titlesData,
    required this.borderData,
    required this.lineBarsData,
  });
}

class FlGridData {
  final bool show;
  const FlGridData({required this.show});
}

class FlTitlesData {
  final bool show;
  final AxisTitles? rightTitles;
  final AxisTitles? topTitles;
  final AxisTitles? bottomTitles;
  final AxisTitles? leftTitles;
  const FlTitlesData({
    required this.show,
    this.rightTitles,
    this.topTitles,
    this.bottomTitles,
    this.leftTitles,
  });
}

class FlBorderData {
  final bool show;
  const FlBorderData({required this.show});
}

class LineChartBarData {
  final List<FlSpot> spots;
  final bool isCurved;
  final Color color;
  final double barWidth;
  final FlDotData dotData;
  const LineChartBarData({
    required this.spots,
    this.isCurved = false,
    required this.color,
    this.barWidth = 2,
    required this.dotData,
  });
}

class FlDotData {
  final bool show;
  const FlDotData({required this.show});
}

class FlSpot {
  final double x;
  final double y;
  const FlSpot(this.x, this.y);
}
// Pie chart stubs
class PieChart extends StatelessWidget {
  final PieChartData data;
  const PieChart(this.data, {super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class PieChartData {
  final List<PieChartSectionData> sections;
  final double? centerSpaceRadius;
  const PieChartData({required this.sections, this.centerSpaceRadius});
}

class PieChartSectionData {
  final double value;
  final String? title;
  final Color? color;
  final double? radius;
  const PieChartSectionData({
    required this.value,
    this.title,
    this.color,
    this.radius,
  });
}

// Bar chart stubs
enum BarChartAlignment { spaceAround }

class BarChart extends StatelessWidget {
  final BarChartData data;
  const BarChart(this.data, {super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class BarChartData {
  final BarChartAlignment? alignment;
  final double? maxY;
  final BarTouchData? barTouchData;
  final FlTitlesData? titlesData;
  final FlBorderData? borderData;
  final List<BarChartGroupData>? barGroups;
  const BarChartData({
    this.alignment,
    this.maxY,
    this.barTouchData,
    this.titlesData,
    this.borderData,
    this.barGroups,
  });
}

class BarTouchData {
  final bool enabled;
  const BarTouchData({this.enabled = true});
}

class BarChartGroupData {
  final int x;
  final List<BarChartRodData> barRods;
  const BarChartGroupData({required this.x, required this.barRods});
}

class BarChartRodData {
  final double toY;
  final Color? color;
  final double? width;
  const BarChartRodData({required this.toY, this.color, this.width});
}

class AxisTitles {
  final SideTitles sideTitles;
  const AxisTitles({required this.sideTitles});
}

class SideTitles {
  final bool showTitles;
  final double? reservedSize;
  final Widget Function(double, dynamic)? getTitlesWidget;
  const SideTitles({this.showTitles = true, this.reservedSize, this.getTitlesWidget});
}
