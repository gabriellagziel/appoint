import 'package:flutter_test/flutter_test.dart';

// ignore_for_file: unused_local_variable, undefined_identifier
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/family_link.dart';
import 'package:appoint/models/permission.dart';
import 'package:appoint/models/privacy_request.dart';
import 'package:appoint/services/family_service.dart';
import 'package:appoint/providers/family_provider.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../fake_firebase_setup.dart';
import 'package:appoint/extensions/fl_chart_color_shim.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FakeUser implements User {
  @override
  final String uid;
  FakeUser(this.uid);
  // Implement only the members used by the code, throw UnimplementedError for others
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final fakeAuthUser = FakeUser('test-parent-id');
final fakeAuthStateProvider =
    FutureProvider<User?>((ref) async => fakeAuthUser);

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// Mock FamilyService for testing
class MockFamilyService implements FamilyService {
  final FirebaseFirestore firestore;

  MockFamilyService({required this.firestore});

  @override
  Future<FamilyLink> inviteChild(String parentId, String childEmail) async {
    return FamilyLink(
      id: 'test-invite',
      parentId: parentId,
      childId: childEmail,
      status: 'pending',
      invitedAt: DateTime.now(),
      consentedAt: [],
    );
  }

  @override
  Future<List<FamilyLink>> fetchFamilyLinks(String parentId) async {
    // Return mock data for testing
    return [
      FamilyLink(
        id: 'test-link-1',
        parentId: parentId,
        childId: 'child-1',
        status: 'pending',
        invitedAt: DateTime(2024, 1, 1),
        consentedAt: [],
      ),
      FamilyLink(
        id: 'test-link-2',
        parentId: parentId,
        childId: 'child-2',
        status: 'active',
        invitedAt: DateTime(2024, 1, 1),
        consentedAt: [DateTime(2024, 1, 2)],
      ),
    ];
  }

  @override
  Future<List<Permission>> fetchPermissions(String linkId) async {
    return [
      Permission(
        id: 'perm-1',
        familyLinkId: linkId,
        category: 'profile',
        accessLevel: 'read',
      ),
    ];
  }

  @override
  Future<List<PrivacyRequest>> fetchPrivacyRequests(String parentId) async {
    return [
      PrivacyRequest(
        id: 'req-1',
        childId: 'child-1',
        type: 'private_session',
        status: 'pending',
        requestedAt: DateTime(2024, 1, 1),
      ),
    ];
  }

  @override
  Future<void> cancelInvite(String parentId, String childId) async {
    // Mock implementation
  }

  @override
  Future<void> resendOtp(String parentId, String childId) async {
    // Mock implementation
  }

  @override
  Future<void> updateConsent(String linkId, bool grant) async {
    // Mock implementation
  }

  @override
  Future<void> updatePermissions(String linkId, List<Permission> perms) async {
    // Mock implementation
  }

  @override
  Future<void> sendPrivacyRequest(String childId) async {
    // Mock implementation
  }

  @override
  Future<void> sendOtp(String parentContact, String childId) async {
    // Mock implementation
  }

  @override
  Future<bool> verifyOtp(String parentContact, String code) async {
    return true; // Mock successful verification
  }

  @override
  Future<void> handlePrivacyRequest(String requestId, String action) async {
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

  group('Family Management System Tests', () {
    late ProviderContainer container;
    late MockFamilyService mockFamilyService;
    late FamilyService familyService;
    late MockFirebaseFirestore mockFirestore;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockFamilyService = MockFamilyService(firestore: mockFirestore);
      container = ProviderContainer(
        overrides: [
          familyServiceProvider.overrideWithValue(mockFamilyService),
          authStateProvider.overrideWith((ref) async => fakeAuthUser),
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
        invitedAt: DateTime(2024, 1, 1),
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
        requestedAt: DateTime(2024, 1, 1),
      );

      final json = privacyRequest.toJson();
      final fromJson = PrivacyRequest.fromJson(json);

      expect(fromJson.id, equals(privacyRequest.id));
      expect(fromJson.childId, equals(privacyRequest.childId));
      expect(fromJson.type, equals(privacyRequest.type));
      expect(fromJson.status, equals(privacyRequest.status));
      expect(fromJson.requestedAt, equals(privacyRequest.requestedAt));
    });

    test('FamilyService provider creation', () {
      final service = container.read(familyServiceProvider);
      expect(service, isA<MockFamilyService>());
    });

    test('FamilyLinks provider loads data correctly', () async {
      final notifier =
          container.read(familyLinksProvider('test-parent-id').notifier);

      // Trigger a load using the notifier
      await notifier.loadLinks();

      final state = container.read(familyLinksProvider('test-parent-id'));

      expect(state, isA<FamilyLinksState>());
      expect(state.pendingInvites, hasLength(1));
      expect(state.connectedChildren, hasLength(1));
      expect(state.pendingInvites.first.status, equals('pending'));
      expect(state.connectedChildren.first.status, equals('active'));
    });

    test('Permissions provider loads data correctly', () async {
      final permissions =
          await container.read(permissionsProvider('test-link-id').future);
      expect(permissions, hasLength(1));
      expect(permissions.first.category, equals('profile'));
      expect(permissions.first.accessLevel, equals('read'));
    });

    test('PrivacyRequests provider loads data correctly', () async {
      final sub = container.listen<AsyncValue<List<PrivacyRequest>>>(
        privacyRequestsProvider,
        (_, __) {},
        fireImmediately: true,
      );
      final requests = await container.read(privacyRequestsProvider.future);
      expect(requests, hasLength(1));
      expect(requests.first.type, equals('private_session'));
      expect(requests.first.status, equals('pending'));
      sub.close();
    });

    test('FamilyLinksNotifier cancelInvite method', () async {
      final notifier =
          container.read(familyLinksProvider('test-parent-id').notifier);

      final testLink = FamilyLink(
        id: 'test-link',
        parentId: 'test-parent-id',
        childId: 'test-child-id',
        status: 'pending',
        invitedAt: DateTime.now(),
        consentedAt: [],
      );

      await notifier.cancelInvite(testLink);

      // Verify the method was called (no exception thrown)
      expect(true, isTrue);
    });

    test('FamilyLinksNotifier resendInvite method', () async {
      final notifier =
          container.read(familyLinksProvider('test-parent-id').notifier);

      final testLink = FamilyLink(
        id: 'test-link',
        parentId: 'test-parent-id',
        childId: 'test-child-id',
        status: 'pending',
        invitedAt: DateTime.now(),
        consentedAt: [],
      );

      await notifier.resendInvite(testLink);

      // Verify the method was called (no exception thrown)
      expect(true, isTrue);
    });
  });
}
