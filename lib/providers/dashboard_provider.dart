import 'package:appoint/models/dashboard_stats.dart';
import 'package:appoint/services/dashboard_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardServiceProvider =
    Provider<DashboardService>((ref) => DashboardService());

final dashboardStatsProvider = StreamProvider<DashboardStats>((ref) => ref.read(dashboardServiceProvider).watchDashboardStats());
