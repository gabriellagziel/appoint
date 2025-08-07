import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appoint/services/referral_service.dart';
import 'fake_firebase_firestore.dart';
import 'fake_firebase_setup.dart';

class FakeUser extends Fake implements User {
  @override
  final String uid;
  FakeUser(this.uid);
}

class FakeAuth extends Fake implements FirebaseAuth {
  FakeAuth(this._user);
  final User? _user;
  @override
  User? get currentUser => _user;
}

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('ReferralService', () {
    late FakeFirebaseFirestore firestore;
    late FakeAuth auth;
    late ReferralService service;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      auth = FakeAuth(FakeUser('u1'));
      service = ReferralService(firestore: firestore, auth: auth);
    });

    test('generateReferralCode stores code in firestore', () async {
      final code = await service.generateReferralCode();
      final snap = await firestore.collection('referralCodes').doc('u1').get();
      expect(snap.data()?['code'], code);
    });

    test('generateReferralCode returns existing code', () async {
      final first = await service.generateReferralCode();
      final second = await service.generateReferralCode();
      expect(second, first);
    });

    test('listenToReferralUsage emits updates', () async {
      await service.generateReferralCode();
      final stream = service.listenToReferralUsage();
      expectLater(stream, emitsInOrder([0, 2]));
      await firestore
          .collection('referralCodes')
          .doc('u1')
          .update({'usageCount': 2});
    });
  });
}
