import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/services/map_access_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

void main() {
  group('MapAccessService', () {
    late FakeFirebaseFirestore firestore;
    late MockFirebaseAuth auth;
    late MapAccessService service;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      auth = MockFirebaseAuth();
      service = MapAccessService(firestore: firestore, auth: auth);
    });

    test('Free user can view up to 5 unique appointments once each', () async {
      // Sign-in a mock free user.
      final user = await auth.signInWithEmailAndPassword(
          email: 'free@user.com', password: 'password');

      // Ensure user document exists.
      await firestore.collection('users').doc(user.user!.uid).set({
        'premium': false,
        'mapViewCount': 0,
      });

      // First 5 unique appointments should be allowed.
      for (var i = 1; i <= 5; i++) {
        final allowed = await service.canViewAndRecord('apt_$i');
        expect(allowed, isTrue, reason: 'Appointment $i should be allowed');
      }

      // Sixth appointment should be blocked.
      final blocked = await service.canViewAndRecord('apt_6');
      expect(blocked, isFalse, reason: '6th appointment should be blocked');

      // Attempting to view an already viewed appointment again should be blocked.
      final repeatBlocked = await service.canViewAndRecord('apt_1');
      expect(repeatBlocked, isFalse,
          reason: 'Revisiting same appointment should be blocked');
    });

    test('Premium user always allowed', () async {
      final user = await auth.signInWithEmailAndPassword(
          email: 'premium@user.com', password: 'password');
      await firestore.collection('users').doc(user.user!.uid).set({
        'premium': true,
        'mapViewCount': 0,
      });

      for (var i = 1; i <= 10; i++) {
        final allowed = await service.canViewAndRecord('apt_$i');
        expect(allowed, isTrue);
      }
    });
  });
}