import 'package:appoint/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

final businessAnalyticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  // TODO: Implement real analytics data
  return {
    'revenue': {
      'current': 12500.0,
      'previous': 11000.0,
      'growth': 13.6,
    },
    'bookings': {
      'current': 45,
      'previous': 38,
      'growth': 18.4,
    },
    'clients': {
      'current': 120,
      'previous': 105,
      'growth': 14.3,
    },
    'services': [
      {'name': 'Haircut', 'bookings': 15, 'revenue': 4500},
      {'name': 'Manicure', 'bookings': 12, 'revenue': 3600},
      {'name': 'Massage', 'bookings': 8, 'revenue': 2400},
      {'name': 'Facial', 'bookings': 10, 'revenue': 2000},
    ],
    'monthlyData': [
      {'month': 'Jan', 'revenue': 8000, 'bookings': 30},
      {'month': 'Feb', 'revenue': 9500, 'bookings': 35},
      {'month': 'Mar', 'revenue': 11000, 'bookings': 40},
      {'month': 'Apr', 'revenue': 12500, 'bookings': 45},
    ],
  };
});

class BusinessAnalyticsScreen extends ConsumerWidget {
  const BusinessAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final analyticsAsync = ref.watch(businessAnalyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportAnalytics(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: analyticsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text('Failed to load analytics'),
              const SizedBox(height: 8),
              Text(error.toString()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(businessAnalyticsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (analytics) => _buildAnalytics(context, analytics, l10n),
      ),
    );
  }

  Widget _buildAnalytics(BuildContext context, Map<String, dynamic> analytics, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview cards
          _buildOverviewCards(context, analytics),
          
          const SizedBox(height: 24),
          
          // Revenue chart
          _buildRevenueChart(context, analytics),
          
          const SizedBox(height: 24),
          
          // Service breakdown
          _buildServiceBreakdown(context, analytics),
          
          const SizedBox(height: 24),
          
          // Top performing services
          _buildTopServices(context, analytics),
          
          const SizedBox(height: 24),
          
          // Recent activity
          _buildRecentActivity(context),
        ],
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context, Map<String, dynamic> analytics) {
    final revenue = analytics['revenue'] as Map<String, dynamic>;
    final bookings = analytics['bookings'] as Map<String, dynamic>;
    final clients = analytics['clients'] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                context,
                'Revenue',
                '\$${revenue['current'].toStringAsFixed(0)}',
                revenue['growth'] as double,
                Icons.attach_money,
                Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildOverviewCard(
                context,
                'Bookings',
                bookings['current'].toString(),
                bookings['growth'] as double,
                Icons.calendar_today,
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildOverviewCard(
                context,
                'Clients',
                clients['current'].toString(),
                clients['growth'] as double,
                Icons.people,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildOverviewCard(
                context,
                'Avg. Rating',
                '4.8',
                5.2,
                Icons.star,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverviewCard(BuildContext context, String title, String value, double growth, IconData icon, Color color) {
    final isPositive = growth >= 0;
    
    return Card(
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green[100] : Colors.red[100],
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
                        '${growth.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(BuildContext context, Map<String, dynamic> analytics) {
    final monthlyData = analytics['monthlyData'] as List<dynamic>;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Revenue Trend',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('\$${value.toInt()}');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < monthlyData.length) {
                            return Text(monthlyData[value.toInt()]['month']);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: monthlyData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value['revenue'].toDouble());
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
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

  Widget _buildServiceBreakdown(BuildContext context, Map<String, dynamic> analytics) {
    final services = analytics['services'] as List<dynamic>;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Breakdown',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: services.map((service) {
                    final totalRevenue = services.fold<double>(0, (sum, s) => sum + s['revenue']);
                    final percentage = (service['revenue'] / totalRevenue) * 100;
                    
                    return PieChartSectionData(
                      value: service['revenue'].toDouble(),
                      title: '${percentage.toStringAsFixed(1)}%',
                      color: _getServiceColor(service['name']),
                      radius: 80,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  }).toList(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Legend
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: services.map((service) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getServiceColor(service['name']),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(service['name']),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopServices(BuildContext context, Map<String, dynamic> analytics) {
    final services = analytics['services'] as List<dynamic>;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Performing Services',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                final rank = index + 1;
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getServiceColor(service['name']),
                    child: Text(
                      rank.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(service['name']),
                  subtitle: Text('${service['bookings']} bookings'),
                  trailing: Text(
                    '\$${service['revenue']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                final activities = [
                  {'action': 'New booking', 'details': 'Haircut - Sarah Johnson', 'time': '2 hours ago'},
                  {'action': 'Payment received', 'details': '\$75.00 - Manicure', 'time': '4 hours ago'},
                  {'action': 'Review posted', 'details': '5 stars - Massage service', 'time': '1 day ago'},
                  {'action': 'New client', 'details': 'Mike Wilson registered', 'time': '1 day ago'},
                  {'action': 'Appointment cancelled', 'details': 'Facial - Lisa Brown', 'time': '2 days ago'},
                ];
                final activity = activities[index];
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.event, color: Colors.grey[600]),
                  ),
                  title: Text(activity['action'] as String),
                  subtitle: Text(activity['details'] as String),
                  trailing: Text(
                    activity['time'] as String,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getServiceColor(String serviceName) {
    final colors = {
      'Haircut': Colors.blue,
      'Manicure': Colors.pink,
      'Massage': Colors.green,
      'Facial': Colors.orange,
      'Pedicure': Colors.purple,
      'Waxing': Colors.red,
    };
    
    return colors[serviceName] ?? Colors.grey;
  }

  void _exportAnalytics(BuildContext context) {
    // TODO: Implement analytics export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export feature coming soon!')),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Analytics'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Filter options coming soon...'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
} 