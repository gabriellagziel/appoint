import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/models/family_link.dart';
import 'package:appoint/extensions/fl_chart_color_shim.dart';
import 'fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();
  group('Family Integration Tests', () {
    test('FamilyLink model should serialize correctly', () {
      final link = FamilyLink(
        id: 'test-id',
        parentId: 'parent-123',
        childId: 'child-456',
        status: 'pending',
        invitedAt: DateTime.now(),
        consentedAt: [],
      );

      final json = link.toJson();
      final fromJson = FamilyLink.fromJson(json);

      expect(fromJson.id, equals(link.id));
      expect(fromJson.parentId, equals(link.parentId));
      expect(fromJson.childId, equals(link.childId));
      expect(fromJson.status, equals(link.status));
    });

    test('FamilyLink should categorize status correctly', () {
      final pendingLink = FamilyLink(
        id: 'pending-id',
        parentId: 'parent-123',
        childId: 'child-456',
        status: 'pending',
        invitedAt: DateTime.now(),
        consentedAt: [],
      );

      final activeLink = FamilyLink(
        id: 'active-id',
        parentId: 'parent-123',
        childId: 'child-789',
        status: 'active',
        invitedAt: DateTime.now(),
        consentedAt: [DateTime.now()],
      );

      expect(pendingLink.status, equals('pending'));
      expect(activeLink.status, equals('active'));
    });

    test('FamilyLink should handle different statuses', () {
      final revokedLink = FamilyLink(
        id: 'revoked-id',
        parentId: 'parent-123',
        childId: 'child-999',
        status: 'revoked',
        invitedAt: DateTime.now(),
        consentedAt: [],
      );

      expect(revokedLink.status, equals('revoked'));
    });
  });
}
