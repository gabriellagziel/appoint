import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// SLO (Service Level Objective) monitoring for admin system
/// Tracks performance metrics and triggers alerts on SLO breaches
class AdminSLOMonitoring {
  static final AdminSLOMonitoring _instance = AdminSLOMonitoring._internal();
  factory AdminSLOMonitoring() => _instance;
  AdminSLOMonitoring._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // SLO Definitions
  static const Map<String, double> _slos = {
    'admin_dashboard_p95': 600.0, // 600ms p95 response time
    'admin_actions_error_rate': 0.01, // 1% error rate
    'ad_impression_completion_rate': 0.85, // 85% completion rate
    'premium_conversion_rate': 0.05, // 5% conversion rate
    'system_uptime': 0.999, // 99.9% uptime
    'coppa_compliance_rate': 1.0, // 100% COPPA compliance
  };

  // Alert Thresholds
  static const Map<String, double> _alertThresholds = {
    'ecpm_drop_threshold': 0.30, // 30% drop in eCPM
    'error_rate_threshold': 0.02, // 2% error rate
    'completion_rate_threshold': 0.70, // 70% completion rate
    'admin_action_spike_threshold': 10.0, // 10x normal admin actions
  };

  /// Track admin dashboard performance
  static Future<void> trackDashboardPerformance(
      String requestId, int responseTimeMs) async {
    try {
      final now = DateTime.now();
      final timestamp = Timestamp.fromDate(now);

      await FirebaseFirestore.instance
          .collection('admin_performance_metrics')
          .add({
        'requestId': requestId,
        'metricType': 'dashboard_response_time',
        'value': responseTimeMs,
        'timestamp': timestamp,
        'slo': _slos['admin_dashboard_p95'],
        'breached': responseTimeMs > _slos['admin_dashboard_p95']!,
      });

      // Check for SLO breach
      if (responseTimeMs > _slos['admin_dashboard_p95']!) {
        await _triggerSLOAlert('admin_dashboard_p95', responseTimeMs,
            _slos['admin_dashboard_p95']!);
      }

      debugPrint('📊 Dashboard performance tracked: ${responseTimeMs}ms');
    } catch (e) {
      debugPrint('❌ Error tracking dashboard performance: $e');
    }
  }

  /// Track admin action errors
  static Future<void> trackAdminActionError(
      String action, String error, String adminId) async {
    try {
      final now = DateTime.now();
      final timestamp = Timestamp.fromDate(now);

      await FirebaseFirestore.instance.collection('admin_error_logs').add({
        'action': action,
        'error': error,
        'adminId': adminId,
        'timestamp': timestamp,
        'requestId': '${adminId}_${now.millisecondsSinceEpoch}',
      });

      // Calculate error rate for the last hour
      final oneHourAgo = now.subtract(Duration(hours: 1));
      final errorLogs = await FirebaseFirestore.instance
          .collection('admin_error_logs')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(oneHourAgo))
          .get();

      final adminLogs = await FirebaseFirestore.instance
          .collection('admin_logs')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(oneHourAgo))
          .get();

      final errorRate = adminLogs.docs.isNotEmpty
          ? errorLogs.docs.length / adminLogs.docs.length
          : 0.0;

      // Check for error rate breach
      if (errorRate > _slos['admin_actions_error_rate']!) {
        await _triggerSLOAlert('admin_actions_error_rate', errorRate,
            _slos['admin_actions_error_rate']!);
      }

      debugPrint('❌ Admin action error tracked: $action - $error');
    } catch (e) {
      debugPrint('❌ Error tracking admin action error: $e');
    }
  }

  /// Track ad performance metrics
  static Future<void> trackAdPerformance() async {
    try {
      final now = DateTime.now();
      final oneDayAgo = now.subtract(Duration(days: 1));

      // Get ad impressions for the last day
      final impressions = await FirebaseFirestore.instance
          .collection('ad_impressions')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(oneDayAgo))
          .get();

      final totalImpressions = impressions.docs.length;
      final completedImpressions = impressions.docs
          .where((doc) => doc.data()['status'] == 'completed')
          .length;

      final completionRate =
          totalImpressions > 0 ? completedImpressions / totalImpressions : 0.0;

      // Calculate eCPM
      double totalRevenue = 0.0;
      for (final doc in impressions.docs) {
        totalRevenue += (doc.data()['revenue'] as num?)?.toDouble() ?? 0.0;
      }

      final eCPM =
          totalImpressions > 0 ? (totalRevenue / totalImpressions) * 1000 : 0.0;

      // Store metrics
      await FirebaseFirestore.instance
          .collection('admin_performance_metrics')
          .add({
        'metricType': 'ad_performance',
        'totalImpressions': totalImpressions,
        'completionRate': completionRate,
        'eCPM': eCPM,
        'totalRevenue': totalRevenue,
        'timestamp': Timestamp.fromDate(now),
        'slo': _slos['ad_impression_completion_rate'],
        'breached': completionRate < _slos['ad_impression_completion_rate']!,
      });

      // Check for SLO breaches
      if (completionRate < _slos['ad_impression_completion_rate']!) {
        await _triggerSLOAlert('ad_impression_completion_rate', completionRate,
            _slos['ad_impression_completion_rate']!);
      }

      // Check for eCPM drop
      await _checkECPMDrop(eCPM);

      debugPrint(
          '📊 Ad performance tracked: ${(completionRate * 100).toStringAsFixed(1)}% completion, \$${eCPM.toStringAsFixed(2)} eCPM');
    } catch (e) {
      debugPrint('❌ Error tracking ad performance: $e');
    }
  }

  /// Track premium conversion rate
  static Future<void> trackPremiumConversions() async {
    try {
      final now = DateTime.now();
      final oneDayAgo = now.subtract(Duration(days: 1));

      // Get premium conversions for the last day
      final conversions = await FirebaseFirestore.instance
          .collection('premium_conversions')
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(oneDayAgo))
          .get();

      // Get total users who could convert
      final users = await FirebaseFirestore.instance
          .collection('users')
          .where('isPremium', isEqualTo: false)
          .get();

      final conversionRate = users.docs.isNotEmpty
          ? conversions.docs.length / users.docs.length
          : 0.0;

      // Store metrics
      await FirebaseFirestore.instance
          .collection('admin_performance_metrics')
          .add({
        'metricType': 'premium_conversion_rate',
        'conversions': conversions.docs.length,
        'totalUsers': users.docs.length,
        'conversionRate': conversionRate,
        'timestamp': Timestamp.fromDate(now),
        'slo': _slos['premium_conversion_rate'],
        'breached': conversionRate < _slos['premium_conversion_rate']!,
      });

      debugPrint(
          '💰 Premium conversion rate tracked: ${(conversionRate * 100).toStringAsFixed(2)}%');
    } catch (e) {
      debugPrint('❌ Error tracking premium conversions: $e');
    }
  }

  /// Track COPPA compliance
  static Future<void> trackCOPPACompliance() async {
    try {
      final now = DateTime.now();
      final oneDayAgo = now.subtract(Duration(days: 1));

      // Get child users
      final childUsers = await FirebaseFirestore.instance
          .collection('users')
          .where('age', isLessThan: 13)
          .get();

      // Get COPPA violations
      final violations = await FirebaseFirestore.instance
          .collection('admin_logs')
          .where('action', isEqualTo: 'coppa_violation')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(oneDayAgo))
          .get();

      final complianceRate = childUsers.docs.isNotEmpty
          ? (childUsers.docs.length - violations.docs.length) /
              childUsers.docs.length
          : 1.0;

      // Store metrics
      await FirebaseFirestore.instance
          .collection('admin_performance_metrics')
          .add({
        'metricType': 'coppa_compliance_rate',
        'childUsers': childUsers.docs.length,
        'violations': violations.docs.length,
        'complianceRate': complianceRate,
        'timestamp': Timestamp.fromDate(now),
        'slo': _slos['coppa_compliance_rate'],
        'breached': complianceRate < _slos['coppa_compliance_rate']!,
      });

      // Alert on any COPPA violation
      if (violations.docs.isNotEmpty) {
        await _triggerCOPPAViolationAlert(violations.docs.length);
      }

      debugPrint(
          '🛡️ COPPA compliance tracked: ${(complianceRate * 100).toStringAsFixed(1)}%');
    } catch (e) {
      debugPrint('❌ Error tracking COPPA compliance: $e');
    }
  }

  /// Check for eCPM drop
  static Future<void> _checkECPMDrop(double currentECPM) async {
    try {
      final now = DateTime.now();
      final oneDayAgo = now.subtract(Duration(days: 1));
      final twoDaysAgo = now.subtract(Duration(days: 2));

      // Get eCPM for previous day
      final previousMetrics = await FirebaseFirestore.instance
          .collection('admin_performance_metrics')
          .where('metricType', isEqualTo: 'ad_performance')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(twoDaysAgo))
          .where('timestamp', isLessThan: Timestamp.fromDate(oneDayAgo))
          .get();

      if (previousMetrics.docs.isNotEmpty) {
        final previousECPM =
            previousMetrics.docs.first.data()['eCPM'] as double? ?? 0.0;

        if (previousECPM > 0) {
          final dropPercentage = (previousECPM - currentECPM) / previousECPM;

          if (dropPercentage > _alertThresholds['ecpm_drop_threshold']!) {
            await _triggerAnomalyAlert('ecpm_drop', {
              'currentECPM': currentECPM,
              'previousECPM': previousECPM,
              'dropPercentage': dropPercentage,
            });
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error checking eCPM drop: $e');
    }
  }

  /// Check for admin action spikes
  static Future<void> checkAdminActionSpike() async {
    try {
      final now = DateTime.now();
      final oneHourAgo = now.subtract(Duration(hours: 1));
      final twoHoursAgo = now.subtract(Duration(hours: 2));

      // Get admin actions for current hour
      final currentActions = await FirebaseFirestore.instance
          .collection('admin_logs')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(oneHourAgo))
          .get();

      // Get admin actions for previous hour
      final previousActions = await FirebaseFirestore.instance
          .collection('admin_logs')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(twoHoursAgo))
          .where('timestamp', isLessThan: Timestamp.fromDate(oneHourAgo))
          .get();

      if (previousActions.docs.isNotEmpty) {
        final spikeRatio =
            currentActions.docs.length / previousActions.docs.length;

        if (spikeRatio > _alertThresholds['admin_action_spike_threshold']!) {
          await _triggerAnomalyAlert('admin_action_spike', {
            'currentActions': currentActions.docs.length,
            'previousActions': previousActions.docs.length,
            'spikeRatio': spikeRatio,
          });
        }
      }
    } catch (e) {
      debugPrint('❌ Error checking admin action spike: $e');
    }
  }

  /// Trigger SLO alert
  static Future<void> _triggerSLOAlert(
      String sloName, double currentValue, double targetValue) async {
    try {
      await FirebaseFirestore.instance.collection('admin_alerts').add({
        'type': 'slo_breach',
        'sloName': sloName,
        'currentValue': currentValue,
        'targetValue': targetValue,
        'severity': 'critical',
        'message':
            'SLO breach detected: $sloName (${currentValue.toStringAsFixed(2)} vs ${targetValue.toStringAsFixed(2)})',
        'timestamp': FieldValue.serverTimestamp(),
        'resolved': false,
      });

      debugPrint('🚨 SLO alert triggered: $sloName');
    } catch (e) {
      debugPrint('❌ Error triggering SLO alert: $e');
    }
  }

  /// Trigger anomaly alert
  static Future<void> _triggerAnomalyAlert(
      String anomalyType, Map<String, dynamic> details) async {
    try {
      await FirebaseFirestore.instance.collection('admin_alerts').add({
        'type': 'anomaly',
        'anomalyType': anomalyType,
        'details': details,
        'severity': 'warning',
        'message': 'Anomaly detected: $anomalyType',
        'timestamp': FieldValue.serverTimestamp(),
        'resolved': false,
      });

      debugPrint('⚠️ Anomaly alert triggered: $anomalyType');
    } catch (e) {
      debugPrint('❌ Error triggering anomaly alert: $e');
    }
  }

  /// Trigger COPPA violation alert
  static Future<void> _triggerCOPPAViolationAlert(int violationCount) async {
    try {
      await FirebaseFirestore.instance.collection('admin_alerts').add({
        'type': 'coppa_violation',
        'violationCount': violationCount,
        'severity': 'critical',
        'message': 'COPPA violation detected: $violationCount violations',
        'timestamp': FieldValue.serverTimestamp(),
        'resolved': false,
      });

      debugPrint(
          '🚨 COPPA violation alert triggered: $violationCount violations');
    } catch (e) {
      debugPrint('❌ Error triggering COPPA violation alert: $e');
    }
  }

  /// Get SLO status report
  static Future<Map<String, dynamic>> getSLOStatus() async {
    try {
      final now = DateTime.now();
      final oneDayAgo = now.subtract(Duration(days: 1));

      // Get recent performance metrics
      final metrics = await FirebaseFirestore.instance
          .collection('admin_performance_metrics')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(oneDayAgo))
          .get();

      final sloStatus = <String, Map<String, dynamic>>{};

      for (final slo in _slos.keys) {
        final sloMetrics = metrics.docs
            .where((doc) => doc.data()['metricType'] == slo)
            .toList();

        if (sloMetrics.isNotEmpty) {
          final breaches =
              sloMetrics.where((doc) => doc.data()['breached'] == true).length;
          final total = sloMetrics.length;
          final complianceRate = total > 0 ? (total - breaches) / total : 1.0;

          sloStatus[slo] = {
            'target': _slos[slo],
            'complianceRate': complianceRate,
            'breaches': breaches,
            'total': total,
            'status': complianceRate >= 0.99
                ? 'green'
                : complianceRate >= 0.95
                    ? 'yellow'
                    : 'red',
          };
        }
      }

      return {
        'sloStatus': sloStatus,
        'timestamp': now.toIso8601String(),
        'overallStatus':
            sloStatus.values.every((status) => status['status'] == 'green')
                ? 'healthy'
                : 'warning',
      };
    } catch (e) {
      debugPrint('❌ Error getting SLO status: $e');
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Get error budget status
  static Future<Map<String, dynamic>> getErrorBudgetStatus() async {
    try {
      final now = DateTime.now();
      final oneMonthAgo = now.subtract(Duration(days: 30));

      // Get all SLO breaches for the month
      final breaches = await FirebaseFirestore.instance
          .collection('admin_performance_metrics')
          .where('breached', isEqualTo: true)
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(oneMonthAgo))
          .get();

      final totalRequests = await FirebaseFirestore.instance
          .collection('admin_performance_metrics')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(oneMonthAgo))
          .get();

      final errorBudget = totalRequests.docs.isNotEmpty
          ? (totalRequests.docs.length - breaches.docs.length) /
              totalRequests.docs.length
          : 1.0;

      return {
        'errorBudget': errorBudget,
        'breaches': breaches.docs.length,
        'totalRequests': totalRequests.docs.length,
        'period': '30 days',
        'timestamp': now.toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error getting error budget status: $e');
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }
}

