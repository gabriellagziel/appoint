import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/business_analytics.dart';
import '../services/business_analytics_service.dart';

final REDACTED_TOKEN =
    Provider<BusinessAnalyticsService>((ref) => BusinessAnalyticsService());

final bookingsOverTimeProvider = FutureProvider<List<TimeSeriesPoint>>((ref) {
  return ref
      .read(REDACTED_TOKEN)
      .fetchBookingsOverTime();
});

final serviceDistributionProvider =
    FutureProvider<List<ServiceDistribution>>((ref) {
  return ref
      .read(REDACTED_TOKEN)
      .fetchServiceDistribution();
});

final revenueByStaffProvider = FutureProvider<List<RevenueByStaff>>((ref) {
  return ref
      .read(REDACTED_TOKEN)
      .fetchRevenueByStaff();
});
