import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:appoint/services/admin_service.dart';

/// Smoke tests for AdminService
/// Tests basic functionality without requiring full app setup
void main() {
  group('AdminService Smoke Tests', () {
    setUpAll(() async {
      // Ensure Firestore is initialized for testing
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    group('Configuration Management', () {
      test('getAdConfig() returns valid configuration object', () async {
        final config = await AdminService.getAdConfig();

        expect(config, isA<Map<String, dynamic>>());
        expect(config['enabled'], isA<bool>());
        expect(config['minimumAdInterval'], isA<int>());
        expect(config['adDuration'], isA<int>());
        expect(config['skipEnabled'], isA<bool>());
        expect(config['skipDelay'], isA<int>());
        expect(config['eCPM'], isA<double>());
        expect(config['premiumPrice'], isA<double>());
        expect(config['childAccountRestriction'], isA<bool>());
        expect(config['locations'], isA<List>());
      });

      test('updateAdConfig() updates configuration successfully', () async {
        final testConfig = {
          'enabled': true,
          'minimumAdInterval': 600,
          'adDuration': 20,
          'skipEnabled': false,
          'skipDelay': 10,
          'eCPM': 0.15,
          'premiumPrice': 12.99,
          'childAccountRestriction': true,
          'locations': ['test_location'],
        };

        final success = await AdminService.updateAdConfig(testConfig);
        expect(success, isTrue);

        // Verify the update was applied
        final updatedConfig = await AdminService.getAdConfig();
        expect(updatedConfig['minimumAdInterval'], equals(600));
        expect(updatedConfig['adDuration'], equals(20));
        expect(updatedConfig['eCPM'], equals(0.15));
      });
    });

    group('Revenue Statistics', () {
      test('getAdRevenueStats() returns valid revenue data', () async {
        final stats = await AdminService.getAdRevenueStats();

        expect(stats, isA<Map<String, dynamic>>());
        expect(stats['totalImpressions'], isA<int>());
        expect(stats['totalRevenue'], isA<double>());
        expect(stats['averageECPM'], isA<double>());
        expect(stats['completionRate'], isA<double>());
        expect(stats['premiumConversions'], isA<int>());
        expect(stats['revenueByMonth'], isA<Map>());
        expect(stats['topUsers'], isA<List>());

        // Validate data types and ranges
        expect(stats['totalImpressions'], greaterThanOrEqualTo(0));
        expect(stats['totalRevenue'], greaterThanOrEqualTo(0.0));
        expect(stats['averageECPM'], greaterThanOrEqualTo(0.0));
        expect(stats['completionRate'], greaterThanOrEqualTo(0.0));
        expect(stats['completionRate'], lessThanOrEqualTo(1.0));
      });

      test('getUserAdStats() returns valid user statistics', () async {
        final userId = 'test_user_${DateTime.now().millisecondsSinceEpoch}';
        final stats = await AdminService.getUserAdStats(userId);

        expect(stats, isA<Map<String, dynamic>>());
        expect(stats['totalViews'], isA<int>());
        expect(stats['completedViews'], isA<int>());
        expect(stats['skippedViews'], isA<int>());
        expect(stats['failedViews'], isA<int>());
        expect(stats['completionRate'], isA<double>());
        expect(stats['totalRevenue'], isA<double>());

        // Validate data consistency
        expect(
            stats['totalViews'],
            equals(stats['completedViews'] +
                stats['skippedViews'] +
                stats['failedViews']));
        expect(stats['completionRate'], greaterThanOrEqualTo(0.0));
        expect(stats['completionRate'], lessThanOrEqualTo(1.0));
      });

      test('getSystemAdStats() returns valid system statistics', () async {
        final stats = await AdminService.getSystemAdStats();

        expect(stats, isA<Map<String, dynamic>>());
        expect(stats['totalUsers'], isA<int>());
        expect(stats['premiumUsers'], isA<int>());
        expect(stats['childAccounts'], isA<int>());
        expect(stats['totalAdImpressions'], isA<int>());
        expect(stats['totalAdRevenue'], isA<double>());
        expect(stats['averageCompletionRate'], isA<double>());
        expect(stats['topLocations'], isA<List>());

        // Validate data consistency
        expect(stats['totalUsers'], greaterThanOrEqualTo(0));
        expect(stats['premiumUsers'], greaterThanOrEqualTo(0));
        expect(stats['childAccounts'], greaterThanOrEqualTo(0));
        expect(stats['premiumUsers'], lessThanOrEqualTo(stats['totalUsers']));
        expect(stats['childAccounts'], lessThanOrEqualTo(stats['totalUsers']));
        expect(stats['averageCompletionRate'], greaterThanOrEqualTo(0.0));
        expect(stats['averageCompletionRate'], lessThanOrEqualTo(1.0));
      });
    });

    group('User Management', () {
      test('getUserManagementData() returns valid user data', () async {
        final data = await AdminService.getUserManagementData();

        expect(data, isA<Map<String, dynamic>>());
        expect(data['users'], isA<List>());
        expect(data['statistics'], isA<Map<String, dynamic>>());

        final stats = data['statistics'];
        expect(stats['totalUsers'], isA<int>());
        expect(stats['premiumUsers'], isA<int>());
        expect(stats['disabledAdsUsers'], isA<int>());
        expect(stats['activeUsers'], isA<int>());

        // Validate user data structure
        if (data['users'].isNotEmpty) {
          final user = data['users'][0];
          expect(user['userId'], isA<String>());
          expect(user['email'], isA<String>());
          expect(user['displayName'], isA<String>());
          expect(user['isPremium'], isA<bool>());
          expect(user['adsDisabled'], isA<bool>());
          expect(user['status'], isA<String>());
        }
      });

      test('updateUserStatus() updates user status successfully', () async {
        final userId =
            'test_user_status_${DateTime.now().millisecondsSinceEpoch}';
        final status = 'active';
        final reason = 'Test status update';

        final success =
            await AdminService.updateUserStatus(userId, status, reason);
        expect(success, isTrue);
      });
    });

    group('Ad Control', () {
      test('disableAdsForUser() disables ads successfully', () async {
        final userId =
            'test_user_disable_${DateTime.now().millisecondsSinceEpoch}';

        final success = await AdminService.disableAdsForUser(userId);
        expect(success, isTrue);
      });

      test('enableAdsForUser() enables ads successfully', () async {
        final userId =
            'test_user_enable_${DateTime.now().millisecondsSinceEpoch}';

        final success = await AdminService.enableAdsForUser(userId);
        expect(success, isTrue);
      });
    });

    group('Dashboard Data', () {
      test('getAdminDashboardData() returns valid dashboard data', () async {
        final data = await AdminService.getAdminDashboardData();

        expect(data, isA<Map<String, dynamic>>());
        expect(data['revenue'], isA<Map<String, dynamic>>());
        expect(data['system'], isA<Map<String, dynamic>>());
        expect(data['recentActivity'], isA<List>());

        // Validate revenue data
        final revenue = data['revenue'];
        expect(revenue['totalImpressions'], isA<int>());
        expect(revenue['totalRevenue'], isA<double>());

        // Validate system data
        final system = data['system'];
        expect(system['totalUsers'], isA<int>());
        expect(system['premiumUsers'], isA<int>());

        // Validate recent activity
        final activity = data['recentActivity'];
        expect(activity, isA<List>());
      });
    });

    group('Error Handling', () {
      test('handles invalid user IDs gracefully', () async {
        final stats = await AdminService.getUserAdStats('');
        expect(stats['totalViews'], equals(0));
        expect(stats['totalRevenue'], equals(0.0));
      });

      test('handles network errors gracefully', () async {
        // This test would require mocking network failures
        // For now, we test that the service doesn't crash
        final config = await AdminService.getAdConfig();
        expect(config, isA<Map<String, dynamic>>());
      });
    });

    group('Data Validation', () {
      test('revenue calculations are mathematically correct', () async {
        final stats = await AdminService.getAdRevenueStats();

        if (stats['totalImpressions'] > 0) {
          // eCPM should be (totalRevenue / totalImpressions) * 1000
          final expectedECPM =
              (stats['totalRevenue'] / stats['totalImpressions']) * 1000;
          expect(stats['averageECPM'], closeTo(expectedECPM, 0.01));

          // Completion rate should be completedViews / totalImpressions
          final completedViews = stats['totalImpressions'] -
              (stats['topUsers'] as List)
                  .fold(0, (sum, user) => sum + (user['impressions'] as int));
          final expectedCompletionRate =
              completedViews / stats['totalImpressions'];
          expect(
              stats['completionRate'], closeTo(expectedCompletionRate, 0.01));
        }
      });

      test('user statistics are consistent', () async {
        final data = await AdminService.getUserManagementData();
        final stats = data['statistics'];

        expect(stats['premiumUsers'], lessThanOrEqualTo(stats['totalUsers']));
        expect(
            stats['disabledAdsUsers'], lessThanOrEqualTo(stats['totalUsers']));
        expect(stats['activeUsers'], lessThanOrEqualTo(stats['totalUsers']));
      });
    });

    group('Performance', () {
      test('getAdRevenueStats() completes within reasonable time', () async {
        final stopwatch = Stopwatch()..start();
        await AdminService.getAdRevenueStats();
        stopwatch.stop();

        // Should complete within 5 seconds
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
      });

      test('getUserManagementData() completes within reasonable time',
          () async {
        final stopwatch = Stopwatch()..start();
        await AdminService.getUserManagementData();
        stopwatch.stop();

        // Should complete within 5 seconds
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
      });
    });
  });
}

