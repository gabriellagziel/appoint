import 'package:appoint/services/analytics_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the AnalyticsService
final analyticsProvider =
    Provider<AnalyticsService>((ref) => AnalyticsService());
