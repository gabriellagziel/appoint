import 'package:appoint/models/admin_broadcast_message.dart';
import 'package:appoint/models/admin_dashboard_stats.dart';
import 'package:appoint/models/admin_user.dart';
import 'package:appoint/models/analytics.dart';
import 'package:appoint/models/organization.dart';
import 'package:appoint/services/admin_service.dart';
import 'package:appoint/services/broadcast_service.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the admin service
final adminServiceProvider = Provider<AdminService>((ref) => AdminService());

/// Provider for the broadcast service
final adminBroadcastServiceProvider = Provider<BroadcastService>((ref) => BroadcastService());

/// Provider to check if current user has admin privileges
final isAdminProvider = FutureProvider<bool>((ref) async {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return false;
      // Check if user has admin role
      return user.role == 'admin' || user.role == 'superAdmin';
    },
    loading: () => false,
    error: (_, __) => false,
  );
});

/// Provider for broadcast messages list
final broadcastMessagesProvider = FutureProvider<List<AdminBroadcastMessage>>((ref) async {
  final broadcastService = ref.watch(adminBroadcastServiceProvider);
  final isAdmin = await ref.watch(isAdminProvider.future);
  
  if (!isAdmin) {
    throw Exception('Unauthorized: Admin access required');
  }
  
  return broadcastService.getBroadcastMessages().first;
});

/// Provider for admin dashboard statistics
final adminStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final adminService = ref.watch(adminServiceProvider);
  final isAdmin = await ref.watch(isAdminProvider.future);
  
  if (!isAdmin) {
    throw Exception('Unauthorized: Admin access required');
  }
  
  return adminService.getDashboardStats();
});

/// Provider for total user count
final totalUsersProvider = FutureProvider<int>((ref) async {
  final adminService = ref.watch(adminServiceProvider);
  final isAdmin = await ref.watch(isAdminProvider.future);
  
  if (!isAdmin) {
    throw Exception('Unauthorized: Admin access required');
  }
  
  return adminService.getTotalUsersCount();
});

/// Provider for user management operations
class AdminNotifier extends StateNotifier<AdminState> {
  AdminNotifier(this.ref) : super(const AdminState());
  
  final Ref ref;
  
  Future<void> deleteUser(String userId) async {
    state = state.copyWith(isLoading: true);
    try {
      final adminService = ref.read(adminServiceProvider);
      await adminService.deleteUser(userId);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  
  Future<void> updateUserRole(String userId, String newRole) async {
    state = state.copyWith(isLoading: true);
    try {
      final adminService = ref.read(adminServiceProvider);
      await adminService.updateUserRole(userId, newRole);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

/// State for admin operations
class AdminState {
  const AdminState({
    this.isLoading = false,
    this.error,
  });
  
  final bool isLoading;
  final String? error;
  
  AdminState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final adminNotifierProvider = StateNotifierProvider<AdminNotifier, AdminState>(
  (ref) => AdminNotifier(ref),
);

// User Management
final allUsersProvider = FutureProvider<List<AdminUser>>((ref) => ref.read(adminServiceProvider).fetchAllUsers());

// Organization Management
final orgsProvider = FutureProvider<List<Organization>>((ref) => ref.read(adminServiceProvider).fetchOrganizations());

// Analytics
final analyticsProvider = FutureProvider<Analytics>((ref) => ref.read(adminServiceProvider).fetchAnalytics());

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
final adRevenueStatsProvider = FutureProvider<AdRevenueStats>((ref) => ref.read(adminServiceProvider).fetchAdRevenueStats());

// Monetization Settings
final monetizationSettingsProvider =
    FutureProvider<MonetizationSettings>((ref) => ref.read(adminServiceProvider).fetchMonetizationSettings());

// Notifiers for admin actions
final adminActionsProvider = Provider<AdminActions>((ref) => AdminActions(ref.read(adminServiceProvider)));

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
      MonetizationSettings settings) async {
    await _adminService.updateMonetizationSettings(settings);
  }

  Future<void> createBroadcastMessage(
      AdminBroadcastMessage message) async {
    await _adminService.createBroadcastMessage(message);
  }

  Future<String> exportDataAsCSV(final String dataType,
      {Map<String, dynamic>? filters,}) async => _adminService.exportDataAsCSV(dataType, filters: filters);

  Future<String> exportDataAsPDF(final String dataType,
      {Map<String, dynamic>? filters,}) async => _adminService.exportDataAsPDF(dataType, filters: filters);
}
