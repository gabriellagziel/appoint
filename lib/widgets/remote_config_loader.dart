import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/remote_config_provider.dart';

class RemoteConfigLoader extends ConsumerWidget {
  final Widget child;
  final Widget? loadingWidget;

  const RemoteConfigLoader({
    super.key,
    required this.child,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteConfig = ref.watch(remoteConfigProvider);
    final isInitialized = true;

    // Show loading while Remote Config is initializing
    if (!isInitialized) {
      return loadingWidget ?? const _DefaultLoadingWidget();
    }

    return child;
  }
}

class _DefaultLoadingWidget extends StatelessWidget {
  const _DefaultLoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Loading features...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait while we configure your experience',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class RemoteConfigStatusWidget extends ConsumerWidget {
  const RemoteConfigStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyUiEnabled = ref.watch(familyUiEnabledProvider);
    final familyCalendarEnabled = ref.watch(familyCalendarEnabledProvider);
    final familyReminderAssignmentEnabled =
        ref.watch(REDACTED_TOKEN);

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Feature Flags Status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _FeatureFlagRow(
              name: 'Family UI',
              enabled: familyUiEnabled,
            ),
            _FeatureFlagRow(
              name: 'Family Calendar',
              enabled: familyCalendarEnabled,
            ),
            _FeatureFlagRow(
              name: 'Reminder Assignment',
              enabled: familyReminderAssignmentEnabled,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureFlagRow extends StatelessWidget {
  final String name;
  final bool enabled;

  const _FeatureFlagRow({
    required this.name,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            color: enabled ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(name),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: enabled ? Colors.green[100] : Colors.red[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              enabled ? 'ON' : 'OFF',
              style: TextStyle(
                color: enabled ? Colors.green[800] : Colors.red[800],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
