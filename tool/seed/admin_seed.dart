import 'package:cloud_firestore/cloud_firestore.dart';

/// Seed data for admin system testing
/// Run with: flutter pub run tool/seed/admin_seed.dart
Future<void> main() async {
  print('🌱 Starting admin seed data creation...');

  final db = FirebaseFirestore.instance;
  final batch = db.batch();

  try {
    // 1. Admin Configuration
    print('📋 Creating admin configuration...');
    final adminConfig = db.collection('admin_config').doc('ad_settings');
    batch.set(adminConfig, {
      'enabled': true,
      'minimumAdInterval': 300, // 5 minutes
      'adDuration': 15, // seconds
      'skipEnabled': true,
      'skipDelay': 5, // seconds
      'eCPM': 0.10, // $0.10 per 1000 impressions
      'premiumPrice': 9.99,
      'childAccountRestriction': true,
      'locations': [
        'booking_confirmation',
        'reminder_save',
        'feature_unlock',
      ],
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Admin users list
    final adminUsers = db.collection('admin_config').doc('admins');
    batch.set(adminUsers, {
      'adminUids': [
        'admin_user_1',
        'admin_user_2',
        'super_admin_1',
      ],
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Owner users list
    final ownerUsers = db.collection('admin_config').doc('owners');
    batch.set(ownerUsers, {
      'ownerUids': [
        'owner_user_1',
        'super_admin_1',
      ],
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // 2. Test Users
    print('👥 Creating test users...');

    // Premium user
    final premiumUser = db.collection('users').doc('u_premium');
    batch.set(premiumUser, {
      'email': 'premium@test.com',
      'displayName': 'Premium Test User',
      'isPremium': true,
      'status': 'active',
      'age': 25,
      'adsDisabled': false,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    });

    // Free user
    final freeUser = db.collection('users').doc('u_free');
    batch.set(freeUser, {
      'email': 'free@test.com',
      'displayName': 'Free Test User',
      'isPremium': false,
      'status': 'active',
      'age': 30,
      'adsDisabled': false,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    });

    // Child user (COPPA)
    final childUser = db.collection('users').doc('u_child');
    batch.set(childUser, {
      'email': 'child@test.com',
      'displayName': 'Child Test User',
      'isPremium': false,
      'status': 'active',
      'age': 12,
      'adsDisabled': true, // COPPA compliance
      'parentUid': 'u_parent',
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    });

    // Parent user
    final parentUser = db.collection('users').doc('u_parent');
    batch.set(parentUser, {
      'email': 'parent@test.com',
      'displayName': 'Parent Test User',
      'isPremium': false,
      'status': 'active',
      'age': 35,
      'adsDisabled': false,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    });

    // Admin user
    final adminUser = db.collection('users').doc('admin_user_1');
    batch.set(adminUser, {
      'email': 'admin@test.com',
      'displayName': 'Admin Test User',
      'isPremium': true,
      'status': 'active',
      'age': 28,
      'adsDisabled': false,
      'role': 'admin',
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    });

    // 3. Premium Conversions
    print('💰 Creating premium conversions...');

    final conv1 = db.collection('premium_conversions').doc();
    batch.set(conv1, {
      'userId': 'u_premium',
      'amount': 9.99,
      'currency': 'USD',
      'source': 'web_checkout',
      'status': 'completed',
      'createdAt': FieldValue.serverTimestamp(),
    });

    final conv2 = db.collection('premium_conversions').doc();
    batch.set(conv2, {
      'userId': 'admin_user_1',
      'amount': 9.99,
      'currency': 'USD',
      'source': 'mobile_app',
      'status': 'completed',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 4. Ad Impressions
    print('📊 Creating ad impressions...');

    // Premium user impressions
    for (int i = 0; i < 5; i++) {
      final impression = db.collection('ad_impressions').doc();
      batch.set(impression, {
        'userId': 'u_premium',
        'type': 'interstitial',
        'status': 'completed',
        'location': 'booking_confirmation',
        'revenue': 0.10,
        'timestamp': FieldValue.serverTimestamp(),
        'platform': 'web',
      });
    }

    // Free user impressions
    for (int i = 0; i < 8; i++) {
      final impression = db.collection('ad_impressions').doc();
      batch.set(impression, {
        'userId': 'u_free',
        'type': 'interstitial',
        'status': i < 6 ? 'completed' : 'skipped',
        'location': i < 4 ? 'reminder_save' : 'feature_unlock',
        'revenue': i < 6 ? 0.10 : 0.0,
        'timestamp': FieldValue.serverTimestamp(),
        'platform': 'mobile',
      });
    }

    // 5. Admin Logs
    print('📝 Creating admin logs...');

    final log1 = db.collection('admin_logs').doc();
    batch.set(log1, {
      'adminId': 'admin_user_1',
      'action': 'update_ad_config',
      'details': {
        'eCPM': 0.10,
        'enabled': true,
      },
      'timestamp': FieldValue.serverTimestamp(),
      'ipAddress': '192.168.1.1',
      'userAgent': 'Admin Panel/1.0',
    });

    final log2 = db.collection('admin_logs').doc();
    batch.set(log2, {
      'adminId': 'admin_user_1',
      'action': 'disable_ads_for_user',
      'details': {
        'userId': 'u_child',
        'reason': 'COPPA compliance',
      },
      'timestamp': FieldValue.serverTimestamp(),
      'ipAddress': '192.168.1.1',
      'userAgent': 'Admin Panel/1.0',
    });

    final log3 = db.collection('admin_logs').doc();
    batch.set(log3, {
      'adminId': 'admin_user_1',
      'action': 'update_user_status',
      'details': {
        'userId': 'u_free',
        'status': 'active',
        'reason': 'User verification completed',
      },
      'timestamp': FieldValue.serverTimestamp(),
      'ipAddress': '192.168.1.1',
      'userAgent': 'Admin Panel/1.0',
    });

    // 6. Playtime Games (COPPA)
    print('🎮 Creating playtime games...');

    final game1 = db.collection('playtime_games').doc('game_1');
    batch.set(game1, {
      'name': 'Educational Puzzle',
      'minAge': 6,
      'maxAge': 12,
      'category': 'educational',
      'description': 'Safe educational game for children',
      'createdAt': FieldValue.serverTimestamp(),
    });

    final game2 = db.collection('playtime_games').doc('game_2');
    batch.set(game2, {
      'name': 'Teen Adventure',
      'minAge': 13,
      'maxAge': 17,
      'category': 'adventure',
      'description': 'Adventure game for teenagers',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 7. Playtime Sessions
    print('⏰ Creating playtime sessions...');

    final session1 = db.collection('playtime_sessions').doc();
    batch.set(session1, {
      'userId': 'u_child',
      'gameId': 'game_1',
      'parentUid': 'u_parent',
      'status': 'approved',
      'duration': 1800, // 30 minutes
      'createdAt': FieldValue.serverTimestamp(),
      'approvedAt': FieldValue.serverTimestamp(),
    });

    // 8. Feature Flags
    print('🚩 Creating feature flags...');

    final featureFlags = db.collection('feature_flags').doc('main');
    batch.set(featureFlags, {
      'group_suggestions': true,
      'shareback_public': false,
      'event_forms_required': true,
      'coppa_enforcement': true,
      'admin_panel_enabled': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // 9. System Metrics
    print('📈 Creating system metrics...');

    final metrics = db
        .collection('system_metrics')
        .doc('daily_${DateTime.now().millisecondsSinceEpoch}');
    batch.set(metrics, {
      'date': DateTime.now().toIso8601String(),
      'totalUsers': 1250,
      'premiumUsers': 180,
      'childAccounts': 45,
      'totalAdImpressions': 12500,
      'totalAdRevenue': 1250.00,
      'averageCompletionRate': 0.82,
      'premiumConversions': 45,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 10. Analytics
    print('📊 Creating analytics data...');

    final analytics = db
        .collection('analytics')
        .doc('revenue_${DateTime.now().millisecondsSinceEpoch}');
    batch.set(analytics, {
      'metricType': 'revenue',
      'date': DateTime.now().toIso8601String(),
      'adRevenue': 1250.00,
      'premiumRevenue': 450.00,
      'totalRevenue': 1700.00,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Commit all changes
    await batch.commit();

    print('✅ Admin seed data created successfully!');
    print('');
    print('📋 Created collections:');
    print('  - admin_config (ad_settings, admins, owners)');
    print('  - users (5 test users)');
    print('  - premium_conversions (2 conversions)');
    print('  - ad_impressions (13 impressions)');
    print('  - admin_logs (3 log entries)');
    print('  - playtime_games (2 games)');
    print('  - playtime_sessions (1 session)');
    print('  - feature_flags (main)');
    print('  - system_metrics (daily)');
    print('  - analytics (revenue)');
    print('');
    print('🧪 Test users:');
    print('  - u_premium (Premium user)');
    print('  - u_free (Free user)');
    print('  - u_child (Child user - COPPA)');
    print('  - u_parent (Parent user)');
    print('  - admin_user_1 (Admin user)');
    print('');
    print('🔐 Admin credentials:');
    print('  - Admin UID: admin_user_1');
    print('  - Owner UID: owner_user_1');
    print('');
    print('🚀 Ready for testing!');
  } catch (e) {
    print('❌ Error creating seed data: $e');
    rethrow;
  }
}

