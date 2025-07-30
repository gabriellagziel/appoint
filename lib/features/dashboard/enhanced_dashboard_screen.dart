// import 'package:appoint/features/dashboard/enhanced_dashboard_screen.dart'; // Unused
// import 'package:appoint/features/rewards/screens/rewards_screen.dart'; // Unused
// import 'package:appoint/features/subscriptions/screens/subscription_screen.dart'; // Unused
// import 'package:appoint/features/messaging/screens/messages_list_screen.dart'; // Unused
// import 'package:appoint/features/search/screens/search_screen.dart'; // Unused
import 'package:appoint/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final dashboardStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  // TODO: Implement dashboard stats
  return {
    'upcomingMeetings': 3,
    'unreadMessages': 5,
    'rewardsPoints': 1250,
    'subscriptionStatus': 'active',
  };
});

class EnhancedDashboardScreen extends ConsumerWidget {
  const EnhancedDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotifications(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context),
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
              Text('Failed to load dashboard'),
              const SizedBox(height: 8),
              Text(error.toString()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(dashboardStatsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (stats) => _buildDashboard(context, ref, stats, l10n),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, WidgetRef ref, Map<String, dynamic> stats, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          _buildWelcomeSection(context, stats),
          
          const SizedBox(height: 24),
          
          // Quick actions
          _buildQuickActions(context, ref),
          
          const SizedBox(height: 24),
          
          // Stats cards
          _buildStatsCards(context, stats),
          
          const SizedBox(height: 24),
          
          // Recent activity
          _buildRecentActivity(context),
          
          const SizedBox(height: 24),
          
          // Upcoming meetings
          _buildUpcomingMeetings(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.person, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back!',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'You have ${stats['upcomingMeetings']} upcoming meetings',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildQuickActionCard(
              context,
              'Search',
              Icons.search,
              Colors.blue,
              () => context.push('/search'),
            ),
            _buildQuickActionCard(
              context,
              'Messages',
              Icons.chat,
              Colors.green,
              () => context.push('/messages'),
            ),
            _buildQuickActionCard(
              context,
              'Rewards',
              Icons.card_giftcard,
              Colors.orange,
              () => context.push('/rewards'),
            ),
            _buildQuickActionCard(
              context,
              'Subscription',
              Icons.star,
              Colors.purple,
              () => context.push('/subscription'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, Map<String, dynamic> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Stats',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Upcoming',
                '${stats['upcomingMeetings']}',
                Icons.calendar_today,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                'Messages',
                '${stats['unreadMessages']}',
                Icons.chat,
                Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                'Points',
                '${stats['rewardsPoints']}',
                Icons.stars,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                'Status',
                stats['subscriptionStatus'] == 'active' ? 'Premium' : 'Free',
                Icons.verified,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
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

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            itemBuilder: (context, index) {
              final activities = [
                {'title': 'Meeting confirmed', 'time': '2 hours ago', 'icon': Icons.check_circle, 'color': Colors.green},
                {'title': 'New message received', 'time': '4 hours ago', 'icon': Icons.chat, 'color': Colors.blue},
                {'title': 'Points earned', 'time': '1 day ago', 'icon': Icons.stars, 'color': Colors.orange},
              ];
              final activity = activities[index];
              
              return ListTile(
                leading: Icon(activity['icon'] as IconData, color: activity['color'] as Color),
                title: Text(activity['title'] as String),
                subtitle: Text(activity['time'] as String),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Navigate to activity details
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingMeetings(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Upcoming Meetings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.push('/calendar'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            itemBuilder: (context, index) {
              final meetings = [
                {'title': 'Dental Appointment', 'time': 'Tomorrow, 10:00 AM', 'location': 'Dr. Smith\'s Office'},
                {'title': 'Team Meeting', 'time': 'Friday, 2:00 PM', 'location': 'Conference Room A'},
              ];
              final meeting = meetings[index];
              
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue[100],
                  child: Icon(Icons.event, color: Colors.blue),
                ),
                title: Text(meeting['title'] as String),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meeting['time'] as String),
                    Text(meeting['location'] as String, style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // TODO: Navigate to meeting details
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showNotifications(BuildContext context) {
    // TODO: Implement notifications screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifications coming soon!')),
    );
  }

  void _showSettings(BuildContext context) {
    // TODO: Navigate to settings screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings coming soon!')),
    );
  }
} 