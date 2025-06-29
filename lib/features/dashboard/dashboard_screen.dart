import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/dashboard_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/loading_state.dart';
import '../../widgets/error_state.dart';
import '../../theme/app_spacing.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final statsAsync = ref.watch(dashboardStatsProvider);

    return AppScaffold(
      title: l10n.dashboard,
      body: statsAsync.when(
        data: (stats) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
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
        loading: () => const LoadingState(),
        error: (_, __) => const ErrorState(
          title: 'Error',
          description: 'Error loading stats',
        ),
      ),
    );
  }
}
