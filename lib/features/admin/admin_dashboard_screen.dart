import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../extensions/fl_chart_color_shim.dart';
import '../../widgets/admin_guard.dart';
import '../../providers/admin_provider.dart';
import '../../models/admin_dashboard_stats.dart';
import '../../l10n/app_localizations.dart';
import 'admin_broadcast_screen.dart';
import 'admin_users_screen.dart';
import 'admin_orgs_screen.dart';
import 'admin_demo_panel_screen.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AdminGuard(
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n?.adminScreenTBD ?? 'Admin Dashboard'),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.invalidate(adminDashboardStatsProvider);
                ref.invalidate(errorLogsProvider);
                ref.invalidate(activityLogsProvider);
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _showSettingsDialog(),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
              Tab(icon: Icon(Icons.error), text: 'Errors'),
              Tab(icon: Icon(Icons.history), text: 'Activity'),
              Tab(icon: Icon(Icons.monetization_on), text: 'Monetization'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildDashboardTab(),
            _buildErrorsTab(),
            _buildActivityTab(),
            _buildMonetizationTab(),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(),
        drawer: _buildDrawer(),
      ),
    );
  }

  Widget _buildDashboardTab() {
    final dashboardStats = ref.watch(adminDashboardStatsProvider);

    return dashboardStats.when(
      data: (stats) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsCards(stats),
            const SizedBox(height: 24),
            _buildRevenueChart(stats),
            const SizedBox(height: 24),
            _buildUserGrowthChart(stats),
            const SizedBox(height: 24),
            _buildQuickActions(),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading dashboard: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(adminDashboardStatsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(AdminDashboardStats stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Total Users',
          stats.totalUsers.toString(),
          Icons.people,
          Colors.blue,
          subtitle: '${stats.activeUsers} active',
        ),
        _buildStatCard(
          'Total Bookings',
          stats.totalBookings.toString(),
          Icons.calendar_today,
          Colors.green,
          subtitle: '${stats.completedBookings} completed',
        ),
        _buildStatCard(
          'Total Revenue',
          '\$${stats.totalRevenue.toStringAsFixed(2)}',
          Icons.attach_money,
          Colors.orange,
          subtitle: 'Ad: \$${stats.adRevenue.toStringAsFixed(2)}',
        ),
        _buildStatCard(
          'Organizations',
          stats.totalOrganizations.toString(),
          Icons.business,
          Colors.purple,
          subtitle: '${stats.activeOrganizations} active',
        ),
        _buildStatCard(
          'Ambassadors',
          stats.totalAmbassadors.toString(),
          Icons.star,
          Colors.amber,
          subtitle: '${stats.activeAmbassadors} active',
        ),
        _buildStatCard(
          'Errors',
          stats.totalErrors.toString(),
          Icons.error,
          Colors.red,
          subtitle: '${stats.criticalErrors} critical',
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color,
      {String? subtitle}) {
    return Card(
      elevation: 4,
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
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(AdminDashboardStats stats) {
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

  Widget _buildUserGrowthChart(AdminDashboardStats stats) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Growth (Last 6 Months)',
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
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 3),
                        const FlSpot(2.6, 2),
                        const FlSpot(4.9, 5),
                        const FlSpot(6.8, 3.1),
                        const FlSpot(8, 4),
                        const FlSpot(9.5, 3),
                        const FlSpot(11, 4),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
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

  Widget _buildQuickActions() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildActionButton(
                  'Send Broadcast',
                  Icons.broadcast_on_personal,
                  Colors.blue,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminBroadcastScreen(),
                    ),
                  ),
                ),
                _buildActionButton(
                  'Manage Users',
                  Icons.people,
                  Colors.green,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminUsersScreen(),
                    ),
                  ),
                ),
                _buildActionButton(
                  'Organizations',
                  Icons.business,
                  Colors.purple,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminOrgsScreen(),
                    ),
                  ),
                ),
                _buildActionButton(
                  'Demo Panel',
                  Icons.science,
                  Colors.teal,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminDemoPanelScreen(),
                    ),
                  ),
                ),
                _buildActionButton(
                  'Export Data',
                  Icons.download,
                  Colors.orange,
                  () => _showExportDialog(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String title, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildErrorsTab() {
    final errorLogs = ref.watch(errorLogsProvider({'limit': 50}));

    return errorLogs.when(
      data: (logs) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(
                _getErrorIcon(log.severity),
                color: _getErrorColor(log.severity),
              ),
              title: Text(
                log.errorType,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(log.errorMessage),
                  const SizedBox(height: 4),
                  Text(
                    'User: ${log.userEmail} • ${_formatDate(log.timestamp)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              trailing: log.isResolved
                  ? const Chip(
                      label: Text('Resolved'), backgroundColor: Colors.green)
                  : IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      onPressed: () => _showResolveErrorDialog(log),
                    ),
              onTap: () => _showErrorDetailsDialog(log),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildActivityTab() {
    final activityLogs = ref.watch(activityLogsProvider({'limit': 50}));

    return activityLogs.when(
      data: (logs) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(
                _getActivityIcon(log.action),
                color: Colors.blue,
              ),
              title: Text(
                log.action.replaceAll('_', ' ').toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${log.targetType}: ${log.targetId}'),
                  const SizedBox(height: 4),
                  Text(
                    'Admin: ${log.adminEmail} • ${_formatDate(log.timestamp)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              onTap: () => _showActivityDetailsDialog(log),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildMonetizationTab() {
    final monetizationSettings = ref.watch(monetizationSettingsProvider);
    final adRevenueStats = ref.watch(adRevenueStatsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          monetizationSettings.when(
            data: (settings) => _buildMonetizationSettings(settings),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
          const SizedBox(height: 24),
          adRevenueStats.when(
            data: (stats) => _buildAdRevenueStats(stats),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ],
      ),
    );
  }

  Widget _buildMonetizationSettings(MonetizationSettings settings) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ad Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingSwitch(
              'Ads for Free Users',
              settings.adsEnabledForFreeUsers,
              (value) => _updateAdSetting('adsEnabledForFreeUsers', value),
            ),
            _buildSettingSwitch(
              'Ads for Children',
              settings.adsEnabledForChildren,
              (value) => _updateAdSetting('adsEnabledForChildren', value),
            ),
            _buildSettingSwitch(
              'Ads for Studio Users',
              settings.adsEnabledForStudioUsers,
              (value) => _updateAdSetting('adsEnabledForStudioUsers', value),
            ),
            _buildSettingSwitch(
              'Ads for Premium Users',
              settings.adsEnabledForPremiumUsers,
              (value) => _updateAdSetting('adsEnabledForPremiumUsers', value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingSwitch(
      String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildAdRevenueStats(AdRevenueStats stats) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ad Revenue Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow(
                'Total Revenue', '\$${stats.totalRevenue.toStringAsFixed(2)}'),
            _buildStatRow('Monthly Revenue',
                '\$${stats.monthlyRevenue.toStringAsFixed(2)}'),
            _buildStatRow('Weekly Revenue',
                '\$${stats.weeklyRevenue.toStringAsFixed(2)}'),
            _buildStatRow(
                'Daily Revenue', '\$${stats.dailyRevenue.toStringAsFixed(2)}'),
            _buildStatRow(
                'Total Impressions', stats.totalImpressions.toString()),
            _buildStatRow('Total Clicks', stats.totalClicks.toString()),
            _buildStatRow('Click Through Rate',
                '${(stats.clickThroughRate * 100).toStringAsFixed(2)}%'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    switch (_selectedIndex) {
      case 0:
        return FloatingActionButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminBroadcastScreen(),
            ),
          ),
          child: const Icon(Icons.broadcast_on_personal),
        );
      case 1:
        return FloatingActionButton(
          onPressed: () => _showResolveErrorDialog(null),
          child: const Icon(Icons.check_circle),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: _selectedIndex == 0,
            onTap: () {
              _tabController.animateTo(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.broadcast_on_personal),
            title: const Text('Broadcast'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminBroadcastScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Users'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminUsersScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Organizations'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminOrgsScreen(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              _showSettingsDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              // Handle logout
            },
          ),
        ],
      ),
    );
  }

  // Helper methods
  IconData _getErrorIcon(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return Icons.info;
      case ErrorSeverity.medium:
        return Icons.warning;
      case ErrorSeverity.high:
        return Icons.error;
      case ErrorSeverity.critical:
        return Icons.dangerous;
    }
  }

  Color _getErrorColor(ErrorSeverity severity) {
    switch (severity) {
      case ErrorSeverity.low:
        return Colors.blue;
      case ErrorSeverity.medium:
        return Colors.orange;
      case ErrorSeverity.high:
        return Colors.red;
      case ErrorSeverity.critical:
        return Colors.purple;
    }
  }

  IconData _getActivityIcon(String action) {
    switch (action) {
      case 'create_broadcast':
        return Icons.broadcast_on_personal;
      case 'update_user_role':
        return Icons.person;
      case 'resolve_error':
        return Icons.check_circle;
      default:
        return Icons.settings;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  // Dialog methods
  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Admin Settings'),
        content: const Text('Settings dialog will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Export as CSV'),
              onTap: () {
                Navigator.pop(context);
                // Handle CSV export
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Export as PDF'),
              onTap: () {
                Navigator.pop(context);
                // Handle PDF export
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showResolveErrorDialog(AdminErrorLog? log) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            log == null ? 'Resolve Error' : 'Resolve Error: ${log.errorType}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (log != null) ...[
              Text('Error: ${log.errorMessage}'),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Resolution Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (log != null && controller.text.isNotEmpty) {
                ref
                    .read(adminActionsProvider)
                    .resolveError(log.id, controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Resolve'),
          ),
        ],
      ),
    );
  }

  void _showErrorDetailsDialog(AdminErrorLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error Details: ${log.errorType}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: ${log.errorMessage}'),
              const SizedBox(height: 8),
              Text('User: ${log.userEmail}'),
              const SizedBox(height: 8),
              Text('Severity: ${log.severity.name}'),
              const SizedBox(height: 8),
              Text('Timestamp: ${_formatDate(log.timestamp)}'),
              if (log.deviceInfo != null) ...[
                const SizedBox(height: 8),
                Text('Device: ${log.deviceInfo}'),
              ],
              if (log.appVersion != null) ...[
                const SizedBox(height: 8),
                Text('App Version: ${log.appVersion}'),
              ],
              const SizedBox(height: 8),
              const Text('Stack Trace:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  log.stackTrace,
                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showActivityDetailsDialog(AdminActivityLog log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Activity: ${log.action}'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Admin: ${log.adminEmail}'),
            const SizedBox(height: 8),
            Text('Target: ${log.targetType} - ${log.targetId}'),
            const SizedBox(height: 8),
            Text('Timestamp: ${_formatDate(log.timestamp)}'),
            const SizedBox(height: 8),
            const Text('Details:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                log.details.toString(),
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _updateAdSetting(String setting, bool value) {
    final currentSettings = ref.read(monetizationSettingsProvider).value;
    if (currentSettings != null) {
      final updatedSettings = currentSettings.copyWith(
        adsEnabledForFreeUsers: setting == 'adsEnabledForFreeUsers'
            ? value
            : currentSettings.adsEnabledForFreeUsers,
        adsEnabledForChildren: setting == 'adsEnabledForChildren'
            ? value
            : currentSettings.adsEnabledForChildren,
        adsEnabledForStudioUsers: setting == 'adsEnabledForStudioUsers'
            ? value
            : currentSettings.adsEnabledForStudioUsers,
        adsEnabledForPremiumUsers: setting == 'adsEnabledForPremiumUsers'
            ? value
            : currentSettings.adsEnabledForPremiumUsers,
      );
      ref
          .read(adminActionsProvider)
          .updateMonetizationSettings(updatedSettings);
    }
  }
}
