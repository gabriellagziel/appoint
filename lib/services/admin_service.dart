import 'package:appoint/models/admin_broadcast_message.dart';
import 'package:appoint/models/admin_dashboard_stats.dart';
import 'package:appoint/models/admin_user.dart';
import 'package:appoint/models/analytics.dart';
import 'package:appoint/models/organization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminService {

  AdminService({
    final FirebaseFirestore? firestore,
    final FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  // User Management
  Future<List<AdminUser>> fetchAllUsers() async {
    final snap = await _firestore.collection('users').get();
    return snap.docs
        .map((doc) => AdminUser.fromJson(doc.data()))
        .toList();
  }

  Future<void> updateUserRole(String uid, final String role) async {
    await _firestore.collection('users').doc(uid).update({'role': role});
    await _logAdminActivity(
      action: 'update_user_role',
      targetType: 'user',
      targetId: uid,
      details: {'role': role},
    );
  }

  // Organization Management
  Future<List<Organization>> fetchOrganizations() async {
    final snap = await _firestore.collection('organizations').get();
    return snap.docs
        .map((doc) => Organization.fromJson(doc.data()))
        .toList();
  }

  // Analytics
  Future<Analytics> fetchAnalytics() async {
    final doc = await _firestore.collection('analytics').doc('summary').get();
    return Analytics.fromJson(doc.data() ?? {});
  }

  // Dashboard Stats
  Future<AdminDashboardStats> getDashboardStats() async {
    final usersCount = await getTotalUsersCount();
    final organizationsSnapshot = await _firestore.collection('organizations').get();
    final messagesSnapshot = await _firestore.collection('admin_broadcast_messages').get();
    
    return AdminDashboardStats(
      totalUsers: usersCount,
      totalOrganizations: organizationsSnapshot.docs.length,
      totalMessages: messagesSnapshot.docs.length,
      activeUsers: usersCount, // Simplified for now
    );
  }

  // Total Users Count
  Future<int> getTotalUsersCount() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.length;
  }

  // Delete User
  Future<void> deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
    await _logAdminActivity(
      action: 'delete_user',
      targetType: 'user',
      targetId: userId,
      details: {'deleted': true},
    );
  }

  // Admin Dashboard Stats
  Future<AdminDashboardStats> fetchAdminDashboardStats() async {
    // Fetch users stats
    final usersSnap = await _firestore.collection('users').get();
    final totalUsers = usersSnap.size;
    final activeUsers = usersSnap.docs.where((final doc) {
      final lastActive = doc.data()['lastActive'] as Timestamp?;
      if (lastActive == null) return false;
      final daysSinceActive =
          DateTime.now().difference(lastActive.toDate()).inDays;
      return daysSinceActive <= 30;
    }).length;

    // Fetch bookings stats
    final bookingsSnap = await _firestore.collection('appointments').get();
    final totalBookings = bookingsSnap.size;
    final completedBookings = bookingsSnap.docs.where((final doc) {
      final status = doc.data()['status'] as String?;
      return status == 'completed';
    }).length;
    final pendingBookings = bookingsSnap.docs.where((final doc) {
      final status = doc.data()['status'] as String?;
      return status == 'pending';
    }).length;

    // Fetch revenue stats
    final paymentsDoc =
        await _firestore.collection('payments').doc('summary').get();
    final totalRevenue =
        (paymentsDoc.data()?['totalRevenue'] as num?)?.toDouble() ?? 0.0;
    final adRevenue =
        (paymentsDoc.data()?['adRevenue'] as num?)?.toDouble() ?? 0.0;
    final subscriptionRevenue =
        (paymentsDoc.data()?['subscriptionRevenue'] as num?)?.toDouble() ?? 0.0;

    // Fetch organizations stats
    final orgsSnap = await _firestore.collection('organizations').get();
    final totalOrganizations = orgsSnap.size;
    final activeOrganizations = orgsSnap.docs.where((final doc) {
      final lastActive = doc.data()['lastActive'] as Timestamp?;
      if (lastActive == null) return false;
      final daysSinceActive =
          DateTime.now().difference(lastActive.toDate()).inDays;
      return daysSinceActive <= 30;
    }).length;

    // Fetch ambassadors stats
    final ambassadorsSnap = await _firestore
        .collection('users')
        .where('role', isEqualTo: 'ambassador')
        .get();
    final totalAmbassadors = ambassadorsSnap.size;
    final activeAmbassadors = ambassadorsSnap.docs.where((final doc) {
      final lastActive = doc.data()['lastActive'] as Timestamp?;
      if (lastActive == null) return false;
      final daysSinceActive =
          DateTime.now().difference(lastActive.toDate()).inDays;
      return daysSinceActive <= 30;
    }).length;

    // Fetch error stats
    final errorsSnap = await _firestore
        .collection('error_logs')
        .where('timestamp',
            isGreaterThan: Timestamp.fromDate(
                DateTime.now().subtract(const Duration(days: 30)),),)
        .get();
    final totalErrors = errorsSnap.size;
    final criticalErrors = errorsSnap.docs.where((final doc) {
      final severity = doc.data()['severity'] as String?;
      return severity == 'critical';
    }).length;

    // Generate monthly trends (simplified for now)
    final userGrowthByMonth = <String, int>{};
    final revenueByMonth = <String, double>{};
    final bookingsByMonth = <String, int>{};

    // Top countries and cities (simplified)
    final topCountries = <String, int>{};
    final topCities = <String, int>{};

    // User types and subscription tiers
    final userTypes = <String, int>{};
    final subscriptionTiers = <String, int>{};

    return AdminDashboardStats(
      totalUsers: totalUsers,
      activeUsers: activeUsers,
      totalBookings: totalBookings,
      completedBookings: completedBookings,
      pendingBookings: pendingBookings,
      totalRevenue: totalRevenue,
      adRevenue: adRevenue,
      subscriptionRevenue: subscriptionRevenue,
      totalOrganizations: totalOrganizations,
      activeOrganizations: activeOrganizations,
      totalAmbassadors: totalAmbassadors,
      activeAmbassadors: activeAmbassadors,
      totalErrors: totalErrors,
      criticalErrors: criticalErrors,
      userGrowthByMonth: userGrowthByMonth,
      revenueByMonth: revenueByMonth,
      bookingsByMonth: bookingsByMonth,
      topCountries: topCountries,
      topCities: topCities,
      userTypes: userTypes,
      subscriptionTiers: subscriptionTiers,
      lastUpdated: DateTime.now(),
    );
  }

  // Error Logs
  Future<List<AdminErrorLog>> fetchErrorLogs({
    final int limit = 50,
    final ErrorSeverity? severity,
    final bool? isResolved,
  }) async {
    Query query = _firestore
        .collection('error_logs')
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (severity != null) {
      query = query.where('severity', isEqualTo: severity.name);
    }

    if (isResolved != null) {
      query = query.where('isResolved', isEqualTo: isResolved);
    }

    final snap = await query.get();
    return snap.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return AdminErrorLog.fromJson(data);
    }).toList();
  }

  Future<void> resolveError(
      String errorId, final String resolutionNotes,) async {
    final user = _auth.currentUser;
    await _firestore.collection('error_logs').doc(errorId).update({
      'isResolved': true,
      'resolvedBy': user?.uid,
      'resolvedAt': FieldValue.serverTimestamp(),
      'resolutionNotes': resolutionNotes,
    });

    await _logAdminActivity(
      action: 'resolve_error',
      targetType: 'error_log',
      targetId: errorId,
      details: {'resolutionNotes': resolutionNotes},
    );
  }

  // Activity Logs
  Future<List<AdminActivityLog>> fetchActivityLogs({
    final int limit = 50,
    final String? adminId,
    final String? action,
  }) async {
    Query query = _firestore
        .collection('admin_activity_logs')
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (adminId != null) {
      query = query.where('adminId', isEqualTo: adminId);
    }

    if (action != null) {
      query = query.where('action', isEqualTo: action);
    }

    final snap = await query.get();
    return snap.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return AdminActivityLog.fromJson(data);
    }).toList();
  }

  // Ad Revenue Stats
  Future<AdRevenueStats> fetchAdRevenueStats() async {
    final doc = await _firestore.collection('ad_revenue').doc('stats').get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      return AdRevenueStats.fromJson(data);
    }

    // Return default stats if document doesn't exist
    return AdRevenueStats(
      totalRevenue: 0,
      monthlyRevenue: 0,
      weeklyRevenue: 0,
      dailyRevenue: 0,
      totalImpressions: 0,
      totalClicks: 0,
      clickThroughRate: 0,
      revenueByAdType: {},
      revenueByUserTier: {},
      revenueByCountry: {},
      lastUpdated: DateTime.now(),
    );
  }

  // Monetization Settings
  Future<MonetizationSettings> fetchMonetizationSettings() async {
    final doc =
        await _firestore.collection('settings').doc('monetization').get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      return MonetizationSettings.fromJson(data);
    }

    // Return default settings if document doesn't exist
    return MonetizationSettings(
      adsEnabledForFreeUsers: true,
      adsEnabledForChildren: false,
      adsEnabledForStudioUsers: true,
      adsEnabledForPremiumUsers: false,
      adFrequencyForFreeUsers: 1,
      adFrequencyForChildren: 0,
      adFrequencyForStudioUsers: 0.5,
      adFrequencyForPremiumUsers: 0,
      enabledAdTypes: ['interstitial', 'banner'],
      adTypeSettings: {},
      lastUpdated: DateTime.now(),
    );
  }

  Future<void> updateMonetizationSettings(
      MonetizationSettings settings) async {
    await _firestore
        .collection('settings')
        .doc('monetization')
        .set(settings.toJson());

    await _logAdminActivity(
      action: 'update_monetization_settings',
      targetType: 'settings',
      targetId: 'monetization',
      details: settings.toJson(),
    );
  }

  // Broadcast Management
  Future<List<AdminBroadcastMessage>> fetchBroadcastMessages() async {
    final snap = await _firestore
        .collection('admin_broadcasts')
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map((doc) {
      final data = doc.data();
      return AdminBroadcastMessage.fromJson(data);
    }).toList();
  }

  Future<void> createBroadcastMessage(
      AdminBroadcastMessage message) async {
    await _firestore.collection('admin_broadcasts').add(message.toJson());

    await _logAdminActivity(
      action: 'create_broadcast',
      targetType: 'broadcast',
      targetId: message.id,
      details: {
        'title': message.title,
        'type': message.type.name,
        'estimatedRecipients': message.estimatedRecipients,
      },
    );
  }

  // Helper method to log admin activities
  Future<void> _logAdminActivity({
    required final String action,
    required final String targetType,
    required final String targetId,
    required final Map<String, dynamic> details,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final activity = AdminActivityLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      adminId: user.uid,
      adminEmail: user.email ?? '',
      action: action,
      targetType: targetType,
      targetId: targetId,
      details: details,
      timestamp: DateTime.now(),
      ipAddress: 'unknown', // Would need to be passed from the client
      userAgent: 'unknown', // Would need to be passed from the client
    );

    await _firestore.collection('admin_activity_logs').add(activity.toJson());
  }

  // Export functionality
  Future<String> exportDataAsCSV(final String dataType,
      {Map<String, dynamic>? filters,}) async {
    // This would implement CSV export logic
    // For now, return a placeholder
    return 'CSV export for $dataType';
  }

  Future<String> exportDataAsPDF(final String dataType,
      {Map<String, dynamic>? filters,}) async {
    // This would implement PDF export logic
    // For now, return a placeholder
    return 'PDF export for $dataType';
  }

  /// Delete a user account and all associated data
  Future<void> deleteUser(String userId) async {
    try {
      // Delete user document from Firestore
      await _firestore.collection('users').doc(userId).delete();
      
      // Note: In a real implementation, you would also:
      // - Delete related collections (bookings, messages, etc.)
      // - Delete Firebase Auth user
      // - Clean up file storage
      // - Log the deletion for audit purposes
      
      print('User $userId deleted successfully');
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
