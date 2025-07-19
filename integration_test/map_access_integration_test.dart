import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:appoint/services/map_access_service.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Free user limited to 5 map views total', (tester) async {
    final firestore = FakeFirebaseFirestore();
    final auth = MockFirebaseAuth();
    final service = MapAccessService(firestore: firestore, auth: auth);

    final user = await auth.signInWithEmailAndPassword(
        email: 'free@plans.com', password: '123456');

    await firestore.collection('users').doc(user.user!.uid).set({
      'premium': false,
      'mapViewCount': 0,
    });

    // Allow 5 appointments.
    for (var i = 1; i <= 5; i++) {
      expect(await service.canViewAndRecord('appointment_$i'), isTrue);
    }

    // 6th appointment should be blocked.
    expect(await service.canViewAndRecord('appointment_6'), isFalse);
  });
}