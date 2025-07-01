import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/models/business_analytics.dart';
import 'package:appoint/services/business_analytics_service.dart';

final businessAnalyticsServiceProvider =
    Provider<BusinessAnalyticsService>((final ref) => BusinessAnalyticsService());

final bookingsOverTimeProvider = FutureProvider<List<TimeSeriesPoint>>((final ref) {
  return ref
      .read(businessAnalyticsServiceProvider)
      .fetchBookingsOverTime();
});

final serviceDistributionProvider =
    FutureProvider<List<ServiceDistribution>>((final ref) {
  return ref
      .read(businessAnalyticsServiceProvider)
      .fetchServiceDistribution();
});

final revenueByStaffProvider = FutureProvider<List<RevenueByStaff>>((final ref) {
  return ref
      .read(businessAnalyticsServiceProvider)
      .fetchRevenueByStaff();
});
