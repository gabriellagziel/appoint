import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/services/analytics_service.dart';
import 'package:appoint/models/admin_broadcast_message.dart';
import 'package:appoint/models/custom_form_field.dart';
import 'package:intl/intl.dart';

class AnalyticsDashboardScreen extends ConsumerStatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  ConsumerState<AnalyticsDashboardScreen> createState() => _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends ConsumerState<AnalyticsDashboardScreen> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.analyticsDashboard),
        actions: [
          IconButton(
            onPressed: _showExportDialog,
            icon: const Icon(Icons.download),
            tooltip: l10n.exportData,
          ),
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list),
            tooltip: l10n.filters,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    onTap: (index) => setState(() => _selectedTabIndex = index),
                    tabs: [
                      Tab(text: l10n.overview),
                      Tab(text: l10n.broadcasts),
                      Tab(text: l10n.formAnalytics),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildOverviewTab(),
                        _buildBroadcastsTab(),
                        _buildFormAnalyticsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filter = ref.watch(analyticsFilterProvider);
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        children: [
          FilterChip(
            label: Text(_getTimeRangeLabel(filter.timeRange)),
            selected: true,
            onSelected: (_) => _showTimeRangeDialog(),
          ),
          if (filter.country != null)
            FilterChip(
              label: Text('${AppLocalizations.of(context)!.country}: ${filter.country}'),
              selected: true,
              onSelected: (_) => _clearCountryFilter(),
              deleteIcon: const Icon(Icons.close, size: 16),
            ),
          if (filter.language != null)
            FilterChip(
              label: Text('${AppLocalizations.of(context)!.language}: ${filter.language}'),
              selected: true,
              onSelected: (_) => _clearLanguageFilter(),
              deleteIcon: const Icon(Icons.close, size: 16),
            ),
          if (filter.messageType != null)
            FilterChip(
              label: Text('${AppLocalizations.of(context)!.type}: ${filter.messageType!.name}'),
              selected: true,
              onSelected: (_) => _clearTypeFilter(),
              deleteIcon: const Icon(Icons.close, size: 16),
            ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewCards(),
          const SizedBox(height: 24),
          _buildChartsSection(),
          const SizedBox(height: 24),
          _buildBreakdownSection(),
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    final summaryAsync = ref.watch(analyticsSummaryProvider);
    
    return summaryAsync.when(
      data: (summary) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: AppLocalizations.of(context)!.totalBroadcasts,
                  value: summary.totalBroadcasts.toString(),
                  icon: Icons.campaign,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  title: AppLocalizations.of(context)!.totalRecipients,
                  value: _formatNumber(summary.totalRecipients),
                  icon: Icons.people,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: AppLocalizations.of(context)!.openRate,
                  value: '${summary.openRate.toStringAsFixed(1)}%',
                  icon: Icons.open_in_new,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  title: AppLocalizations.of(context)!.engagementRate,
                  value: '${summary.engagementRate.toStringAsFixed(1)}%',
                  icon: Icons.trending_up,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
      loading: () => _buildLoadingCards(),
      error: (error, stack) => _buildErrorCard(error.toString()),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsSection() {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.analytics,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: ref.watch(analyticsTimeSeriesProvider).when(
            data: (timeSeriesData) => _buildTimeSeriesChart(timeSeriesData),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorCard(error.toString()),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSeriesChart(List<AnalyticsTimeSeriesData> data) {
    if (data.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noDataAvailable),
      );
    }

    final maxY = data
        .map((d) => [d.sent, d.opened, d.clicked, d.responses].reduce((a, b) => a > b ? a : b))
        .reduce((a, b) => a > b ? a : b)
        .toDouble();

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return Text(
                    DateFormat('MM/dd').format(data[index].date),
                    style: const TextStyle(fontSize: 10),
                  );
                }
                return const Text('');
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: 0,
        maxY: maxY * 1.1,
        lineBarsData: [
          // Sent line
          LineChartBarData(
            spots: data.asMap().entries.map((entry) => 
              FlSpot(entry.key.toDouble(), entry.value.sent.toDouble())
            ).toList(),
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          // Opened line
          LineChartBarData(
            spots: data.asMap().entries.map((entry) => 
              FlSpot(entry.key.toDouble(), entry.value.opened.toDouble())
            ).toList(),
            isCurved: true,
            color: Colors.green,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          // Clicked line
          LineChartBarData(
            spots: data.asMap().entries.map((entry) => 
              FlSpot(entry.key.toDouble(), entry.value.clicked.toDouble())
            ).toList(),
            isCurved: true,
            color: Colors.orange,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          // Responses line
          LineChartBarData(
            spots: data.asMap().entries.map((entry) => 
              FlSpot(entry.key.toDouble(), entry.value.responses.toDouble())
            ).toList(),
            isCurved: true,
            color: Colors.purple,
            barWidth: 2,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.black87,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final data = this.data[spot.x.toInt()];
                final labels = ['Sent', 'Opened', 'Clicked', 'Responses'];
                final values = [data.sent, data.opened, data.clicked, data.responses];
                final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple];
                
                return LineTooltipItem(
                  '${labels[spot.barIndex]}: ${values[spot.barIndex]}\n'
                  '${DateFormat('MMM dd').format(data.date)}',
                  TextStyle(color: colors[spot.barIndex]),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownSection() {
    final summaryAsync = ref.watch(analyticsSummaryProvider);
    
    return summaryAsync.when(
      data: (summary) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.breakdown,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildBreakdownCard(
                  title: AppLocalizations.of(context)!.byCountry,
                  data: summary.countryBreakdown,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildBreakdownCard(
                  title: AppLocalizations.of(context)!.byType,
                  data: summary.typeBreakdown,
                ),
              ),
            ],
          ),
        ],
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => _buildErrorCard(error.toString()),
    );
  }

  Widget _buildBreakdownCard(String title, Map<String, int> data) {
    if (data.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.noDataAvailable),
            ],
          ),
        ),
      );
    }

    final sortedEntries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ...sortedEntries.take(5).map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    _formatNumber(entry.value),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
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

  Widget _buildBroadcastsTab() {
    return ref.watch(broadcastListProvider).when(
      data: (broadcasts) => _buildBroadcastList(broadcasts),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorCard(error.toString()),
    );
  }

  Widget _buildBroadcastList(List<BroadcastAnalyticsDetail> broadcasts) {
    if (broadcasts.isEmpty) {
      return Center(
        child: Text(AppLocalizations.of(context)!.noBroadcastsFound),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: broadcasts.length,
      itemBuilder: (context, index) {
        final broadcast = broadcasts[index];
        return _buildBroadcastCard(broadcast);
      },
    );
  }

  Widget _buildBroadcastCard(BroadcastAnalyticsDetail broadcast) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        broadcast.message.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM dd, yyyy HH:mm').format(broadcast.message.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(broadcast.message.status),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatItem(l10n.sent, broadcast.summary.totalSent.toString()),
                _buildStatItem(l10n.opened, broadcast.summary.totalOpened.toString()),
                _buildStatItem(l10n.clicked, broadcast.summary.totalClicked.toString()),
                if (broadcast.message.type == BroadcastMessageType.form)
                  _buildStatItem(l10n.responses, broadcast.summary.totalResponses.toString()),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildRateItem(l10n.openRate, broadcast.summary.openRate),
                _buildRateItem(l10n.clickRate, broadcast.summary.clickRate),
                if (broadcast.message.type == BroadcastMessageType.form)
                  _buildRateItem(l10n.responseRate, broadcast.summary.responseRate),
              ],
            ),
            if (broadcast.message.type == BroadcastMessageType.form &&
                broadcast.formStatistics != null) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => _showFormAnalyticsDetail(broadcast),
                child: Text(l10n.viewFormAnalytics),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateItem(String label, double rate) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '${rate.toStringAsFixed(1)}%',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _getRateColor(rate),
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BroadcastMessageStatus status) {
    Color color;
    String text;

    switch (status) {
      case BroadcastMessageStatus.pending:
        color = Colors.orange;
        text = AppLocalizations.of(context)!.pending;
        break;
      case BroadcastMessageStatus.sending:
        color = Colors.blue;
        text = AppLocalizations.of(context)!.sending;
        break;
      case BroadcastMessageStatus.sent:
        color = Colors.green;
        text = AppLocalizations.of(context)!.sent;
        break;
      case BroadcastMessageStatus.failed:
        color = Colors.red;
        text = AppLocalizations.of(context)!.failed;
        break;
      case BroadcastMessageStatus.partially_sent:
        color = Colors.amber;
        text = AppLocalizations.of(context)!.partialSent;
        break;
    }

    return Chip(
      label: Text(text),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
    );
  }

  Widget _buildFormAnalyticsTab() {
    return ref.watch(broadcastListProvider).when(
      data: (broadcasts) {
        final formBroadcasts = broadcasts
            .where((b) => b.message.type == BroadcastMessageType.form)
            .toList();
        
        if (formBroadcasts.isEmpty) {
          return Center(
            child: Text(AppLocalizations.of(context)!.noFormBroadcasts),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: formBroadcasts.length,
          itemBuilder: (context, index) {
            final broadcast = formBroadcasts[index];
            return _buildFormAnalyticsCard(broadcast);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorCard(error.toString()),
    );
  }

  Widget _buildFormAnalyticsCard(BroadcastAnalyticsDetail broadcast) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              broadcast.message.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)!.totalResponses}: ${broadcast.summary.totalResponses}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (broadcast.formStatistics != null)
              ...broadcast.formStatistics!.map((stat) => _buildFormFieldStat(stat))
            else
              Text(AppLocalizations.of(context)!.noFormData),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFieldStat(FormFieldStatistics stat) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.fieldLabel,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text('${AppLocalizations.of(context)!.responses}: ${stat.validResponses}'),
              const SizedBox(width: 16),
              if (stat.averageValue != null)
                Text('${AppLocalizations.of(context)!.average}: ${stat.averageValue!.toStringAsFixed(2)}'),
              if (stat.mostCommonValue != null)
                Text('${AppLocalizations.of(context)!.mostCommon}: ${stat.mostCommonValue}'),
            ],
          ),
          if (stat.choiceDistribution != null && stat.choiceDistribution!.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...stat.choiceDistribution!.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Row(
                children: [
                  Expanded(child: Text(entry.key)),
                  Text('${entry.value} (${((entry.value / stat.validResponses) * 100).toStringAsFixed(1)}%)'),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingCards() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildLoadingCard()),
            const SizedBox(width: 16),
            Expanded(child: _buildLoadingCard()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildLoadingCard()),
            const SizedBox(width: 16),
            Expanded(child: _buildLoadingCard()),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 16,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 8),
            Container(
              width: 60,
              height: 24,
              color: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.error, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.errorLoadingData,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getRateColor(double rate) {
    if (rate >= 80) return Colors.green;
    if (rate >= 60) return Colors.orange;
    return Colors.red;
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }

  String _getTimeRangeLabel(TimeRange timeRange) {
    final l10n = AppLocalizations.of(context)!;
    switch (timeRange) {
      case TimeRange.today:
        return l10n.today;
      case TimeRange.last7Days:
        return l10n.last7Days;
      case TimeRange.last30Days:
        return l10n.last30Days;
      case TimeRange.custom:
        return l10n.customRange;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        currentFilter: ref.read(analyticsFilterProvider),
        onFilterChanged: (filter) {
          ref.read(analyticsFilterProvider.notifier).state = filter;
        },
      ),
    );
  }

  void _showTimeRangeDialog() {
    showDialog(
      context: context,
      builder: (context) => TimeRangeDialog(
        currentFilter: ref.read(analyticsFilterProvider),
        onFilterChanged: (filter) {
          ref.read(analyticsFilterProvider.notifier).state = filter;
        },
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => ExportDialog(),
    );
  }

  void _showFormAnalyticsDetail(BroadcastAnalyticsDetail broadcast) {
    showDialog(
      context: context,
      builder: (context) => FormAnalyticsDetailDialog(broadcast: broadcast),
    );
  }

  void _clearCountryFilter() {
    final currentFilter = ref.read(analyticsFilterProvider);
    ref.read(analyticsFilterProvider.notifier).state = 
        currentFilter.copyWith(country: null);
  }

  void _clearLanguageFilter() {
    final currentFilter = ref.read(analyticsFilterProvider);
    ref.read(analyticsFilterProvider.notifier).state = 
        currentFilter.copyWith(language: null);
  }

  void _clearTypeFilter() {
    final currentFilter = ref.read(analyticsFilterProvider);
    ref.read(analyticsFilterProvider.notifier).state = 
        currentFilter.copyWith(messageType: null);
  }
}

// Helper Dialogs
class FilterDialog extends StatefulWidget {
  final AnalyticsFilter currentFilter;
  final ValueChanged<AnalyticsFilter> onFilterChanged;

  const FilterDialog({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late AnalyticsFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.currentFilter;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return AlertDialog(
      title: Text(l10n.filters),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _filter.country,
            decoration: InputDecoration(labelText: l10n.country),
            items: const [
              DropdownMenuItem(value: null, child: Text('All')),
              DropdownMenuItem(value: 'US', child: Text('United States')),
              DropdownMenuItem(value: 'CA', child: Text('Canada')),
              DropdownMenuItem(value: 'UK', child: Text('United Kingdom')),
            ],
            onChanged: (value) {
              setState(() {
                _filter = _filter.copyWith(country: value);
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<BroadcastMessageType>(
            value: _filter.messageType,
            decoration: InputDecoration(labelText: l10n.messageType),
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.all)),
              ...BroadcastMessageType.values.map((type) =>
                DropdownMenuItem(value: type, child: Text(type.name))),
            ],
            onChanged: (value) {
              setState(() {
                _filter = _filter.copyWith(messageType: value);
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onFilterChanged(_filter);
            Navigator.of(context).pop();
          },
          child: Text(l10n.apply),
        ),
      ],
    );
  }
}

class TimeRangeDialog extends StatefulWidget {
  final AnalyticsFilter currentFilter;
  final ValueChanged<AnalyticsFilter> onFilterChanged;

  const TimeRangeDialog({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  State<TimeRangeDialog> createState() => _TimeRangeDialogState();
}

class _TimeRangeDialogState extends State<TimeRangeDialog> {
  late TimeRange _selectedRange;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _selectedRange = widget.currentFilter.timeRange;
    _startDate = widget.currentFilter.startDate;
    _endDate = widget.currentFilter.endDate;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return AlertDialog(
      title: Text(l10n.timeRange),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...TimeRange.values.map((range) => RadioListTile<TimeRange>(
            title: Text(_getTimeRangeLabel(range)),
            value: range,
            groupValue: _selectedRange,
            onChanged: (value) {
              setState(() {
                _selectedRange = value!;
              });
            },
          )),
          if (_selectedRange == TimeRange.custom) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now().subtract(const Duration(days: 7)),
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                        });
                      }
                    },
                    child: Text(_startDate != null 
                        ? DateFormat('MMM dd, yyyy').format(_startDate!)
                        : l10n.startDate),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _endDate ?? DateTime.now(),
                        firstDate: _startDate ?? DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          _endDate = date;
                        });
                      }
                    },
                    child: Text(_endDate != null 
                        ? DateFormat('MMM dd, yyyy').format(_endDate!)
                        : l10n.endDate),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            final filter = widget.currentFilter.copyWith(
              timeRange: _selectedRange,
              startDate: _startDate,
              endDate: _endDate,
            );
            widget.onFilterChanged(filter);
            Navigator.of(context).pop();
          },
          child: Text(l10n.apply),
        ),
      ],
    );
  }

  String _getTimeRangeLabel(TimeRange timeRange) {
    final l10n = AppLocalizations.of(context)!;
    switch (timeRange) {
      case TimeRange.today:
        return l10n.today;
      case TimeRange.last7Days:
        return l10n.last7Days;
      case TimeRange.last30Days:
        return l10n.last30Days;
      case TimeRange.custom:
        return l10n.customRange;
    }
  }
}

class ExportDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    return AlertDialog(
      title: Text(l10n.exportData),
      content: Text(l10n.exportDataDescription),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              final csvData = await ref.read(analyticsExportProvider.future);
              // Here you would implement file saving/sharing
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.exportComplete)),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${l10n.exportFailed}: $e')),
              );
            }
          },
          child: Text(l10n.export),
        ),
      ],
    );
  }
}

class FormAnalyticsDetailDialog extends StatelessWidget {
  final BroadcastAnalyticsDetail broadcast;

  const FormAnalyticsDetailDialog({
    super.key,
    required this.broadcast,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return AlertDialog(
      title: Text('${l10n.formAnalytics}: ${broadcast.message.title}'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${l10n.totalResponses}: ${broadcast.summary.totalResponses}'),
              const SizedBox(height: 16),
              if (broadcast.formStatistics != null)
                ...broadcast.formStatistics!.map((stat) => _buildDetailedFieldStat(context, stat))
              else
                Text(l10n.noFormData),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.close),
        ),
      ],
    );
  }

  Widget _buildDetailedFieldStat(BuildContext context, FormFieldStatistics stat) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stat.fieldLabel,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text('Type: ${stat.fieldType.name}'),
            Text('Total Responses: ${stat.totalResponses}'),
            Text('Valid Responses: ${stat.validResponses}'),
            if (stat.averageValue != null)
              Text('Average: ${stat.averageValue!.toStringAsFixed(2)}'),
            if (stat.mostCommonValue != null)
              Text('Most Common: ${stat.mostCommonValue}'),
            if (stat.choiceDistribution != null && stat.choiceDistribution!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Distribution:'),
              ...stat.choiceDistribution!.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text('${entry.key}: ${entry.value} (${((entry.value / stat.validResponses) * 100).toStringAsFixed(1)}%)'),
              )),
            ],
          ],
        ),
      ),
    );
  }
}