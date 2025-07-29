import 'package:appoint/providers/ambassador_quota_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AmbassadorQuotaDashboardScreen extends ConsumerWidget {
  const AmbassadorQuotaDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final globalStatsAsync = ref.watch(globalQuotaStatisticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambassador Quota Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: globalStatsAsync.when(
        data: (globalStats) => _buildDashboard(context, globalStats),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, final stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    final Map<String, dynamic> globalStats,
  ) =>
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Global Ambassador Quota Statistics',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            _buildStatsGrid(globalStats),
          ],
        ),
      );

  Widget _buildStatsGrid(Map<String, dynamic> globalStats) => GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
        children: [
          _buildStatCard(
            'Total Quota',
            globalStats['totalQuota'].toString(),
            Icons.people,
            Colors.blue,
          ),
          _buildStatCard(
            'Current Ambassadors',
            globalStats['totalCurrent'].toString(),
            Icons.person,
            Colors.green,
          ),
          _buildStatCard(
            'Available Slots',
            globalStats['totalAvailable'].toString(),
            Icons.add_circle,
            Colors.orange,
          ),
          _buildStatCard(
            'Utilization',
            '${globalStats['globalUtilizationPercentage']}%',
            Icons.trending_up,
            Colors.purple,
          ),
        ],
      );

  Widget _buildStatCard(
    final String title,
    final String value,
    IconData icon,
    final Color color,
  ) =>
      Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
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
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}
