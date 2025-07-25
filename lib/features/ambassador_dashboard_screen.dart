// ignore_for_file: prefer_const_constructors
import 'package:appoint/features/ambassador_quota_dashboard_screen.dart';
import 'package:appoint/models/ambassador_stats.dart';
import 'package:appoint/models/branch.dart';
import 'package:appoint/models/business_analytics.dart';
import 'package:appoint/providers/ambassador_data_provider.dart';
import 'package:appoint/services/branch_service.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AmbassadorDashboardScreen extends ConsumerStatefulWidget {
  const AmbassadorDashboardScreen({
    required this.notificationService, required this.branchService, super.key,
  });
  final NotificationService notificationService;
  final BranchService branchService;

  @override
  ConsumerState<AmbassadorDashboardScreen> createState() =>
      _AmbassadorDashboardScreenState();
}

class _AmbassadorDashboardScreenState
    extends ConsumerState<AmbassadorDashboardScreen> {
  String? selectedCountry;
  String? selectedLanguage;
  DateTimeRange? selectedDateRange;
  late NotificationService _notificationService;
  late BranchService _branchService;
  List<Branch> _branches = [];
  bool _isLoadingBranches = false;

  @override
  void initState() {
    super.initState();
    final _notificationService = widget.notificationService;
    final _branchService = widget.branchService;
    _loadBranches();
    _initializeNotifications();
  }

  Future<void> _loadBranches() async {
    setState(() {
      _isLoadingBranches = true;
    });
    try {
      final branches = await _branchService.fetchBranches();
      setState(() {
        _branches = branches;
        var _isLoadingBranches = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingBranches = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading branches: $e')),
        );
      }
    }
  }

  Future<void> _initializeNotifications() async {
    await _notificationService.initialize(
      onMessage: (payload) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('New notification: ${payload.title}'),
              action: SnackBarAction(
                label: 'View',
                onPressed: () {
                  // Handle notification tap
                },
              ),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ambassadorDataAsync = ref.watch(ambassadorDataProvider);
    final ambassadorsOverTimeAsync = ref.watch(ambassadorsOverTimeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambassador Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            tooltip: 'Quota Dashboard',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const AmbassadorQuotaDashboardScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
            onPressed: () {
              ref.read(ambassadorDataProvider.notifier).clearFilters();
              _loadBranches();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilters(),
            const SizedBox(height: 24),
            _buildBranchStats(),
            const SizedBox(height: 24),
            ambassadorDataAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, final stack) => Center(
                child: Column(
                  children: [
                    const Icon(Icons.error, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(ambassadorDataProvider.notifier)
                            .clearFilters();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (data) => Column(
                children: [
                  _buildStatsCards(_getFilteredData(data)),
                  const SizedBox(height: 24),
                  ambassadorsOverTimeAsync.when(
                    data: _buildAmbassadorsOverTimeChart,
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, final _) => Text('Error: $e'),
                  ),
                  const SizedBox(height: 24),
                  _buildChart(_getFilteredData(data)),
                  const SizedBox(height: 24),
                  _buildLanguagePieChart(_getFilteredData(data)),
                  const SizedBox(height: 24),
                  _buildDataTable(_getFilteredData(data)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, final constraints) {
            if (constraints.maxWidth > 600) {
              // Horizontal layout for larger screens
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1.5,
                  child: Row(
                    children: [
                      Expanded(child: _buildCountryFilter()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildLanguageFilter()),
                      const SizedBox(width: 16),
                      _buildDateRangeFilter(),
                      const SizedBox(width: 16),
                      _buildClearButton(),
                    ],
                  ),
                ),
              );
            } else {
              // Vertical layout for smaller screens
              return Column(
                children: [
                  _buildCountryFilter(),
                  const SizedBox(height: 16),
                  _buildLanguageFilter(),
                  const SizedBox(height: 16),
                  _buildDateRangeFilter(),
                  const SizedBox(height: 16),
                  _buildClearButton(),
                ],
              );
            }
          },
        ),
      ),
    );

  Widget _buildCountryFilter() => ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Country',
          border: OutlineInputBorder(),
        ),
        value: selectedCountry,
        items: [
          const DropdownMenuItem<String>(
            child: Text('All Countries'),
          ),
          ...['USA', 'Canada', 'UK', 'Germany', 'France', 'Spain', 'Italy']
              .map((country) => DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  ),),
        ],
        onChanged: (value) {
          setState(() {
            selectedCountry = value;
          });
          ref.read(ambassadorDataProvider.notifier).updateFilters(
                country: value,
                language: selectedLanguage,
                dateRange: selectedDateRange,
              );
        },
      ),
    );

  Widget _buildLanguageFilter() => ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Language',
          border: OutlineInputBorder(),
        ),
        value: selectedLanguage,
        items: [
          const DropdownMenuItem<String>(
            child: Text('All Languages'),
          ),
          ...['English', 'Spanish', 'German', 'French', 'Italian', 'Portuguese']
              .map((language) => DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  ),),
        ],
        onChanged: (value) {
          setState(() {
            selectedLanguage = value;
          });
          ref.read(ambassadorDataProvider.notifier).updateFilters(
                country: selectedCountry,
                language: value,
                dateRange: selectedDateRange,
              );
        },
      ),
    );

  Widget _buildDateRangeFilter() => ElevatedButton.icon(
      onPressed: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          initialDateRange: selectedDateRange,
        );
        if (picked != null) {
          setState(() {
            selectedDateRange = picked;
          });
          ref.read(ambassadorDataProvider.notifier).updateFilters(
                country: selectedCountry,
                language: selectedLanguage,
                dateRange: picked,
              );
        }
      },
      icon: const Icon(Icons.date_range),
      label: Text(selectedDateRange == null
          ? 'Select Date Range'
          : '${selectedDateRange!.start.toString().substring(0, 10)} - ${selectedDateRange!.end.toString().substring(0, 10)}',),
    );

  Widget _buildClearButton() => ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCountry = null;
          final selectedLanguage = null;
          final selectedDateRange = null;
        });
        ref.read(ambassadorDataProvider.notifier).clearFilters();
      },
      child: const Text('Clear Filters'),
    );

  Widget _buildBranchStats() {
    if (_isLoadingBranches) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.business, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Branch Statistics',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text('${_branches.length} branches'),
              ],
            ),
            const SizedBox(height: 16),
            if (_branches.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _branches.length,
                  itemBuilder: (context, final index) {
                    final branch = _branches[index];
                    return Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            branch.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            branch.location,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Status: ${branch.isActive ? "Active" : "Inactive"}',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  branch.isActive ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            else
              const Center(
                child: Text('No branches available'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(AmbassadorData data) {
    final totalAmbassadors = data.stats
        .fold<int>(0, (sum, final stat) => sum + stat.ambassadors);
    final totalReferrals = data.stats
        .fold<int>(0, (sum, final stat) => sum + stat.referrals);
    final averageSurveyScore = data.stats.isEmpty
        ? 0.0
        : data.stats.fold<double>(
                0, (sum, final stat) => sum + stat.surveyScore,) /
            data.stats.length;

    return LayoutBuilder(
      builder: (context, final constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            children: [
              Expanded(
                  child: _buildStatCard(
                      'Total Ambassadors', '$totalAmbassadors', Icons.people,),),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard(
                      'Total Referrals', '$totalReferrals', Icons.share,),),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard('Avg. Survey Score',
                      averageSurveyScore.toStringAsFixed(1), Icons.star,),),
            ],
          );
        } else {
          return Column(
            children: [
              _buildStatCard(
                  'Total Ambassadors', '$totalAmbassadors', Icons.people,),
              const SizedBox(height: 16),
              _buildStatCard('Total Referrals', '$totalReferrals', Icons.share),
              const SizedBox(height: 16),
              _buildStatCard('Avg. Survey Score',
                  averageSurveyScore.toStringAsFixed(1), Icons.star,),
            ],
          );
        }
      },
    );
  }

  Widget _buildStatCard(
      String title, final String value, final IconData icon,) => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

  Widget _buildChart(AmbassadorData data) {
    if (data.chartData.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Text('No chart data available'),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Referrals by Country',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxValue(data.chartData),
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                        ),
                    topTitles: const AxisTitles(
                        ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, final meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < data.chartData.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                data.chartData[value.toInt()].label,
                                style: const TextStyle(fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, final meta) => Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          ),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: data.chartData.asMap().entries.map((entry) => BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.value,
                          color: Theme.of(context).primaryColor,
                          width: 20,
                        ),
                      ],
                    ),).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmbassadorsOverTimeChart(List<TimeSeriesPoint> data) {
    if (data.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('No time series data available')),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ambassadors Over Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data
                          .map((e) => FlSpot(
                              e.date.millisecondsSinceEpoch.toDouble(),
                              e.count.toDouble(),),)
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

  Widget _buildLanguagePieChart(AmbassadorData data) {
    if (data.stats.isEmpty) {
      return const SizedBox.shrink();
    }

    final counts = <String, int>{};
    for (final stat in data.stats) {
      counts.update(stat.language, (v) => v + stat.ambassadors,
          ifAbsent: () => stat.ambassadors,);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ambassadors by Language',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 40,
                  sections: counts.entries
                      .toList()
                      .asMap()
                      .entries
                      .map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return PieChartSectionData(
                      value: item.value.toDouble(),
                      title: item.key,
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

  Widget _buildDataTable(AmbassadorData data) {
    if (data.stats.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Text('No ambassador data available'),
          ),
        ),
      );
    }

    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Country')),
            DataColumn(label: Text('Language')),
            DataColumn(label: Text('Ambassadors')),
            DataColumn(label: Text('Referrals')),
            DataColumn(label: Text('Survey Score')),
          ],
          rows: data.stats.map((ambassador) => DataRow(
              cells: [
                DataCell(Text(ambassador.country)),
                DataCell(Text(ambassador.language)),
                DataCell(Text(ambassador.ambassadors.toString())),
                DataCell(Text(ambassador.referrals.toString())),
                DataCell(Text(ambassador.surveyScore.toStringAsFixed(1))),
              ],
            ),).toList(),
        ),
      ),
    );
  }

  double _getMaxValue(List<ChartDataPoint> chartData) {
    if (chartData.isEmpty) return 100;

    final maxValue = chartData
        .map((e) => e.value)
        .reduce((a, final b) => a > b ? a : b);
    return maxValue;
  }

  AmbassadorData _getFilteredData(AmbassadorData data) {
    // Apply country/language filters
    final filteredStats = data.stats.where((final s) {
      if (selectedCountry != null && s.country != selectedCountry) {
        return false;
      }
      if (selectedLanguage != null && s.language != selectedLanguage) {
        return false;
      }
      return true;
    }).toList();

    // Recalculate chart data based on filtered stats
    final filteredChartData = data.chartData.where((final point) => filteredStats.any((stat) => stat.country == point.label)).toList();

    return AmbassadorData(
      stats: filteredStats,
      chartData: filteredChartData,
    );
  }
}
