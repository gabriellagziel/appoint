import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/models/dashboard_stats.dart';
import 'package:appoint/services/dashboard_service.dart';

final dashboardServiceProvider =
    Provider<DashboardService>((final ref) => DashboardService());

final dashboardStatsProvider = StreamProvider<DashboardStats>((final ref) {
  return ref.read(dashboardServiceProvider).watchDashboardStats();
});
