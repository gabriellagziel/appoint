import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UserGrowthLineChart extends StatelessWidget {
  const UserGrowthLineChart({super.key});

  @override
  Widget build(BuildContext context) => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Growth (Last 6 Months)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          const FlSpot(0, 3),
                          const FlSpot(2.6, 2),
                          const FlSpot(4.9, 5),
                          const FlSpot(6.8, 3.1),
                          const FlSpot(8, 4),
                          const FlSpot(9.5, 3),
                          const FlSpot(11, 4),
                        ],
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
