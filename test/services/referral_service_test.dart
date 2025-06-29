import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/services/referral_service.dart';
import '../fake_firebase_setup.dart';
import '../fake_firebase_firestore.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('ReferralService', () {
    late ReferralService service;
    late FakeFirebaseFirestore firestore;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      service = ReferralService(firestore: firestore);
    });

    test('generates and persists 8 character code', () async {
      final code = await service.generateReferralCode('user1');
      expect(code.length, 8);
      final stored = await firestore.collection('referrals').doc('user1').get();
      expect(stored.exists, true);
      expect(stored.data()!['code'], code);
    });

    test('returns same code on subsequent calls', () async {
      final first = await service.generateReferralCode('user1');
      final second = await service.generateReferralCode('user1');
      expect(first, second);
    });

    test('codes for different users are unique', () async {
      final first = await service.generateReferralCode('user1');
      final second = await service.generateReferralCode('user2');
      expect(first == second, false);
    });
  });
}
