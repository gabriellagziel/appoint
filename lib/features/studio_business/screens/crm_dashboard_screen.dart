import 'package:appoint/models/appointment.dart';
import 'package:appoint/models/business_profile.dart';
import 'package:appoint/providers/studio_business_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CRMDashboardScreen extends ConsumerWidget {
  const CRMDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final profileAsync = ref.watch(businessProfileProvider);

    return Scaffold(
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, final _) => Center(child: Text('Error: $e')),
        data: (profile) => Row(
          children: [
            // Sidebar
            Container(
              width: 250,
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        if (profile.logoUrl != null)
                          Image.network(profile.logoUrl!, width: 64, height: 64)
                        else
                          const Icon(Icons.business, size: 64),
                        const SizedBox(height: 8),
                        Text(
                          profile.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold,),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),

                  // Navigation
                  Expanded(
                    child: ListView(
                      children: [
                        _buildNavItem(
                          context,
                          'Dashboard',
                          Icons.dashboard,
                          () {},
                          isSelected: true,
                        ),
                        _buildNavItem(
                          context,
                          'Clients',
                          Icons.people,
                          () {},
                        ),
                        _buildNavItem(
                          context,
                          'Appointments',
                          Icons.calendar_today,
                          () {},
                        ),
                        _buildNavItem(
                          context,
                          'Analytics',
                          Icons.analytics,
                          () {},
                        ),
                        _buildNavItem(
                          context,
                          'Messages',
                          Icons.message,
                          () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            const Expanded(
              child: DashboardHome(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(final BuildContext context, final String title,
      final IconData icon, final VoidCallback onTap,
      {bool isSelected = false,}) => ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
      selected: isSelected,
    );
}

class DashboardHome extends ConsumerWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final profileAsync = ref.watch(businessProfileProvider);
    final statsAsync = ref.watch(dashboardStatsProvider);

    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, final _) => Center(child: Text('Error: $e')),
      data: (profile) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back!',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        "Here's what's happening with ${profile.name}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                // Quick Stats
                Row(
                  children: [
                    _buildStatCard('Weekly Bookings',
                        '${statsAsync['totalBookings'] ?? 0}',),
                    const SizedBox(width: 16),
                    _buildStatCard(
                        'Total Clients', '${statsAsync['totalClients'] ?? 0}',),
                    const SizedBox(width: 16),
                    _buildStatCard('Upcoming',
                        '${statsAsync['upcomingAppointments'] ?? 0}',),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Dashboard Widgets
            Row(
              children: [
                Expanded(
                  child: _buildKPICard(
                    'Total Appointments',
                    '${statsAsync['totalAppointments'] ?? 0}',
                    Icons.calendar_today,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildKPICard(
                    'Active Clients',
                    '${statsAsync['totalClients'] ?? 0}',
                    Icons.people,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildKPICard(
                    'Revenue',
                    r'$1,200',
                    Icons.attach_money,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildKPICard(
                    'Growth',
                    '+12%',
                    Icons.trending_up,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildQuickAction('New Booking', Icons.add_circle, () {}),
                const SizedBox(width: 16),
                _buildQuickAction('Add Client', Icons.person_add, () {}),
                const SizedBox(width: 16),
                _buildQuickAction('View Calendar', Icons.calendar_month, () {}),
                const SizedBox(width: 16),
                _buildQuickAction('Send Message', Icons.message, () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, final String value) => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(value,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );

  Widget _buildKPICard(
      String title, final String value, final IconData icon,) => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(height: 8),
            Text(value,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            Text(title, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );

  Widget _buildQuickAction(
      String title, final IconData icon, final VoidCallback onTap,) => Expanded(
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(icon, size: 32),
                const SizedBox(height: 8),
                Text(title, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
}

// Real screens for other sections
class ClientsScreen extends ConsumerWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final clientsAsync = ref.watch(clientsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Clients')),
      body: clientsAsync.when(
        data: (clients) => ListView.builder(
          itemCount: clients.length,
          itemBuilder: (context, final index) {
            final client = clients[index];
            return ListTile(
              title: Text(client['name'] ?? 'Unknown'),
              subtitle: Text(client['email'] ?? 'No email'),
              leading: CircleAvatar(
                child: Text((client['name'] ?? 'U')[0].toUpperCase()),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, final stack) =>
            Center(child: Text('Error: $error')),
      ),
    );
  }
}

class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final appointmentsAsync = ref.watch(appointmentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Appointments')),
      body: appointmentsAsync.when(
        data: (appointments) => ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, final index) {
            final appointment = appointments[index];
            return ListTile(
              title: Text(appointment.title),
              subtitle: Text(appointment.dateTime.toString()),
              leading: const Icon(Icons.calendar_today),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, final stack) =>
            Center(child: Text('Error: $error')),
      ),
    );
  }
}
