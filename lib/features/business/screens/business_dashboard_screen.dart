import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:appoint/models/business_analytics.dart';
import 'package:appoint/providers/business_analytics_provider.dart';

class BusinessDashboardScreen extends ConsumerWidget {
  const BusinessDashboardScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingsOverTimeProvider);
    final servicesAsync = ref.watch(serviceDistributionProvider);
    final revenueAsync = ref.watch(revenueByStaffProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Business Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            bookingsAsync.when(
              data: (final data) => _buildBookingsChart(context, data),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (final e, final _) => Text('Error: $e'),
            ),
            const SizedBox(height: 24),
            servicesAsync.when(
              data: _buildServiceDistributionChart,
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (final e, final _) => Text('Error: $e'),
            ),
            const SizedBox(height: 24),
            revenueAsync.when(
              data: (final data) => _buildRevenueByStaffChart(context, data),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (final e, final _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsChart(final BuildContext context, final List<TimeSeriesPoint> data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bookings Over Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(show: true),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data
                          .map((final e) => FlSpot(
                              e.date.millisecondsSinceEpoch.toDouble(),
                              e.count.toDouble()))
                          .toList(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
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

  Widget _buildServiceDistributionChart(final List<ServiceDistribution> data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Service Distribution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 40,
                  sections: data.asMap().entries.map((final entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return PieChartSectionData(
                      value: item.bookings.toDouble(),
                      title: item.service,
                      color: Colors.primaries[index % Colors.primaries.length],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueByStaffChart(
      final BuildContext context, final List<RevenueByStaff> data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue by Staff',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: data.asMap().entries.map((final entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.revenue,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
