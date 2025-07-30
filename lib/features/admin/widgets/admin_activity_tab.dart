import 'package:appoint/models/admin_dashboard_stats.dart';
import 'package:appoint/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminActivityTab extends ConsumerWidget {
  const AdminActivityTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityLogs = ref.watch(activityLogsProvider({'limit': 50}));

    return activityLogs.when(
      data: (logs) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: logs.length,
        itemBuilder: (context, final index) {
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
              onTap: () => _showActivityDetailsDialog(context, log),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, final stack) => Center(child: Text('Error: $error')),
    );
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

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';

  void _showActivityDetailsDialog(BuildContext context, AdminActivityLog log) {
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
            const Text(
              'Details:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
}
