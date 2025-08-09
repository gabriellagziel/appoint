import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Monitoring service for admin system with alerts and metrics
class AdminMonitoringService {
  static final AdminMonitoringService _instance =
      AdminMonitoringService._internal();
  factory AdminMonitoringService() => _instance;
  AdminMonitoringService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Track daily metrics
  static Future<void> trackDailyMetrics() async {
    try {
      debugPrint('📊 Tracking daily admin metrics...');

      final now = DateTime.now();
      final dateKey =
          '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      // Get today's metrics
      final metrics = await _calculateDailyMetrics();

      // Store in Firestore
      await FirebaseFirestore.instance
          .collection('admin_metrics')
          .doc('daily_$dateKey')
          .set({
        'date': dateKey,
        'timestamp': FieldValue.serverTimestamp(),
        'totalUsers': metrics['totalUsers'],
        'premiumUsers': metrics['premiumUsers'],
        'childAccounts': metrics['childAccounts'],
        'totalAdImpressions': metrics['totalAdImpressions'],
        'totalAdRevenue': metrics['totalAdRevenue'],
        'averageCompletionRate': metrics['averageCompletionRate'],
        'premiumConversions': metrics['premiumConversions'],
        'adminActions': metrics['adminActions'],
        'systemErrors': metrics['systemErrors'],
        'coppaViolations': metrics['coppaViolations'],
      });

      // Check for alerts
      await _checkAlerts(metrics);

      debugPrint('✅ Daily metrics tracked successfully');
    } catch (e) {
      debugPrint('❌ Error tracking daily metrics: $e');
    }
  }

  /// Calculate daily metrics
  static Future<Map<String, dynamic>> _calculateDailyMetrics() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    // Get users
    final usersQuery =
        await FirebaseFirestore.instance.collection('users').get();

    final users = usersQuery.docs;
    final totalUsers = users.length;
    final premiumUsers =
        users.where((doc) => doc.data()['isPremium'] == true).length;
    final childAccounts =
        users.where((doc) => (doc.data()['age'] as int?) ?? 0 < 13).length;

    // Get ad impressions for today
    final impressionsQuery = await FirebaseFirestore.instance
        .collection('ad_impressions')
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .get();

    final impressions = impressionsQuery.docs;
    final totalAdImpressions = impressions.length;
    double totalAdRevenue = 0.0;
    int completedViews = 0;

    for (final doc in impressions) {
      final data = doc.data();
      final revenue = (data['revenue'] as num?)?.toDouble() ?? 0.0;
      totalAdRevenue += revenue;

      if (data['status'] == 'completed') {
        completedViews++;
      }
    }

    final averageCompletionRate =
        totalAdImpressions > 0 ? completedViews / totalAdImpressions : 0.0;

    // Get premium conversions for today
    final conversionsQuery = await FirebaseFirestore.instance
        .collection('premium_conversions')
        .where('createdAt',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .get();

    final premiumConversions = conversionsQuery.docs.length;

    // Get admin actions for today
    final adminLogsQuery = await FirebaseFirestore.instance
        .collection('admin_logs')
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .get();

    final adminActions = adminLogsQuery.docs.length;

    // Get system errors (placeholder - would need error logging)
    final systemErrors = 0;

    // Get COPPA violations (placeholder - would need violation tracking)
    final coppaViolations = 0;

    return {
      'totalUsers': totalUsers,
      'premiumUsers': premiumUsers,
      'childAccounts': childAccounts,
      'totalAdImpressions': totalAdImpressions,
      'totalAdRevenue': totalAdRevenue,
      'averageCompletionRate': averageCompletionRate,
      'premiumConversions': premiumConversions,
      'adminActions': adminActions,
      'systemErrors': systemErrors,
      'coppaViolations': coppaViolations,
    };
  }

  /// Check for alerts based on metrics
  static Future<void> _checkAlerts(Map<String, dynamic> metrics) async {
    final alerts = <Map<String, dynamic>>[];

    // Low eCPM alert
    if (metrics['totalAdImpressions'] > 0) {
      final eCPM =
          (metrics['totalAdRevenue'] / metrics['totalAdImpressions']) * 1000;
      if (eCPM < 3.0) {
        alerts.add({
          'type': 'low_ecpm',
          'severity': 'warning',
          'message': 'eCPM is below threshold: \$${eCPM.toStringAsFixed(2)}',
          'value': eCPM,
          'threshold': 3.0,
        });
      }
    }

    // High ad error rate alert
    if (metrics['totalAdImpressions'] > 0) {
      final errorRate =
          (metrics['systemErrors'] / metrics['totalAdImpressions']) * 100;
      if (errorRate > 2.0) {
        alerts.add({
          'type': 'high_error_rate',
          'severity': 'critical',
          'message': 'Ad error rate is high: ${errorRate.toStringAsFixed(1)}%',
          'value': errorRate,
          'threshold': 2.0,
        });
      }
    }

    // COPPA violation alert
    if (metrics['coppaViolations'] > 0) {
      alerts.add({
        'type': 'coppa_violation',
        'severity': 'critical',
        'message': 'COPPA violations detected: ${metrics['coppaViolations']}',
        'value': metrics['coppaViolations'],
        'threshold': 0,
      });
    }

    // Low completion rate alert
    if (metrics['averageCompletionRate'] < 0.7) {
      alerts.add({
        'type': 'low_completion_rate',
        'severity': 'warning',
        'message':
            'Ad completion rate is low: ${(metrics['averageCompletionRate'] * 100).toStringAsFixed(1)}%',
        'value': metrics['averageCompletionRate'],
        'threshold': 0.7,
      });
    }

    // Store alerts
    for (final alert in alerts) {
      await FirebaseFirestore.instance.collection('admin_alerts').add({
        ...alert,
        'timestamp': FieldValue.serverTimestamp(),
        'resolved': false,
      });
    }

    if (alerts.isNotEmpty) {
      debugPrint('⚠️ Generated ${alerts.length} alerts');
      await _sendAlertNotifications(alerts);
    }
  }

  /// Send alert notifications
  static Future<void> _sendAlertNotifications(
      List<Map<String, dynamic>> alerts) async {
    try {
      // Store notifications for admin panel
      for (final alert in alerts) {
        await FirebaseFirestore.instance.collection('admin_notifications').add({
          'type': 'alert',
          'title': 'System Alert: ${alert['type']}',
          'message': alert['message'],
          'severity': alert['severity'],
          'timestamp': FieldValue.serverTimestamp(),
          'read': false,
        });
      }

      // TODO: Integrate with external notification services
      // - Slack webhook
      // - Email service
      // - SMS service
      // - Push notifications

      debugPrint('📢 Alert notifications sent');
    } catch (e) {
      debugPrint('❌ Error sending alert notifications: $e');
    }
  }

  /// Get system health status
  static Future<Map<String, dynamic>> getSystemHealth() async {
    try {
      final now = DateTime.now();
      final oneHourAgo = now.subtract(Duration(hours: 1));

      // Check recent activity
      final recentLogs = await FirebaseFirestore.instance
          .collection('admin_logs')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(oneHourAgo))
          .get();

      // Check for errors
      final errorLogs = recentLogs.docs
          .where((doc) => doc.data()['action'].toString().contains('error'))
          .length;

      // Check COPPA compliance
      final coppaLogs = await FirebaseFirestore.instance
          .collection('admin_logs')
          .where('action', isEqualTo: 'coppa_violation')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(oneHourAgo))
          .get();

      // Check ad performance
      final adImpressions = await FirebaseFirestore.instance
          .collection('ad_impressions')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(oneHourAgo))
          .get();

      final completedImpressions = adImpressions.docs
          .where((doc) => doc.data()['status'] == 'completed')
          .length;

      final completionRate = adImpressions.docs.isNotEmpty
          ? completedImpressions / adImpressions.docs.length
          : 0.0;

      return {
        'status':
            errorLogs == 0 && coppaLogs.docs.isEmpty ? 'healthy' : 'warning',
        'lastActivity': recentLogs.docs.isNotEmpty
            ? recentLogs.docs.first.data()['timestamp']
            : null,
        'errorCount': errorLogs,
        'coppaViolations': coppaLogs.docs.length,
        'adCompletionRate': completionRate,
        'activeUsers': recentLogs.docs.length,
        'timestamp': FieldValue.serverTimestamp(),
      };
    } catch (e) {
      debugPrint('❌ Error getting system health: $e');
      return {
        'status': 'error',
        'error': e.toString(),
        'timestamp': FieldValue.serverTimestamp(),
      };
    }
  }

  /// Get performance metrics
  static Future<Map<String, dynamic>> getPerformanceMetrics() async {
    try {
      final now = DateTime.now();
      final oneDayAgo = now.subtract(Duration(days: 1));
      final oneWeekAgo = now.subtract(Duration(days: 7));

      // Daily metrics
      final dailyMetrics = await _calculateDailyMetrics();

      // Weekly comparison
      final weeklyImpressions = await FirebaseFirestore.instance
          .collection('ad_impressions')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(oneWeekAgo))
          .get();

      final weeklyRevenue = weeklyImpressions.docs.fold<double>(
          0.0,
          (sum, doc) =>
              sum + ((doc.data()['revenue'] as num?)?.toDouble() ?? 0.0));

      // Calculate trends
      final dailyRevenue = dailyMetrics['totalAdRevenue'] as double;
      final weeklyAvgRevenue = weeklyRevenue / 7;
      final revenueTrend = weeklyAvgRevenue > 0
          ? (dailyRevenue - weeklyAvgRevenue) / weeklyAvgRevenue
          : 0.0;

      return {
        'daily': dailyMetrics,
        'weekly': {
          'totalImpressions': weeklyImpressions.docs.length,
          'totalRevenue': weeklyRevenue,
          'averageDailyRevenue': weeklyAvgRevenue,
        },
        'trends': {
          'revenueTrend': revenueTrend,
          'completionRateTrend': dailyMetrics['averageCompletionRate'],
          'userGrowth': 0.0, // TODO: Calculate user growth
        },
        'timestamp': FieldValue.serverTimestamp(),
      };
    } catch (e) {
      debugPrint('❌ Error getting performance metrics: $e');
      return {
        'error': e.toString(),
        'timestamp': FieldValue.serverTimestamp(),
      };
    }
  }

  /// Resolve alert
  static Future<bool> resolveAlert(String alertId, String resolution) async {
    try {
      await FirebaseFirestore.instance
          .collection('admin_alerts')
          .doc(alertId)
          .update({
        'resolved': true,
        'resolvedAt': FieldValue.serverTimestamp(),
        'resolution': resolution,
      });

      debugPrint('✅ Alert resolved: $alertId');
      return true;
    } catch (e) {
      debugPrint('❌ Error resolving alert: $e');
      return false;
    }
  }

  /// Get unresolved alerts
  static Future<List<Map<String, dynamic>>> getUnresolvedAlerts() async {
    try {
      final alertsQuery = await FirebaseFirestore.instance
          .collection('admin_alerts')
          .where('resolved', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .get();

      return alertsQuery.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      debugPrint('❌ Error getting unresolved alerts: $e');
      return [];
    }
  }

  /// Get recent notifications
  static Future<List<Map<String, dynamic>>> getRecentNotifications() async {
    try {
      final notificationsQuery = await FirebaseFirestore.instance
          .collection('admin_notifications')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      return notificationsQuery.docs
          .map((doc) => {
                'id': doc.id,
                ...doc.data(),
              })
          .toList();
    } catch (e) {
      debugPrint('❌ Error getting recent notifications: $e');
      return [];
    }
  }
}

