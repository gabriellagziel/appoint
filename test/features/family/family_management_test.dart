import 'package:appoint/models/app_user.dart';
import 'package:appoint/models/family_link.dart';
import 'package:appoint/models/permission.dart';
import 'package:appoint/models/privacy_request.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/providers/family_provider.dart';
import 'package:appoint/services/family_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../fake_firebase_setup.dart';
import '../../firebase_test_helper.dart';

class FakeUser implements User {
  FakeUser(this.uid);
  @override
  final String uid;
  // Implement only the members used by the code, throw UnimplementedError for others
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final fakeAuthUser = FakeUser('test-parent-id');
final fakeAuthStateProvider =
    FutureProvider<User?>((ref) async => fakeAuthUser);

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// Mock FamilyService for testing
class MockFamilyService implements FamilyService {
  MockFamilyService({required this.firestore});
  final FirebaseFirestore firestore;

  @override
  Future<FamilyLink> inviteChild(
    String parentId,
    final String childEmail,
  ) async =>
      FamilyLink(
        id: 'test-invite',
        parentId: parentId,
        childId: childEmail,
        status: 'pending',
        invitedAt: DateTime.now(),
        consentedAt: [],
      );

  @override
  Future<List<FamilyLink>> fetchFamilyLinks(String parentId) async {
    // Return mock data for testing
    return [
      FamilyLink(
        id: 'test-link-1',
        parentId: parentId,
        childId: 'child-1',
        status: 'pending',
        invitedAt: DateTime(2024),
        consentedAt: [],
      ),
      FamilyLink(
        id: 'test-link-2',
        parentId: parentId,
        childId: 'child-2',
        status: 'active',
        invitedAt: DateTime(2024),
        consentedAt: [DateTime(2024, 1, 2)],
      ),
    ];
  }

  @override
  Future<List<Permission>> fetchPermissions(String linkId) async => [
        Permission(
          id: 'perm-1',
          familyLinkId: linkId,
          category: 'profile',
          accessLevel: 'read',
        ),
      ];

  @override
  Future<List<PrivacyRequest>> fetchPrivacyRequests(
    String parentId,
  ) async =>
      [
        PrivacyRequest(
          id: 'req-1',
          childId: 'child-1',
          type: 'private_session',
          status: 'pending',
          requestedAt: DateTime(2024),
        ),
      ];

  @override
  Future<void> cancelInvite(String parentId, final String childId) async {
    // Mock implementation
  }

  @override
  Future<void> resendOtp(String parentId, final String childId) async {
    // Mock implementation
  }

  @override
  Future<void> updateConsent(String linkId, final bool grant) async {
    // Mock implementation
  }

  @override
  Future<void> updatePermissions(
    String linkId,
    final List<Permission> perms,
  ) async {
    // Mock implementation
  }

  @override
  Future<void> sendPrivacyRequest(String childId) async {
    // Mock implementation
  }

  @override
  Future<void> sendOtp(String parentContact, final String childId) async {
    // Mock implementation
  }

  @override
  Future<bool> verifyOtp(String parentContact, final String code) async {
    return true; // Mock successful verification
  }

  @override
  Future<void> handlePrivacyRequest(
    String requestId,
    final String action,
  ) async {
    // Mock implementation
  }

  @override
  Future<void> revokeAccess(String linkId) async {
    // Mock implementation
  }
}

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();
  setupFirebaseMocks();

  group('Family Management System Tests', () {
    late ProviderContainer container;
    late MockFamilyService mockFamilyService;
    late MockFirebaseFirestore mockFirestore;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockFamilyService = MockFamilyService(firestore: mockFirestore);
      container = ProviderContainer(
        overrides: [
          familyServiceProvider.overrideWithValue(mockFamilyService),
          authStateProvider.overrideWith(
            (ref) => Stream.value(
              const AppUser(
                uid: 'test-user-id',
                email: 'test@example.com',
                role: 'user',
              ),
            ),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('FamilyLink model serialization', () {
      final familyLink = FamilyLink(
        id: 'test-id',
        parentId: 'parent-123',
        childId: 'child-456',
        status: 'active',
        invitedAt: DateTime(2024),
        consentedAt: [DateTime(2024, 1, 2)],
      );

      final json = familyLink.toJson();
      final fromJson = FamilyLink.fromJson(json);

      expect(fromJson.id, equals(familyLink.id));
      expect(fromJson.parentId, equals(familyLink.parentId));
      expect(fromJson.childId, equals(familyLink.childId));
      expect(fromJson.status, equals(familyLink.status));
      expect(fromJson.invitedAt, equals(familyLink.invitedAt));
      expect(fromJson.consentedAt, equals(familyLink.consentedAt));
    });

    test('Permission model serialization', () {
      final permission = Permission(
        id: 'perm-123',
        familyLinkId: 'link-456',
        category: 'profile',
        accessLevel: 'read',
      );

      final json = permission.toJson();
      final fromJson = Permission.fromJson(json);

      expect(fromJson.id, equals(permission.id));
      expect(fromJson.familyLinkId, equals(permission.familyLinkId));
      expect(fromJson.category, equals(permission.category));
      expect(fromJson.accessLevel, equals(permission.accessLevel));
    });

    test('PrivacyRequest model serialization', () {
      final privacyRequest = PrivacyRequest(
        id: 'req-123',
        childId: 'child-456',
        type: 'private_session',
        status: 'pending',
        requestedAt: DateTime(2024),
      );

      final json = privacyRequest.toJson();
      final fromJson = PrivacyRequest.fromJson(json);

      expect(fromJson.id, equals(privacyRequest.id));
      expect(fromJson.childId, equals(privacyRequest.childId));
      expect(fromJson.type, equals(privacyRequest.type));
      expect(fromJson.status, equals(privacyRequest.status));
      expect(fromJson.requestedAt, equals(privacyRequest.requestedAt));
    });

    test('FamilyService can invite child', () async {
      final result = await mockFamilyService.inviteChild(
          'parent-123', 'child@example.com');

      expect(result.id, equals('test-invite'));
      expect(result.parentId, equals('parent-123'));
      expect(result.childId, equals('child@example.com'));
      expect(result.status, equals('pending'));
    });

    test('FamilyService can fetch family links', () async {
      final links = await mockFamilyService.fetchFamilyLinks('parent-123');

      expect(links.length, equals(2));
      expect(links[0].status, equals('pending'));
      expect(links[1].status, equals('active'));
    });

    test('FamilyService can verify OTP', () async {
      final result = await mockFamilyService.verifyOtp('+1234567890', '123456');

      expect(result, isTrue);
    });
  });
}
