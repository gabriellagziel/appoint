import 'package:appoint/services/admin_service.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:appoint/services/referral_service.dart';
import 'package:appoint/services/user_deletion_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockUser extends Mock implements User {}

/// Factory for creating test services with mocked dependencies
class TestServiceFactory {
  static MockFirebaseFirestore _mockFirestore = MockFirebaseFirestore();
  static MockFirebaseAuth _mockAuth = MockFirebaseAuth();
  static MockUser _mockUser = MockUser();

  static void _setupBasicMocks() {
    // Setup basic Auth mocks
    when(() => _mockAuth.currentUser).thenReturn(_mockUser);
    when(() => _mockUser.uid).thenReturn('test-user-id');
  }

  /// Create a ReferralService with mocked dependencies
  static ReferralService createReferralService() {
    _setupBasicMocks();
    return ReferralService(
      firestore: _mockFirestore,
      auth: _mockAuth,
    );
  }

  /// Create an AdminService with mocked dependencies
  static AdminService createAdminService() {
    _setupBasicMocks();
    return AdminService(
      firestore: _mockFirestore,
      auth: _mockAuth,
    );
  }

  /// Create an AuthService with mocked dependencies
  static AuthService createMockAuthService() {
    _setupBasicMocks();
    return AuthService(firebaseAuth: _mockAuth);
  }

  /// Create a UserDeletionService with mocked dependencies
  static UserDeletionService createUserDeletionService() {
    _setupBasicMocks();
    return UserDeletionService(
      firestore: _mockFirestore,
      auth: _mockAuth,
    );
  }

  /// Get the mock Firestore instance
  static MockFirebaseFirestore get mockFirestore => _mockFirestore;

  /// Get the mock Auth instance
  static MockFirebaseAuth get mockAuth => _mockAuth;
}

// Mock service classes that extend the real services
class MockReferralService extends ReferralService {
  MockReferralService()
      : super(
          firestore: TestServiceFactory.mockFirestore,
          auth: TestServiceFactory.mockAuth,
        );
}

class MockAdminService extends AdminService {
  MockAdminService()
      : super(
          firestore: TestServiceFactory.mockFirestore,
          auth: TestServiceFactory.mockAuth,
        );
}

class MockAuthService extends AuthService {
  MockAuthService() : super(firebaseAuth: TestServiceFactory.mockAuth);
}

class MockUserDeletionService extends UserDeletionService {
  MockUserDeletionService()
      : super(
          firestore: TestServiceFactory.mockFirestore,
          auth: TestServiceFactory.mockAuth,
        );
}
