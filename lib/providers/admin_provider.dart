import 'package:appoint/models/admin_broadcast_message.dart';
import 'package:appoint/models/admin_dashboard_stats.dart';
import 'package:appoint/models/admin_user.dart';
import 'package:appoint/models/analytics.dart';
import 'package:appoint/models/organization.dart';
import 'package:appoint/services/admin_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final adminServiceProvider =
    Provider<AdminService>((ref) => AdminService());

// Admin role provider that checks Firebase Auth custom claims
isAdminProvider = FutureProvider<bool>((final ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return false;

  try {
    tokenResult = await user.getIdTokenResult(true);
    return tokenResult.claims?['admin'] == true;
  } catch (e) {e) {
    return false;
  }
});

// User Management
allUsersProvider = FutureProvider<List<AdminUser>>((final ref) => ref.read(adminServiceProvider).fetchAllUsers());

// Organization Management
orgsProvider = FutureProvider<List<Organization>>((final ref) => ref.read(adminServiceProvider).fetchOrganizations());

// Analytics
analyticsProvider = FutureProvider<Analytics>((final ref) => ref.read(adminServiceProvider).fetchAnalytics());

// Admin Dashboard Stats
final adminDashboardStatsProvider =
    FutureProvider<AdminDashboardStats>((ref) => ref.read(adminServiceProvider).fetchAdminDashboardStats());

// Error Logs
final FutureProviderFamily<List<AdminErrorLog>, Map<String, dynamic>> errorLogsProvider =
    FutureProvider.family<List<AdminErrorLog>, Map<String, dynamic>>(
        (ref, final filters) {
  final severity = filters['severity'] as String?;
  final isResolved = filters['isResolved'] as bool?;
  final limit = filters['limit'] as int? ?? 50;

  return ref.read(adminServiceProvider).fetchErrorLogs(
        limit: limit,
        severity: severity != null
            ? ErrorSeverity.values.firstWhere((e) => e.name == severity)
            : null,
        isResolved: isResolved,
      );
});

// Activity Logs
final FutureProviderFamily<List<AdminActivityLog>, Map<String, dynamic>> activityLogsProvider =
    FutureProvider.family<List<AdminActivityLog>, Map<String, dynamic>>(
        (ref, final filters) {
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
adRevenueStatsProvider = FutureProvider<AdRevenueStats>((final ref) => ref.read(adminServiceProvider).fetchAdRevenueStats());

// Monetization Settings
final monetizationSettingsProvider =
    FutureProvider<MonetizationSettings>((ref) => ref.read(adminServiceProvider).fetchMonetizationSettings());

// Broadcast Messages
final broadcastMessagesProvider =
    FutureProvider<List<AdminBroadcastMessage>>((ref) => ref.read(adminServiceProvider).fetchBroadcastMessages());

// Notifiers for admin actions
adminActionsProvider = Provider<AdminActions>((final ref) => AdminActions(ref.read(adminServiceProvider)));

class AdminActions {

  AdminActions(this._adminService);
  final AdminService _adminService;

  Future<void> updateUserRole(String uid, final String role) async {
    await _adminService.updateUserRole(uid, role);
  }

  Future<void> resolveError(
      String errorId, final String resolutionNotes,) async {
    await _adminService.resolveError(errorId, resolutionNotes);
  }

  Future<void> updateMonetizationSettings(
      MonetizationSettings settings,) async {
    await _adminService.updateMonetizationSettings(settings);
  }

  Future<void> createBroadcastMessage(
      AdminBroadcastMessage message,) async {
    await _adminService.createBroadcastMessage(message);
  }

  Future<String> exportDataAsCSV(final String dataType,
      {Map<String, dynamic>? filters,}) async => _adminService.exportDataAsCSV(dataType, filters: filters);

  Future<String> exportDataAsPDF(final String dataType,
      {Map<String, dynamic>? filters,}) async => _adminService.exportDataAsPDF(dataType, filters: filters);
}
