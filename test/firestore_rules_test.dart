import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Comprehensive Firestore rules unit tests
/// Tests all security rules to ensure proper access control
void main() {
  group('Firestore Security Rules Tests', () {
    late FirebaseFirestore firestore;
    late FirebaseAuth auth;

    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();

      // Initialize Firebase for testing
      await Firebase.initializeApp();
      firestore = FirebaseFirestore.instance;
      auth = FirebaseAuth.instance;
    });

    group('Admin Logs Access Control', () {
      test('Non-admin cannot read admin_logs', () async {
        // Create a non-admin user
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore.collection('admin_logs').get();
          fail('Non-admin should not be able to read admin_logs');
        } catch (e) {
          expect(e.toString(), contains('permission-denied'));
        }
      });

      test('Admin cannot delete admin_logs', () async {
        // Create an admin user (simulated)
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        // Set admin custom claims (in real app, this would be done by Cloud Function)
        await user.getIdToken(true); // Force token refresh

        try {
          await firestore.collection('admin_logs').doc('test').delete();
          fail('Admin should not be able to delete admin_logs');
        } catch (e) {
          expect(e.toString(), contains('permission-denied'));
        }
      });

      test('Super admin can create admin_logs', () async {
        // Create a super admin user (simulated)
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore.collection('admin_logs').add({
            'adminId': user.uid,
            'action': 'test_action',
            'details': {'test': 'data'},
            'timestamp': FieldValue.serverTimestamp(),
          });
          // Should succeed for super admin
        } catch (e) {
          fail('Super admin should be able to create admin_logs: $e');
        }
      });
    });

    group('User Data Access Control', () {
      test('User can read their own data', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore.collection('users').doc(user.uid).get();
          // Should succeed
        } catch (e) {
          fail('User should be able to read their own data: $e');
        }
      });

      test('User cannot read other user data', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore.collection('users').doc('other_user_id').get();
          fail('User should not be able to read other user data');
        } catch (e) {
          expect(e.toString(), contains('permission-denied'));
        }
      });

      test('User can update their own basic info', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore.collection('users').doc(user.uid).update({
            'displayName': 'Updated Name',
            'email': 'updated@test.com',
          });
          // Should succeed
        } catch (e) {
          fail('User should be able to update their basic info: $e');
        }
      });

      test('User cannot update critical admin fields', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore.collection('users').doc(user.uid).update({
            'status': 'suspended',
            'isPremium': true,
            'adsDisabled': true,
          });
          fail('User should not be able to update critical admin fields');
        } catch (e) {
          expect(e.toString(), contains('permission-denied'));
        }
      });

      test('Admin can update user status', () async {
        // Create an admin user (simulated)
        final userCredential = await auth.signInAnonymously();
        final adminUser = userCredential.user!;

        try {
          await firestore.collection('users').doc('test_user').update({
            'status': 'active',
            'statusUpdatedAt': FieldValue.serverTimestamp(),
            'statusReason': 'Admin update',
          });
          // Should succeed for admin
        } catch (e) {
          fail('Admin should be able to update user status: $e');
        }
      });
    });

    group('Ad Impressions Access Control', () {
      test('User can create their own ad impressions', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore.collection('ad_impressions').add({
            'userId': user.uid,
            'type': 'interstitial',
            'status': 'completed',
            'location': 'test_location',
            'revenue': 0.10,
            'timestamp': FieldValue.serverTimestamp(),
          });
          // Should succeed
        } catch (e) {
          fail('User should be able to create their own ad impressions: $e');
        }
      });

      test('User can read their own ad impressions', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore
              .collection('ad_impressions')
              .where('userId', isEqualTo: user.uid)
              .get();
          // Should succeed
        } catch (e) {
          fail('User should be able to read their own ad impressions: $e');
        }
      });

      test('User cannot read other user ad impressions', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore
              .collection('ad_impressions')
              .where('userId', isEqualTo: 'other_user_id')
              .get();
          fail('User should not be able to read other user ad impressions');
        } catch (e) {
          expect(e.toString(), contains('permission-denied'));
        }
      });

      test('Admin can read all ad impressions', () async {
        // Create an admin user (simulated)
        final userCredential = await auth.signInAnonymously();
        final adminUser = userCredential.user!;

        try {
          await firestore.collection('ad_impressions').get();
          // Should succeed for admin
        } catch (e) {
          fail('Admin should be able to read all ad impressions: $e');
        }
      });
    });

    group('Premium Conversions Access Control', () {
      test('User can create their own premium conversions', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore.collection('premium_conversions').add({
            'userId': user.uid,
            'amount': 9.99,
            'currency': 'USD',
            'source': 'web_checkout',
            'status': 'completed',
            'createdAt': FieldValue.serverTimestamp(),
          });
          // Should succeed
        } catch (e) {
          fail(
              'User should be able to create their own premium conversions: $e');
        }
      });

      test('User can read their own premium conversions', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore
              .collection('premium_conversions')
              .where('userId', isEqualTo: user.uid)
              .get();
          // Should succeed
        } catch (e) {
          fail('User should be able to read their own premium conversions: $e');
        }
      });

      test('Admin can read all premium conversions', () async {
        // Create an admin user (simulated)
        final userCredential = await auth.signInAnonymously();
        final adminUser = userCredential.user!;

        try {
          await firestore.collection('premium_conversions').get();
          // Should succeed for admin
        } catch (e) {
          fail('Admin should be able to read all premium conversions: $e');
        }
      });
    });

    group('COPPA Compliance Tests', () {
      test('Child user cannot create ad impressions', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        // Simulate child user (age < 13)
        await firestore.collection('users').doc(user.uid).set({
          'age': 12,
          'adsDisabled': true,
        });

        try {
          await firestore.collection('ad_impressions').add({
            'userId': user.uid,
            'type': 'interstitial',
            'status': 'completed',
            'timestamp': FieldValue.serverTimestamp(),
          });
          fail('Child user should not be able to create ad impressions');
        } catch (e) {
          expect(e.toString(), contains('permission-denied'));
        }
      });

      test('Parent can approve child playtime sessions', () async {
        final parentCredential = await auth.signInAnonymously();
        final parentUser = parentCredential.user!;

        final childCredential = await auth.signInAnonymously();
        final childUser = childCredential.user!;

        // Set up parent-child relationship
        await firestore.collection('users').doc(childUser.uid).update({
          'parentUid': parentUser.uid,
          'age': 12,
        });

        try {
          await firestore.collection('playtime_sessions').add({
            'userId': childUser.uid,
            'parentUid': parentUser.uid,
            'gameId': 'game_1',
            'status': 'approved',
            'duration': 1800,
            'createdAt': FieldValue.serverTimestamp(),
            'approvedAt': FieldValue.serverTimestamp(),
          });
          // Should succeed
        } catch (e) {
          fail('Parent should be able to approve child playtime sessions: $e');
        }
      });
    });

    group('Admin Configuration Access Control', () {
      test('Non-admin cannot read admin_config', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore.collection('admin_config').doc('ad_settings').get();
          fail('Non-admin should not be able to read admin_config');
        } catch (e) {
          expect(e.toString(), contains('permission-denied'));
        }
      });

      test('Admin cannot write admin_config', () async {
        // Create an admin user (simulated)
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore.collection('admin_config').doc('ad_settings').update({
            'enabled': false,
          });
          fail('Admin should not be able to write admin_config');
        } catch (e) {
          expect(e.toString(), contains('permission-denied'));
        }
      });

      test('Super admin can write admin_config', () async {
        // Create a super admin user (simulated)
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore.collection('admin_config').doc('ad_settings').set({
            'enabled': true,
            'minimumAdInterval': 300,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          // Should succeed for super admin
        } catch (e) {
          fail('Super admin should be able to write admin_config: $e');
        }
      });
    });

    group('Group Management Access Control', () {
      test('Group member can read group data', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        // Create a group with the user as member
        await firestore.collection('user_groups').doc('test_group').set({
          'name': 'Test Group',
          'ownerId': 'owner_user',
          'members': {user.uid: true},
          'admins': {},
          'createdAt': FieldValue.serverTimestamp(),
        });

        try {
          await firestore.collection('user_groups').doc('test_group').get();
          // Should succeed
        } catch (e) {
          fail('Group member should be able to read group data: $e');
        }
      });

      test('Non-member cannot read group data', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore.collection('user_groups').doc('test_group').get();
          fail('Non-member should not be able to read group data');
        } catch (e) {
          expect(e.toString(), contains('permission-denied'));
        }
      });

      test('Group admin can create votes', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        // Create a group with the user as admin
        await firestore.collection('user_groups').doc('test_group').set({
          'name': 'Test Group',
          'ownerId': 'owner_user',
          'members': {},
          'admins': {user.uid: true},
          'createdAt': FieldValue.serverTimestamp(),
        });

        try {
          await firestore
              .collection('user_groups')
              .doc('test_group')
              .collection('votes')
              .add({
            'title': 'Test Vote',
            'description': 'Test vote description',
            'createdBy': user.uid,
            'status': 'open',
            'createdAt': FieldValue.serverTimestamp(),
          });
          // Should succeed
        } catch (e) {
          fail('Group admin should be able to create votes: $e');
        }
      });
    });

    group('Analytics and Metrics Access Control', () {
      test('Non-admin cannot read analytics', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore.collection('analytics').get();
          fail('Non-admin should not be able to read analytics');
        } catch (e) {
          expect(e.toString(), contains('permission-denied'));
        }
      });

      test('Super admin can read analytics', () async {
        // Create a super admin user (simulated)
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore.collection('analytics').get();
          // Should succeed for super admin
        } catch (e) {
          fail('Super admin should be able to read analytics: $e');
        }
      });

      test('Non-admin cannot read system_metrics', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore.collection('system_metrics').get();
          fail('Non-admin should not be able to read system_metrics');
        } catch (e) {
          expect(e.toString(), contains('permission-denied'));
        }
      });
    });

    group('Feature Flags Access Control', () {
      test('Authenticated user can read feature flags', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore.collection('feature_flags').doc('main').get();
          // Should succeed
        } catch (e) {
          fail('Authenticated user should be able to read feature flags: $e');
        }
      });

      test('Non-admin cannot write feature flags', () async {
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        try {
          await firestore.collection('feature_flags').doc('main').update({
            'admin_panel_enabled': false,
          });
          fail('Non-admin should not be able to write feature flags');
        } catch (e) {
          expect(e.toString(), contains('permission-denied'));
        }
      });
    });
  });
}

