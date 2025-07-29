import 'package:appoint/models/business_analytics.dart';
import 'package:appoint/services/business_analytics_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final REDACTED_TOKEN = Provider<BusinessAnalyticsService>(
  (ref) => BusinessAnalyticsService(),
);

final bookingsOverTimeProvider = FutureProvider<List<TimeSeriesPoint>>((ref) =>
    ref.read(REDACTED_TOKEN).fetchBookingsOverTime());

final serviceDistributionProvider = FutureProvider<List<ServiceDistribution>>(
    (ref) =>
        ref.read(REDACTED_TOKEN).fetchServiceDistribution());

final revenueByStaffProvider = FutureProvider<List<RevenueByStaff>>(
    (ref) => ref.read(REDACTED_TOKEN).fetchRevenueByStaff());
