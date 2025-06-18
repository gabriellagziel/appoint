import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/dashboard_provider.dart';
import '../../l10n/app_localizations.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dashboard)),
      body: statsAsync.when(
        data: (stats) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    title: Text('Total Appointments'),
                    subtitle: Text('${stats.totalAppointments}'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Completed Appointments'),
                    subtitle: Text('${stats.completedAppointments}'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Pending Invites'),
                    subtitle: Text('${stats.pendingInvites}'),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text('Revenue'),
                    subtitle: Text('\$${stats.revenue.toStringAsFixed(2)}'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(child: Text('Error loading stats')),
      ),
    );
  }
}
