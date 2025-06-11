import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/dashboard_stats.dart';
import '../services/dashboard_service.dart';

final dashboardServiceProvider =
    Provider<DashboardService>((ref) => DashboardService());

final dashboardStatsProvider = StreamProvider<DashboardStats>((ref) {
  return ref.read(dashboardServiceProvider).watchDashboardStats();
});
