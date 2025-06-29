import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/dashboard_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/loading_state.dart';
import '../../widgets/error_state.dart';
import '../../widgets/responsive_scaffold.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_breakpoints.dart';

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
          final cards = [
            _StatsCard(
                title: 'Total Appointments',
                value: '${stats.totalAppointments}'),
            _StatsCard(
                title: 'Completed Appointments',
                value: '${stats.completedAppointments}'),
            _StatsCard(
                title: 'Pending Invites', value: '${stats.pendingInvites}'),
            _StatsCard(
                title: 'Revenue',
                value: '\$${stats.revenue.toStringAsFixed(2)}'),
          ];

          return ResponsiveScaffold(
            mobile: Column(children: cards),
            tablet: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              shrinkWrap: true,
              children: cards,
            ),
            desktop: GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              shrinkWrap: true,
              children: cards,
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

class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
