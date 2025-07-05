import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:appoint/models/admin_dashboard_stats.dart';

class RevenuePieChart extends StatelessWidget {
  final AdminDashboardStats stats;

  const RevenuePieChart({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: stats.adRevenue,
                      title:
                          'Ad Revenue\n\$${stats.adRevenue.toStringAsFixed(2)}',
                      color: Colors.blue,
                      radius: 60,
                    ),
                    PieChartSectionData(
                      value: stats.subscriptionRevenue,
                      title:
                          'Subscriptions\n\$${stats.subscriptionRevenue.toStringAsFixed(2)}',
                      color: Colors.green,
                      radius: 60,
                    ),
                  ],
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
