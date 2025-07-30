import 'package:appoint/models/business_analytics.dart';
import 'package:appoint/services/business_analytics_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final businessAnalyticsServiceProvider = Provider<BusinessAnalyticsService>(
  (ref) => BusinessAnalyticsService(),
);

final bookingsOverTimeProvider = FutureProvider<List<TimeSeriesPoint>>((ref) =>
    ref.read(businessAnalyticsServiceProvider).fetchBookingsOverTime());

final serviceDistributionProvider = FutureProvider<List<ServiceDistribution>>(
    (ref) =>
        ref.read(businessAnalyticsServiceProvider).fetchServiceDistribution());

final revenueByStaffProvider = FutureProvider<List<RevenueByStaff>>(
    (ref) => ref.read(businessAnalyticsServiceProvider).fetchRevenueByStaff());
