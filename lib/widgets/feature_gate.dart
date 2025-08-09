import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/remote_config_provider.dart';

class FeatureGate extends ConsumerWidget {
  final String featureName;
  final Widget child;
  final Widget? fallback;

  const FeatureGate({
    super.key,
    required this.featureName,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(_getFeatureProvider(featureName));

    if (isEnabled) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }

  Provider<bool> _getFeatureProvider(String featureName) {
    switch (featureName) {
      case 'family_ui':
        return familyUiEnabledProvider;
      case 'family_calendar':
        return familyCalendarEnabledProvider;
      case 'family_reminder_assignment':
        return familyReminderAssignmentEnabledProvider;
      default:
        return Provider<bool>((ref) => false);
    }
  }
}

class FeatureGateWithMessage extends ConsumerWidget {
  final String featureName;
  final Widget child;
  final String message;

  const FeatureGateWithMessage({
    super.key,
    required this.featureName,
    required this.child,
    this.message = 'Feature not available',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(_getFeatureProvider(featureName));

    if (isEnabled) {
      return child;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'This feature is currently disabled',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Provider<bool> _getFeatureProvider(String featureName) {
    switch (featureName) {
      case 'family_ui':
        return familyUiEnabledProvider;
      case 'family_calendar':
        return familyCalendarEnabledProvider;
      case 'family_reminder_assignment':
        return familyReminderAssignmentEnabledProvider;
      default:
        return Provider<bool>((ref) => false);
    }
  }
}

class FeatureGateBuilder extends ConsumerWidget {
  final String featureName;
  final Widget Function(bool isEnabled) builder;

  const FeatureGateBuilder({
    super.key,
    required this.featureName,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(_getFeatureProvider(featureName));
    return builder(isEnabled);
  }

  Provider<bool> _getFeatureProvider(String featureName) {
    switch (featureName) {
      case 'family_ui':
        return familyUiEnabledProvider;
      case 'family_calendar':
        return familyCalendarEnabledProvider;
      case 'family_reminder_assignment':
        return familyReminderAssignmentEnabledProvider;
      default:
        return Provider<bool>((ref) => false);
    }
  }
}
