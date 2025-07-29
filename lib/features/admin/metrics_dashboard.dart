// ignore_for_file: prefer_const_constructors
import 'package:appoint/services/analytics_service.dart';
import 'package:appoint/utils/admin_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Admin metrics dashboard widget displaying key performance indicators
class AdminMetricsDashboard extends ConsumerStatefulWidget {
  const AdminMetricsDashboard({super.key});

  @override
  ConsumerState<AdminMetricsDashboard> createState() =>
      _AdminMetricsDashboardState();
}

class _AdminMetricsDashboardState extends ConsumerState<AdminMetricsDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final AnalyticsService _analyticsService = AnalyticsService();

  @override
  void initState() {
    super.initState();
    final tabController = TabController(length: 4, vsync: this);
    _loadMetrics();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMetrics() async {
    // Track dashboard view
    await _analyticsService.trackFeatureUsage(
      featureName: 'admin_metrics_dashboard',
      screenName: 'AdminMetricsDashboard',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AdminLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminMetrics),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: l10n.overview),
            Tab(text: l10n.bookings),
            Tab(text: l10n.users),
            Tab(text: l10n.revenue),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildBookingsTab(),
          _buildUsersTab(),
          _buildRevenueTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildKPICards(),
            const SizedBox(height: 24),
            _buildRecentActivityChart(),
            const SizedBox(height: 24),
            _buildSystemHealthWidget(),
          ],
        ),
      );

  Widget _buildKPICards() => GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
        children: [
          _buildKPICard(
            title: 'Total Users',
            value: '12,847',
            change: '+12.5%',
            isPositive: true,
            icon: Icons.people,
            color: Colors.blue,
          ),
          _buildKPICard(
            title: 'Active Bookings',
            value: '1,234',
            change: '+8.2%',
            isPositive: true,
            icon: Icons.calendar_today,
            color: Colors.green,
          ),
          _buildKPICard(
            title: 'Revenue (MTD)',
            value: r'$45,678',
            change: '+15.3%',
            isPositive: true,
            icon: Icons.attach_money,
            color: Colors.orange,
          ),
          _buildKPICard(
            title: 'Conversion Rate',
            value: '23.4%',
            change: '-2.1%',
            isPositive: false,
            icon: Icons.trending_up,
            color: Colors.purple,
          ),
        ],
      );

  Widget _buildKPICard({
    required final String title,
    required final String value,
    required final String change,
    required final bool isPositive,
    required final IconData icon,
    required final Color color,
  }) =>
      Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 24),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPositive
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive ? Icons.trending_up : Icons.trending_down,
                          color: isPositive ? Colors.green : Colors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          change,
                          style: TextStyle(
                            color: isPositive ? Colors.green : Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildRecentActivityChart() => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent Activity (Last 7 Days)',
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
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: true, reservedSize: 40),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, final meta) {
                            const days = [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun',
                            ];
                            if (value.toInt() >= 0 &&
                                value.toInt() < days.length) {
                              return Text(days[value.toInt()]);
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          const FlSpot(0, 3),
                          const FlSpot(1, 5),
                          const FlSpot(2, 4),
                          const FlSpot(3, 7),
                          const FlSpot(4, 6),
                          const FlSpot(5, 8),
                          const FlSpot(6, 9),
                        ],
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildSystemHealthWidget() => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'System Health',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildHealthIndicator('API Response Time', '120ms', Colors.green),
              _buildHealthIndicator(
                  'Database Performance', '95%', Colors.green),
              _buildHealthIndicator('Server Uptime', '99.9%', Colors.green),
              _buildHealthIndicator('Error Rate', '0.1%', Colors.green),
            ],
          ),
        ),
      );

  Widget _buildHealthIndicator(
    String label,
    final String value,
    final Color color,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label)),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      );

  Widget _buildBookingsTab() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookingMetrics(),
            const SizedBox(height: 24),
            _buildBookingTrendsChart(),
            const SizedBox(height: 24),
            _buildTopServicesWidget(),
          ],
        ),
      );

  Widget _buildBookingMetrics() => Row(
        children: [
          Expanded(
            child: _buildMetricCard(
              title: 'Total Bookings',
              value: '2,847',
              subtitle: 'This month',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildMetricCard(
              title: 'Completed',
              value: '2,123',
              subtitle: '74.6%',
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildMetricCard(
              title: 'Cancelled',
              value: '156',
              subtitle: '5.5%',
            ),
          ),
        ],
      );

  Widget _buildMetricCard({
    required final String title,
    required final String value,
    required final String subtitle,
  }) =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildBookingTrendsChart() => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Booking Trends',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, final meta) {
                            const months = <String>[
                              'Jan',
                              'Feb',
                              'Mar',
                              'Apr',
                              'May',
                              'Jun',
                            ];
                            if (value.toInt() >= 0 &&
                                value.toInt() < months.length) {
                              return Text(months[value.toInt()]);
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, final meta) =>
                              Text('${value.toInt()}'),
                        ),
                      ),
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(toY: 65, color: Colors.blue),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(toY: 72, color: Colors.blue),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(toY: 58, color: Colors.blue),
                        ],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(toY: 85, color: Colors.blue),
                        ],
                      ),
                      BarChartGroupData(
                        x: 4,
                        barRods: [
                          BarChartRodData(toY: 91, color: Colors.blue),
                        ],
                      ),
                      BarChartGroupData(
                        x: 5,
                        barRods: [
                          BarChartRodData(toY: 78, color: Colors.blue),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildTopServicesWidget() => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Top Services',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildServiceItem('Childcare', 456, 0.32),
              _buildServiceItem('Tutoring', 234, 0.16),
              _buildServiceItem('Playtime', 189, 0.13),
              _buildServiceItem('Family Support', 156, 0.11),
              _buildServiceItem('Special Needs', 123, 0.09),
            ],
          ),
        ),
      );

  Widget _buildServiceItem(
    String name,
    final int bookings,
    final double percentage,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(name),
            ),
            Expanded(
              child: Text(
                bookings.toString(),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Text(
                '${(percentage * 100).toStringAsFixed(1)}%',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      );

  Widget _buildUsersTab() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserGrowthChart(),
            const SizedBox(height: 24),
            _buildUserDemographics(),
          ],
        ),
      );

  Widget _buildUserGrowthChart() => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Growth',
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
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: true, reservedSize: 40),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, final meta) {
                            const months = <String>[
                              'Jan',
                              'Feb',
                              'Mar',
                              'Apr',
                              'May',
                              'Jun',
                            ];
                            if (value.toInt() >= 0 &&
                                value.toInt() < months.length) {
                              return Text(months[value.toInt()]);
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          const FlSpot(0, 8000),
                          const FlSpot(1, 8500),
                          const FlSpot(2, 9200),
                          const FlSpot(3, 9800),
                          const FlSpot(4, 10500),
                          const FlSpot(5, 11200),
                        ],
                        isCurved: true,
                        color: Colors.green,
                        barWidth: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildUserDemographics() => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'User Demographics',
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
                        value: 45,
                        title: '45%',
                        color: Colors.blue,
                        radius: 60,
                      ),
                      PieChartSectionData(
                        value: 30,
                        title: '30%',
                        color: Colors.green,
                        radius: 60,
                      ),
                      PieChartSectionData(
                        value: 25,
                        title: '25%',
                        color: Colors.orange,
                        radius: 60,
                      ),
                    ],
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildLegendItem('Families (45%)', Colors.blue),
              _buildLegendItem('Studios (30%)', Colors.green),
              _buildLegendItem('Ambassadors (25%)', Colors.orange),
            ],
          ),
        ),
      );

  Widget _buildLegendItem(String label, final Color color) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      );

  Widget _buildRevenueTab() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRevenueOverview(),
            const SizedBox(height: 24),
            _buildRevenueChart(),
            const SizedBox(height: 24),
            _buildRevenueBreakdown(),
          ],
        ),
      );

  Widget _buildRevenueOverview() => Row(
        children: [
          Expanded(
            child: _buildRevenueCard(
              title: 'Total Revenue',
              value: r'$125,847',
              change: '+18.5%',
              isPositive: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildRevenueCard(
              title: 'Monthly Recurring',
              value: r'$45,678',
              change: '+12.3%',
              isPositive: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildRevenueCard(
              title: 'Average Order',
              value: r'$89.50',
              change: '+5.2%',
              isPositive: true,
            ),
          ),
        ],
      );

  Widget _buildRevenueCard({
    required final String title,
    required final String value,
    required final String change,
    required final bool isPositive,
  }) =>
      Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildRevenueChart() => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Revenue Trend',
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
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 60,
                          getTitlesWidget: (value, final meta) =>
                              Text('\$${value.toInt()}K'),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, final meta) {
                            const months = <String>[
                              'Jan',
                              'Feb',
                              'Mar',
                              'Apr',
                              'May',
                              'Jun',
                            ];
                            if (value.toInt() >= 0 &&
                                value.toInt() < months.length) {
                              return Text(months[value.toInt()]);
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          const FlSpot(0, 15),
                          const FlSpot(1, 18),
                          const FlSpot(2, 22),
                          const FlSpot(3, 25),
                          const FlSpot(4, 28),
                          const FlSpot(5, 32),
                        ],
                        isCurved: true,
                        color: Colors.orange,
                        barWidth: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildRevenueBreakdown() => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Revenue Breakdown',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildRevenueItem('Subscription Revenue', r'$67,890', 0.54),
              _buildRevenueItem('One-time Bookings', r'$34,567', 0.27),
              _buildRevenueItem('Premium Features', r'$15,234', 0.12),
              _buildRevenueItem('Other', r'$8,156', 0.07),
            ],
          ),
        ),
      );

  Widget _buildRevenueItem(
    String category,
    final String amount,
    final double percentage,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(category),
            ),
            Expanded(
              child: Text(
                amount,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Text(
                '${(percentage * 100).toStringAsFixed(1)}%',
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      );
}
