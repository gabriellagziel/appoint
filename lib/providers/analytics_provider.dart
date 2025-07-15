import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/analytics_service.dart';

/// Provider for the AnalyticsService
final analyticsProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});