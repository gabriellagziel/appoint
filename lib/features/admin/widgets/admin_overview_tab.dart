import 'package:appoint/features/admin/admin_broadcast_screen.dart';
import 'package:appoint/features/admin/admin_orgs_screen.dart';
import 'package:appoint/features/admin/admin_users_screen.dart';
import 'package:appoint/features/admin/widgets/analytics/revenue_pie_chart.dart';
import 'package:appoint/features/admin/widgets/analytics/stat_card.dart';
import 'package:appoint/features/admin/widgets/analytics/user_growth_line_chart.dart';
import 'package:appoint/models/admin_dashboard_stats.dart';
import 'package:appoint/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminOverviewTab extends ConsumerWidget {
  const AdminOverviewTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardStats = ref.watch(adminDashboardStatsProvider);

    return dashboardStats.when(
      data: (stats) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsCards(stats),
            const SizedBox(height: 24),
            RevenuePieChart(stats: stats),
            const SizedBox(height: 24),
            const UserGrowthLineChart(),
            const SizedBox(height: 24),
            _buildQuickActions(context),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, final stack) => Center(
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

  Widget _buildStatsCards(AdminDashboardStats stats) => GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        StatCard(
          title: 'Total Users',
          value: stats.totalUsers.toString(),
          icon: Icons.people,
          color: Colors.blue,
          subtitle: '${stats.activeUsers} active',
        ),
        StatCard(
          title: 'Total Bookings',
          value: stats.totalBookings.toString(),
          icon: Icons.calendar_today,
          color: Colors.green,
          subtitle: '${stats.completedBookings} completed',
        ),
        StatCard(
          title: 'Total Revenue',
          value: '\$${stats.totalRevenue.toStringAsFixed(2)}',
          icon: Icons.attach_money,
          color: Colors.orange,
          subtitle: 'Ad: \$${stats.adRevenue.toStringAsFixed(2)}',
        ),
        StatCard(
          title: 'Organizations',
          value: stats.totalOrganizations.toString(),
          icon: Icons.business,
          color: Colors.purple,
          subtitle: '${stats.activeOrganizations} active',
        ),
        StatCard(
          title: 'Ambassadors',
          value: stats.totalAmbassadors.toString(),
          icon: Icons.star,
          color: Colors.amber,
          subtitle: '${stats.activeAmbassadors} active',
        ),
        StatCard(
          title: 'Errors',
          value: stats.totalErrors.toString(),
          icon: Icons.error,
          color: Colors.red,
          subtitle: '${stats.criticalErrors} critical',
        ),
      ],
    );

  Widget _buildQuickActions(BuildContext context) => Card(
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
                  'Export Data',
                  Icons.download,
                  Colors.orange,
                  () => _showExportDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  Widget _buildActionButton(final String title, final IconData icon,
      Color color, final VoidCallback onPressed,) => ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );

  void _showExportDialog(BuildContext context) {
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
}
