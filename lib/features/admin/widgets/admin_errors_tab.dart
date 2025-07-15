import 'package:appoint/models/admin_dashboard_stats.dart';
import 'package:appoint/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminErrorsTab extends ConsumerWidget {
  const AdminErrorsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorLogs = ref.watch(errorLogsProvider({'limit': 50}));

    return errorLogs.when(
      data: (logs) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: logs.length,
        itemBuilder: (context, final index) {
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
                      label: Text('Resolved'), backgroundColor: Colors.green,)
                  : IconButton(
                      icon: const Icon(Icons.check_circle_outline),
                      onPressed: () =>
                          _showResolveErrorDialog(context, ref, log),
                    ),
              onTap: () => _showErrorDetailsDialog(context, log),
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, final stack) => Center(child: Text('Error: $error')),
    );
  }

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

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';

  void _showResolveErrorDialog(
      BuildContext context, WidgetRef ref, AdminErrorLog? log,) {
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

  void _showErrorDetailsDialog(BuildContext context, AdminErrorLog log) {
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
                  style: TextStyle(fontWeight: FontWeight.bold),),
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
}
