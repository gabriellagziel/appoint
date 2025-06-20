import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/ambassador_data_provider.dart';
import '../models/ambassador_stats.dart';

class AmbassadorDashboardScreen extends ConsumerStatefulWidget {
  const AmbassadorDashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AmbassadorDashboardScreen> createState() =>
      _AmbassadorDashboardScreenState();
}

class _AmbassadorDashboardScreenState
    extends ConsumerState<AmbassadorDashboardScreen> {
  String? selectedCountry;
  String? selectedLanguage;
  DateTimeRange? selectedDateRange;

  @override
  Widget build(BuildContext context) {
    final ambassadorDataAsync = ref.watch(ambassadorDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambassador Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilters(),
            const SizedBox(height: 24),
            ambassadorDataAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  children: [
                    const Icon(Icons.error, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                  ],
                ),
              ),
              data: (data) => Column(
                children: [
                  _buildStatsCards(data),
                  const SizedBox(height: 24),
                  _buildChart(data),
                  const SizedBox(height: 24),
                  _buildDataTable(data),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              // Horizontal layout for larger screens
              return Row(
                children: [
                  Expanded(child: _buildCountryFilter()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildLanguageFilter()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDateRangeFilter()),
                  const SizedBox(width: 16),
                  _buildClearButton(),
                ],
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
  }

  Widget _buildCountryFilter() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Country',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.location_on),
      ),
      value: selectedCountry,
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('All Countries'),
        ),
        ...[
          'United States',
          'Spain',
          'Germany',
          'France',
          'Italy',
          'United Kingdom'
        ]
            .map((country) => DropdownMenuItem<String>(
                  value: country,
                  child: Text(country),
                ))
            .toList(),
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
    );
  }

  Widget _buildLanguageFilter() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Language',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.language),
      ),
      value: selectedLanguage,
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('All Languages'),
        ),
        ...['English', 'Spanish', 'German', 'French', 'Italian', 'Portuguese']
            .map((language) => DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                ))
            .toList(),
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
    );
  }

  Widget _buildDateRangeFilter() {
    return ElevatedButton.icon(
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
          : '${selectedDateRange!.start.toString().substring(0, 10)} - ${selectedDateRange!.end.toString().substring(0, 10)}'),
    );
  }

  Widget _buildClearButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCountry = null;
          selectedLanguage = null;
          selectedDateRange = null;
        });
        ref.read(ambassadorDataProvider.notifier).clearFilters();
      },
      child: const Text('Clear Filters'),
    );
  }

  Widget _buildStatsCards(AmbassadorData data) {
    final totalAmbassadors =
        data.stats.fold<int>(0, (sum, stat) => sum + stat.ambassadors);
    final totalReferrals =
        data.stats.fold<int>(0, (sum, stat) => sum + stat.referrals);
    final averageSurveyScore = data.stats.isEmpty
        ? 0.0
        : data.stats.fold<double>(0, (sum, stat) => sum + stat.surveyScore) /
            data.stats.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return Row(
            children: [
              Expanded(
                  child: _buildStatCard(
                      'Total Ambassadors', '$totalAmbassadors', Icons.people)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard(
                      'Total Referrals', '$totalReferrals', Icons.share)),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard('Avg. Survey Score',
                      averageSurveyScore.toStringAsFixed(1), Icons.star)),
            ],
          );
        } else {
          return Column(
            children: [
              _buildStatCard(
                  'Total Ambassadors', '$totalAmbassadors', Icons.people),
              const SizedBox(height: 16),
              _buildStatCard('Total Referrals', '$totalReferrals', Icons.share),
              const SizedBox(height: 16),
              _buildStatCard('Avg. Survey Score',
                  averageSurveyScore.toStringAsFixed(1), Icons.star),
            ],
          );
        }
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
  }

  Widget _buildChart(AmbassadorData data) {
    if (data.chartData.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Text('No chart data available'),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                    show: true,
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 &&
                              value.toInt() < data.chartData.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
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
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: data.chartData.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.value,
                          color: Theme.of(context).primaryColor,
                          width: 20,
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

  Widget _buildDataTable(AmbassadorData data) {
    if (data.stats.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
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
          rows: data.stats.map((ambassador) {
            return DataRow(
              cells: [
                DataCell(Text(ambassador.country)),
                DataCell(Text(ambassador.language)),
                DataCell(Text(ambassador.ambassadors.toString())),
                DataCell(Text(ambassador.referrals.toString())),
                DataCell(Text(ambassador.surveyScore.toStringAsFixed(1))),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  double _getMaxValue(List<ChartDataPoint> chartData) {
    if (chartData.isEmpty) return 100.0;

    final maxValue =
        chartData.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    return maxValue;
  }
}
