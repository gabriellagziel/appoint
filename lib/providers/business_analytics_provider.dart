import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/business_analytics.dart';
import '../services/business_analytics_service.dart';

final businessAnalyticsServiceProvider =
    Provider<BusinessAnalyticsService>((ref) => BusinessAnalyticsService());

final bookingsOverTimeProvider = FutureProvider<List<TimeSeriesPoint>>((ref) {
  return ref
      .read(businessAnalyticsServiceProvider)
      .fetchBookingsOverTime();
});

final serviceDistributionProvider =
    FutureProvider<List<ServiceDistribution>>((ref) {
  return ref
      .read(businessAnalyticsServiceProvider)
      .fetchServiceDistribution();
});

final revenueByStaffProvider = FutureProvider<List<RevenueByStaff>>((ref) {
  return ref
      .read(businessAnalyticsServiceProvider)
      .fetchRevenueByStaff();
});
