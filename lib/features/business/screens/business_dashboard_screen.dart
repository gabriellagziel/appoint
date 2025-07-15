import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessDashboardScreen extends ConsumerWidget {
  const BusinessDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) => Scaffold(
      appBar: AppBar(
        title: const Text('Business Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context),
            const SizedBox(height: 24),
            _buildStatsGrid(context),
            const SizedBox(height: 24),
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildRecentActivity(context),
          ],
        ),
      ),
    );

  Widget _buildWelcomeCard(BuildContext context) => Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Your Business Dashboard',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your appointments, clients, and business analytics all in one place.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );

  Widget _buildStatsGrid(BuildContext context) => GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          context,
          'Total Appointments',
          '24',
          Icons.calendar_today,
          Colors.blue,
        ),
        _buildStatCard(
          context,
          'Active Clients',
          '12',
          Icons.people,
          Colors.green,
        ),
        _buildStatCard(
          context,
          'Revenue This Month',
          r'$2,450',
          Icons.attach_money,
          Colors.orange,
        ),
        _buildStatCard(
          context,
          'Pending Requests',
          '3',
          Icons.pending,
          Colors.red,
        ),
      ],
    );

  Widget _buildStatCard(final BuildContext context, final String title,
      String value, final IconData icon, final Color color,) => Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

  Widget _buildQuickActions(BuildContext context) => Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    'New Appointment',
                    Icons.add_circle,
                    Colors.blue,
                    () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Add Client',
                    Icons.person_add,
                    Colors.green,
                    () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    'View Calendar',
                    Icons.calendar_month,
                    Colors.orange,
                    () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    context,
                    'Analytics',
                    Icons.analytics,
                    Colors.purple,
                    () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  Widget _buildActionButton(final BuildContext context, final String label,
      IconData icon, final Color color, final VoidCallback onTap,) => ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );

  Widget _buildRecentActivity(BuildContext context) => Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildActivityItem(
              context,
              'New appointment booked',
              'John Doe - Haircut',
              '2 hours ago',
              Icons.calendar_today,
              Colors.blue,
            ),
            _buildActivityItem(
              context,
              'Client added',
              'Jane Smith',
              '4 hours ago',
              Icons.person_add,
              Colors.green,
            ),
            _buildActivityItem(
              context,
              'Payment received',
              r'$85.00 - Massage session',
              '6 hours ago',
              Icons.payment,
              Colors.orange,
            ),
            _buildActivityItem(
              context,
              'Appointment cancelled',
              'Mike Johnson - Consultation',
              '1 day ago',
              Icons.cancel,
              Colors.red,
            ),
          ],
        ),
      ),
    );

  Widget _buildActivityItem(
      final BuildContext context,
      final String title,
      final String subtitle,
      final String time,
      final IconData icon,
      Color color,) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500]),
          ),
        ],
      ),
    );
}
