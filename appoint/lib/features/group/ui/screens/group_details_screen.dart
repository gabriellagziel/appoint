import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../providers/group_providers.dart';
import '../../services/group_metrics_service.dart';

final _groupMetricsProvider = StreamProvider.autoDispose((ref) {
  final service = GroupMetricsService();
  return service.streamMetrics();
});

class GroupDetailsScreen extends ConsumerWidget {
  final String groupId;

  const GroupDetailsScreen({
    super.key,
    required this.groupId,
  });

  Widget _buildUsageBanner(WidgetRef ref) {
    final metricsAsync = ref.watch(_groupMetricsProvider);
    return metricsAsync.when(
      data: (metrics) {
        final isWarn = metrics.nearLimit && !metrics.atOrOverLimit;
        final isError = metrics.atOrOverLimit;
        if (!isWarn && !isError) return const SizedBox.shrink();
        final color = isError ? Colors.red.shade50 : Colors.orange.shade50;
        final border = isError ? Colors.red.shade200 : Colors.orange.shade200;
        final title =
            isError ? 'Group limits reached' : 'Approaching group limits';
        final subtitle =
            'Members: ${metrics.membersCount}, Meetings: ${metrics.meetingsCount}';
        return Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Icon(isError ? Icons.error_outline : Icons.warning_amber_rounded,
                  color: isError ? Colors.red : Colors.orange),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Upgrade to Pro'),
              )
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupAsync = ref.watch(groupProvider(groupId));
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: groupAsync.when(
          data: (group) => Text(group?.name ?? 'Group Details'),
          loading: () => const Text('Group Details'),
          error: (_, __) => const Text('Group Details'),
        ),
      ),
      body: Column(
        children: [
          _buildUsageBanner(ref),
          Expanded(
            child: groupAsync.when(
              data: (group) {
                if (group == null) {
                  return const Center(child: Text('Group not found'));
                }
                final isMember = group.members.contains(authState?.user?.uid);
                if (!isMember) {
                  return const Center(
                    child: Text('You are not a member of this group'),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      Text('Group ID: ${groupId}',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text('Members: ${group.members.length}'),
                      const SizedBox(height: 16),
                      const Text('More group details coming soon...'),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load group details',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.refresh(groupProvider(groupId)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
