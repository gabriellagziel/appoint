import 'package:appoint/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Read-only Admin Dashboard for Ambassador Program Monitoring
/// No manual intervention - purely observational and analytical
class AmbassadorAdminDashboard extends ConsumerStatefulWidget {
  const AmbassadorAdminDashboard({super.key});

  @override
  ConsumerState<AmbassadorAdminDashboard> createState() =>
      _AmbassadorAdminDashboardState();
}

class _AmbassadorAdminDashboardState
    extends ConsumerState<AmbassadorAdminDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  String _selectedTimeframe = 'last30days';

  // Sample data - replace with real API calls
  final Map<String, dynamic> _globalStats = {
    'totalAmbassadors': 1247,
    'activeAmbassadors': 1089,
    'totalQuota': 6675,
    'utilizationRate': 18.7,
    'monthlyPromotions': 89,
    'monthlyDemotions': 23,
    'avgMonthlyReferrals': 8.3,
    'topCountries': ['US', 'DE', 'FR', 'IT', 'ES'],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadDashboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    try {
      // Simulate API call to load ambassador analytics
      await Future.delayed(const Duration(seconds: 1));

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load analytics: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambassador Program Analytics'),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportReport,
            tooltip: 'Export Report',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: theme.colorScheme.primary,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Performance'),
            Tab(text: 'Analytics'),
            Tab(text: 'Automation'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(theme),
                _buildPerformanceTab(theme),
                _buildAnalyticsTab(theme),
                _buildAutomationTab(theme),
              ],
            ),
    );
  }

  Widget _buildOverviewTab(ThemeData theme) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Global Stats Cards
            _buildGlobalStatsCards(theme),
            const SizedBox(height: 24),

            // Utilization Chart
            _buildUtilizationChart(theme),
            const SizedBox(height: 24),

            // Country Distribution
            _buildCountryDistribution(theme),
            const SizedBox(height: 24),

            // Recent Activity
            _buildRecentActivity(theme),
          ],
        ),
      );

  Widget _buildGlobalStatsCards(ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Global Ambassador Statistics',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: [
              _buildStatCard(
                'Total Ambassadors',
                '${_globalStats['totalAmbassadors']}',
                'of ${_globalStats['totalQuota']} slots',
                Icons.people,
                Colors.blue,
                theme,
              ),
              _buildStatCard(
                'Active Ambassadors',
                '${_globalStats['activeAmbassadors']}',
                '${((_globalStats['activeAmbassadors'] / _globalStats['totalAmbassadors']) * 100).toInt()}% active',
                Icons.verified_user,
                Colors.green,
                theme,
              ),
              _buildStatCard(
                'Monthly Promotions',
                '${_globalStats['monthlyPromotions']}',
                '+${_globalStats['monthlyPromotions'] - _globalStats['monthlyDemotions']} net growth',
                Icons.trending_up,
                Colors.orange,
                theme,
              ),
              _buildStatCard(
                'Utilization Rate',
                '${_globalStats['utilizationRate']}%',
                'Global quota utilization',
                Icons.analytics,
                Colors.purple,
                theme,
              ),
            ],
          ),
        ],
      );

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    ThemeData theme,
  ) =>
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
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
      );

  Widget _buildUtilizationChart(ThemeData theme) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quota Utilization by Region',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 345,
                      title: 'Europe\n28%',
                      color: Colors.blue,
                      radius: 60,
                      titleStyle: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: 267,
                      title: 'Asia\n22%',
                      color: Colors.green,
                      radius: 60,
                      titleStyle: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: 198,
                      title: 'Americas\n16%',
                      color: Colors.orange,
                      radius: 60,
                      titleStyle: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: 87,
                      title: 'Africa\n7%',
                      color: Colors.purple,
                      radius: 60,
                      titleStyle: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    PieChartSectionData(
                      value: 5778,
                      title: 'Available\n27%',
                      color: Colors.grey.shade300,
                      radius: 50,
                      titleStyle: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildCountryDistribution(ThemeData theme) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Top Performing Countries',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: _selectedTimeframe,
                  items: const [
                    DropdownMenuItem(
                        value: 'last7days', child: Text('Last 7 days')),
                    DropdownMenuItem(
                        value: 'last30days', child: Text('Last 30 days')),
                    DropdownMenuItem(
                        value: 'last90days', child: Text('Last 90 days')),
                  ],
                  onChanged: (value) {
                    setState(() => _selectedTimeframe = value!);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ..._buildCountryItems(theme),
          ],
        ),
      );

  List<Widget> _buildCountryItems(ThemeData theme) {
    final countries = [
      {
        'code': 'US',
        'name': 'United States',
        'ambassadors': 287,
        'quota': 345,
        'growth': '+12'
      },
      {
        'code': 'DE',
        'name': 'Germany',
        'ambassadors': 98,
        'quota': 133,
        'growth': '+8'
      },
      {
        'code': 'FR',
        'name': 'France',
        'ambassadors': 89,
        'quota': 142,
        'growth': '+5'
      },
      {
        'code': 'IT',
        'name': 'Italy',
        'ambassadors': 76,
        'quota': 144,
        'growth': '+3'
      },
      {
        'code': 'ES',
        'name': 'Spain',
        'ambassadors': 134,
        'quota': 220,
        'growth': '+15'
      },
    ];

    return countries.map((country) {
      final utilization =
          (country['ambassadors']! as int) / (country['quota']! as int);

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 24,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  country['code']! as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
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
                    country['name']! as String,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: utilization,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation(
                            utilization > 0.8
                                ? Colors.green
                                : utilization > 0.5
                                    ? Colors.orange
                                    : Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${country['ambassadors']}/${country['quota']}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                country['growth']! as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildRecentActivity(ThemeData theme) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Automated Actions',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ..._buildActivityItems(theme),
          ],
        ),
      );

  List<Widget> _buildActivityItems(ThemeData theme) {
    final activities = [
      {
        'type': 'promotion',
        'message': '12 users promoted to Ambassador (Daily Check)',
        'time': '2 hours ago',
        'icon': Icons.arrow_upward,
        'color': Colors.green,
      },
      {
        'type': 'tier_upgrade',
        'message': '3 ambassadors upgraded to Premium tier',
        'time': '6 hours ago',
        'icon': Icons.star,
        'color': Colors.blue,
      },
      {
        'type': 'monthly_review',
        'message': 'Monthly review completed: 5 demotions, 89 renewals',
        'time': '1 day ago',
        'icon': Icons.assessment,
        'color': Colors.orange,
      },
      {
        'type': 'quota_alert',
        'message': 'Quota warning: US approaching 90% utilization',
        'time': '2 days ago',
        'icon': Icons.warning,
        'color': Colors.amber,
      },
    ];

    return activities
        .map(
          (activity) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (activity['color']! as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    activity['icon']! as IconData,
                    color: activity['color']! as Color,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity['message']! as String,
                        style: theme.textTheme.bodyMedium,
                      ),
                      Text(
                        activity['time']! as String,
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
        )
        .toList();
  }

  Widget _buildPerformanceTab(ThemeData theme) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPerformanceMetrics(theme),
            const SizedBox(height: 24),
            _buildReferralTrends(theme),
            const SizedBox(height: 24),
            _buildTopPerformers(theme),
          ],
        ),
      );

  Widget _buildPerformanceMetrics(ThemeData theme) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Metrics',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 8.2),
                        const FlSpot(1, 8.7),
                        const FlSpot(2, 8.1),
                        const FlSpot(3, 9.3),
                        const FlSpot(4, 8.8),
                        const FlSpot(5, 9.1),
                        const FlSpot(6, 8.5),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildReferralTrends(ThemeData theme) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monthly Referral Trends',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTrendItem(
                      'Total Referrals', '2,847', '+12%', Colors.blue, theme),
                ),
                Expanded(
                  child: _buildTrendItem(
                      'Avg per Ambassador', '8.3', '+5%', Colors.green, theme),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTrendItem(
                      'Conversion Rate', '73%', '+2%', Colors.orange, theme),
                ),
                Expanded(
                  child: _buildTrendItem(
                      'Active Rate', '87%', '-1%', Colors.red, theme),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _buildTrendItem(
      String label, String value, String change, Color color, ThemeData theme) {
    final isPositive = change.startsWith('+');

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                change,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isPositive ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformers(ThemeData theme) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Performing Ambassadors',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) =>
                  _buildPerformerItem(index + 1, theme),
            ),
          ],
        ),
      );

  Widget _buildPerformerItem(int rank, ThemeData theme) {
    final referrals = [45, 38, 34, 29, 26][rank - 1];
    final tier = rank <= 2
        ? 'Lifetime'
        : rank <= 4
            ? 'Premium'
            : 'Basic';
    final tierColor = rank <= 2
        ? Colors.orange
        : rank <= 4
            ? Colors.blue
            : Colors.green;

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: rank <= 3
                ? (rank == 1
                    ? Colors.amber
                    : rank == 2
                        ? Colors.grey.shade400
                        : Colors.brown.shade400)
                : theme.colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: rank <= 3
                    ? Colors.white
                    : theme.colorScheme.onSurfaceVariant,
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
                'Ambassador ${rank.toString().padLeft(4, '0')}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: tierColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tier,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: tierColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$referrals referrals this month',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab(ThemeData theme) => const Center(
        child: Text('Advanced Analytics Coming Soon'),
      );

  Widget _buildAutomationTab(ThemeData theme) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAutomationStatus(theme),
            const SizedBox(height: 24),
            _buildAutomationLogs(theme),
          ],
        ),
      );

  Widget _buildAutomationStatus(ThemeData theme) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Automation Status',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildAutomationStatusItem(
              'Daily Eligibility Check',
              'Active',
              'Next run: Today 2:00 AM',
              Colors.green,
              theme,
            ),
            const SizedBox(height: 12),
            _buildAutomationStatusItem(
              'Monthly Performance Review',
              'Scheduled',
              'Next run: 1st of next month',
              Colors.blue,
              theme,
            ),
            const SizedBox(height: 12),
            _buildAutomationStatusItem(
              'Tier Upgrades',
              'Active',
              'Real-time processing',
              Colors.orange,
              theme,
            ),
            const SizedBox(height: 12),
            _buildAutomationStatusItem(
              'Quota Enforcement',
              'Active',
              'Real-time monitoring',
              Colors.purple,
              theme,
            ),
          ],
        ),
      );

  Widget _buildAutomationStatusItem(
    String title,
    String status,
    String nextRun,
    Color color,
    ThemeData theme,
  ) =>
      Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$status • $nextRun',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );

  Widget _buildAutomationLogs(ThemeData theme) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Automation Logs (Last 24 Hours)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(8, (index) => _buildLogItem(index, theme)),
          ],
        ),
      );

  Widget _buildLogItem(int index, ThemeData theme) {
    final logs = [
      {
        'time': '14:30',
        'action': 'Daily eligibility check completed',
        'result': '12 promotions'
      },
      {
        'time': '12:45',
        'action': 'Tier upgrade processed',
        'result': 'User promoted to Premium'
      },
      {
        'time': '11:20',
        'action': 'Monthly quota validation',
        'result': 'All quotas within limits'
      },
      {
        'time': '09:15',
        'action': 'Referral tracking updated',
        'result': '234 new referrals processed'
      },
      {
        'time': '08:00',
        'action': 'Performance metrics calculated',
        'result': 'Global stats updated'
      },
      {
        'time': '06:30',
        'action': 'Automation health check',
        'result': 'All systems operational'
      },
      {
        'time': '04:15',
        'action': 'Database cleanup completed',
        'result': 'Inactive records archived'
      },
      {
        'time': '02:00',
        'action': 'Scheduled eligibility check',
        'result': '8 users promoted'
      },
    ];

    final log = logs[index];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              log['time']!,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log['action']!,
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  log['result']!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _exportReport() {
    // Implement report export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report export functionality coming soon')),
    );
  }
}
