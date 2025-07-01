import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:appoint/models/admin_user.dart';
import 'package:appoint/models/organization.dart';
import 'package:appoint/models/analytics.dart';
import 'package:appoint/models/admin_dashboard_stats.dart';
import 'package:appoint/models/admin_broadcast_message.dart';
import 'package:appoint/services/admin_service.dart';

final adminServiceProvider = Provider<AdminService>((final ref) => AdminService());

// Admin role provider that checks Firebase Auth custom claims
final isAdminProvider = FutureProvider<bool>((final ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return false;

  try {
    final tokenResult = await user.getIdTokenResult(true);
    return tokenResult.claims?['admin'] == true;
  } catch (e) {
    return false;
  }
});

// User Management
final allUsersProvider = FutureProvider<List<AdminUser>>((final ref) {
  return ref.read(adminServiceProvider).fetchAllUsers();
});

// Organization Management
final orgsProvider = FutureProvider<List<Organization>>((final ref) {
  return ref.read(adminServiceProvider).fetchOrganizations();
});

// Analytics
final analyticsProvider = FutureProvider<Analytics>((final ref) {
  return ref.read(adminServiceProvider).fetchAnalytics();
});

// Admin Dashboard Stats
final adminDashboardStatsProvider = FutureProvider<AdminDashboardStats>((final ref) {
  return ref.read(adminServiceProvider).fetchAdminDashboardStats();
});

// Error Logs
final errorLogsProvider =
    FutureProvider.family<List<AdminErrorLog>, Map<String, dynamic>>(
        (final ref, final filters) {
  final severity = filters['severity'] as String?;
  final isResolved = filters['isResolved'] as bool?;
  final limit = filters['limit'] as int? ?? 50;

  return ref.read(adminServiceProvider).fetchErrorLogs(
        limit: limit,
        severity: severity != null
            ? ErrorSeverity.values.firstWhere((final e) => e.name == severity)
            : null,
        isResolved: isResolved,
      );
});

// Activity Logs
final activityLogsProvider =
    FutureProvider.family<List<AdminActivityLog>, Map<String, dynamic>>(
        (final ref, final filters) {
  final adminId = filters['adminId'] as String?;
  final action = filters['action'] as String?;
  final limit = filters['limit'] as int? ?? 50;

  return ref.read(adminServiceProvider).fetchActivityLogs(
        limit: limit,
        adminId: adminId,
        action: action,
      );
});

// Ad Revenue Stats
final adRevenueStatsProvider = FutureProvider<AdRevenueStats>((final ref) {
  return ref.read(adminServiceProvider).fetchAdRevenueStats();
});

// Monetization Settings
final monetizationSettingsProvider =
    FutureProvider<MonetizationSettings>((final ref) {
  return ref.read(adminServiceProvider).fetchMonetizationSettings();
});

// Broadcast Messages
final broadcastMessagesProvider =
    FutureProvider<List<AdminBroadcastMessage>>((final ref) {
  return ref.read(adminServiceProvider).fetchBroadcastMessages();
});

// Notifiers for admin actions
final adminActionsProvider = Provider<AdminActions>((final ref) {
  return AdminActions(ref.read(adminServiceProvider));
});

class AdminActions {
  final AdminService _adminService;

  AdminActions(this._adminService);

  Future<void> updateUserRole(final String uid, final String role) async {
    await _adminService.updateUserRole(uid, role);
  }

  Future<void> resolveError(final String errorId, final String resolutionNotes) async {
    await _adminService.resolveError(errorId, resolutionNotes);
  }

  Future<void> updateMonetizationSettings(final MonetizationSettings settings) async {
    await _adminService.updateMonetizationSettings(settings);
  }

  Future<void> createBroadcastMessage(final AdminBroadcastMessage message) async {
    await _adminService.createBroadcastMessage(message);
  }

  Future<String> exportDataAsCSV(final String dataType,
      {final Map<String, dynamic>? filters}) async {
    return await _adminService.exportDataAsCSV(dataType, filters: filters);
  }

  Future<String> exportDataAsPDF(final String dataType,
      {final Map<String, dynamic>? filters}) async {
    return await _adminService.exportDataAsPDF(dataType, filters: filters);
  }
}
