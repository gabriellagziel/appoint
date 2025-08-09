import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/analytics_service.dart';

// Analytics Provider
final analyticsProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});

// Analytics event providers
final familyDashboardOpenProvider = FutureProvider<void>((ref) async {
  final analytics = ref.read(analyticsProvider);
  await analytics.logFamilyDashboardOpen();
});

final familyCalendarViewProvider =
    FutureProvider.family<void, String>((ref, filter) async {
  final analytics = ref.read(analyticsProvider);
  await analytics.logFamilyCalendarView(filter: filter);
});

final reminderCreatedProvider =
    FutureProvider.family<void, String>((ref, assignee) async {
  final analytics = ref.read(analyticsProvider);
  await analytics.logReminderCreated(assignee: assignee);
});

final rulesBlockedProvider =
    FutureProvider.family<void, Map<String, String>>((ref, params) async {
  final analytics = ref.read(analyticsProvider);
  await analytics.logRulesBlocked(
    collection: params['collection']!,
    operation: params['operation']!,
  );
});

// User properties provider
final setUserPropertiesProvider =
    FutureProvider.family<void, Map<String, dynamic>>((ref, properties) async {
  final analytics = ref.read(analyticsProvider);
  await analytics.setUserProperties(
    userId: properties['userId']!,
    userRole: properties['userRole'],
    hasFamily: properties['hasFamily'],
  );
});
