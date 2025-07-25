import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/models/reminder_analytics.dart';
import 'package:appoint/services/reminder_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

final adminReminderStatsProvider = FutureProvider<AdminReminderStats>((ref) async {
  // This would fetch admin stats from the reminder service
  // For now, return mock data
  return AdminReminderStats(
    generatedAt: DateTime.now(),
    periodStart: DateTime.now().subtract(const Duration(days: 30)),
    periodEnd: DateTime.now(),
    totalUsers: 1250,
    activeReminderUsers: 850,
    totalReminders: 5650,
    locationBasedUsage: 1200,
    timeBasedUsage: 4450,
    overallCompletionRate: 0.72,
    remindersByPlan: {
      'starter': 2800,
      'professional': 2100,
      'business_plus': 750,
    },
    locationUsageByPlan: {
      'starter': 0,
      'professional': 900,
      'business_plus': 300,
    },
    completionRatesByPlan: {
      'starter': 0.68,
      'professional': 0.75,
      'business_plus': 0.81,
    },
    topUsers: [
      TopReminderUser(
        userId: 'user1',
        email: 'power.user@example.com',
        reminderCount: 127,
        completionRate: 0.89,
        planType: 'business_plus',
      ),
      TopReminderUser(
        userId: 'user2',
        email: 'organized@example.com',
        reminderCount: 98,
        completionRate: 0.92,
        planType: 'professional',
      ),
      TopReminderUser(
        userId: 'user3',
        email: 'busy.bee@example.com',
        reminderCount: 85,
        completionRate: 0.76,
        planType: 'professional',
      ),
    ],
  );
});

class ReminderAnalyticsScreen extends ConsumerWidget {
  const ReminderAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statsAsync = ref.watch(adminReminderStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Reminder Analytics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(adminReminderStatsProvider),
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: () => _exportData(context),
          ),
        ],
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text('Error loading analytics'),
              const SizedBox(height: 8),
              Text(error.toString()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(adminReminderStatsProvider),
                child: Text('Retry'),
              ),
            ],
          ),
        ),
        data: (stats) => _buildAnalyticsDashboard(context, stats, l10n),
      ),
    );
  }

  Widget _buildAnalyticsDashboard(BuildContext context, AdminReminderStats stats, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date range
          _buildHeader(context, stats),
          const SizedBox(height: 24),
          
          // Key metrics grid
          _buildMetricsGrid(context, stats),
          const SizedBox(height: 24),
          
          // Charts section
          _buildChartsSection(context, stats),
          const SizedBox(height: 24),
          
          // Subscription conversion metrics
          _buildSubscriptionMetrics(context, stats),
          const SizedBox(height: 24),
          
          // Top users
          _buildTopUsers(context, stats),
          const SizedBox(height: 24),
          
          // Insights and recommendations
          _buildInsights(context, stats),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AdminReminderStats stats) {
    final theme = Theme.of(context);
    final dateFormat = 'MMM dd, yyyy';
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Icon(
              Icons.analytics,
              color: theme.colorScheme.primary,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reminder System Analytics',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Period: ${_formatDate(stats.periodStart)} - ${_formatDate(stats.periodEnd)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'Generated: ${_formatDateTime(stats.generatedAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(BuildContext context, AdminReminderStats stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildMetricCard(
          context,
          title: 'Total Users',
          value: stats.totalUsers.toString(),
          subtitle: '${stats.activeReminderUsers} active users',
          icon: Icons.people,
          color: Colors.blue,
        ),
        _buildMetricCard(
          context,
          title: 'Total Reminders',
          value: stats.totalReminders.toString(),
          subtitle: '${(stats.totalReminders / stats.totalUsers).round()} per user',
          icon: Icons.alarm,
          color: Colors.green,
        ),
        _buildMetricCard(
          context,
          title: 'Completion Rate',
          value: '${(stats.overallCompletionRate * 100).round()}%',
          subtitle: 'Across all users',
          icon: Icons.check_circle,
          color: Colors.orange,
        ),
        _buildMetricCard(
          context,
          title: 'Location Usage',
          value: stats.locationBasedUsage.toString(),
          subtitle: '${(stats.locationBasedUsage / stats.totalReminders * 100).round()}% of all reminders',
          icon: Icons.location_on,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsSection(BuildContext context, AdminReminderStats stats) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Usage Distribution',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        Row(
          children: [
            // Reminder types pie chart
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Reminder Types',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: stats.timeBasedUsage.toDouble(),
                                title: 'Time-based',
                                color: Colors.blue,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PieChartSectionData(
                                value: stats.locationBasedUsage.toDouble(),
                                title: 'Location-based',
                                color: Colors.green,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Reminders by plan
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Reminders by Plan',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            barGroups: stats.remindersByPlan.entries.map((entry) {
                              final index = stats.remindersByPlan.keys.toList().indexOf(entry.key);
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: entry.value.toDouble(),
                                    color: _getPlanColor(entry.key),
                                    width: 20,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              );
                            }).toList(),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final plans = stats.remindersByPlan.keys.toList();
                                    if (value.toInt() < plans.length) {
                                      return Text(
                                        _formatPlanName(plans[value.toInt()]),
                                        style: theme.textTheme.bodySmall,
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: false),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubscriptionMetrics(BuildContext context, AdminReminderStats stats) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Subscription Conversion Metrics',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Location feature usage by plan
            Text(
              'Location-based Reminder Usage by Plan',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            ...stats.locationUsageByPlan.entries.map((entry) {
              final total = stats.remindersByPlan[entry.key] ?? 0;
              final percentage = total > 0 ? (entry.value / total * 100) : 0;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _getPlanColor(entry.key),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${_formatPlanName(entry.key)}: ${entry.value} (${percentage.round()}%)',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }),
            
            const SizedBox(height: 16),
            
            // Completion rates by plan
            Text(
              'Completion Rates by Plan',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            ...stats.completionRatesByPlan.entries.map((entry) {
              final percentage = (entry.value * 100).round();
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _getPlanColor(entry.key),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${_formatPlanName(entry.key)}: $percentage%',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: entry.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: _getPlanColor(entry.key),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTopUsers(BuildContext context, AdminReminderStats stats) {
    final theme = Theme.of(context);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.leaderboard,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Top Reminder Users',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            ...stats.topUsers.asMap().entries.map((entry) {
              final index = entry.key;
              final user = entry.value;
              final completionPercentage = (user.completionRate * 100).round();
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: index == 0 
                            ? Colors.amber 
                            : index == 1 
                                ? Colors.grey[400] 
                                : Colors.brown[300],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.email,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${user.reminderCount} reminders • $completionPercentage% completion • ${_formatPlanName(user.planType)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildInsights(BuildContext context, AdminReminderStats stats) {
    final theme = Theme.of(context);
    final insights = _generateInsights(stats);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Insights & Recommendations',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            ...insights.map((insight) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_right,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      insight,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  List<String> _generateInsights(AdminReminderStats stats) {
    final insights = <String>[];
    
    // Location usage insight
    final locationUsageRate = stats.locationBasedUsage / stats.totalReminders;
    if (locationUsageRate > 0.3) {
      insights.add('High location-based reminder usage (${(locationUsageRate * 100).round()}%) indicates strong value in map features.');
    } else if (locationUsageRate < 0.1) {
      insights.add('Low location-based reminder usage (${(locationUsageRate * 100).round()}%) suggests need for better feature promotion.');
    }
    
    // Completion rate insight
    if (stats.overallCompletionRate > 0.8) {
      insights.add('Excellent overall completion rate (${(stats.overallCompletionRate * 100).round()}%) shows high user engagement.');
    } else if (stats.overallCompletionRate < 0.6) {
      insights.add('Lower completion rate (${(stats.overallCompletionRate * 100).round()}%) suggests need for better reminder relevance or timing.');
    }
    
    // Plan conversion insight
    final professionalUsers = stats.remindersByPlan['professional'] ?? 0;
    final starterUsers = stats.remindersByPlan['starter'] ?? 0;
    if (professionalUsers > starterUsers) {
      insights.add('More Professional users than Starter users indicates successful upselling of advanced features.');
    }
    
    // Top user insight
    if (stats.topUsers.isNotEmpty) {
      final topUser = stats.topUsers.first;
      insights.add('Top user has ${topUser.reminderCount} reminders with ${(topUser.completionRate * 100).round()}% completion rate.');
    }
    
    return insights;
  }

  Color _getPlanColor(String plan) {
    switch (plan) {
      case 'starter':
        return Colors.grey;
      case 'professional':
        return Colors.blue;
      case 'business_plus':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatPlanName(String plan) {
    switch (plan) {
      case 'starter':
        return 'Starter';
      case 'professional':
        return 'Professional';
      case 'business_plus':
        return 'Business Plus';
      default:
        return plan;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _exportData(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Analytics data exported successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }
}