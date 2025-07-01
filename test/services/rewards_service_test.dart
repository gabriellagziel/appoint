import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/services/rewards_service.dart';
import '../fake_firebase_setup.dart';
import '../fake_firebase_firestore.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('RewardsService', () {
    late RewardsService service;
    late FakeFirebaseFirestore firestore;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      service = RewardsService(firestore: firestore);
    });

    test('addReferralSignupPoints increments points', () async {
      const userId = 'user1';
      var points = await service.getPoints(userId);
      expect(points, 0);

      await service.addReferralSignupPoints(userId);
      points = await service.getPoints(userId);
      expect(points, RewardsService.referralSignupPoints);
    });

    test('multiple increments accumulate', () async {
      const userId = 'user2';
      await service.addReferralSignupPoints(userId);
      await service.addReferralSignupPoints(userId);

      final points = await service.getPoints(userId);
      expect(points, RewardsService.referralSignupPoints * 2);
    });
  });
}
