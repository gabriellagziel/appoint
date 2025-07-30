import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

// Generate mocks with custom names to avoid conflicts
@GenerateMocks([
  FirebaseAuth,
  User,
  UserCredential,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  QuerySnapshot,
  Query,
  FirebaseStorage,
  Reference,
  UploadTask,
  TaskSnapshot,
], customMocks: [
  MockSpec<FirebaseAuth>(as: #MockFirebaseAuthGenerated),
  MockSpec<User>(as: #MockUserGenerated),
  MockSpec<UserCredential>(as: #MockUserCredentialGenerated),
  MockSpec<FirebaseFirestore>(as: #MockFirebaseFirestoreGenerated),
  MockSpec<CollectionReference>(as: #REDACTED_TOKEN),
  MockSpec<DocumentReference>(as: #MockDocumentReferenceGenerated),
  MockSpec<DocumentSnapshot>(as: #MockDocumentSnapshotGenerated),
  MockSpec<QuerySnapshot>(as: #MockQuerySnapshotGenerated),
  MockSpec<Query>(as: #MockQueryGenerated),
  MockSpec<FirebaseStorage>(as: #MockFirebaseStorageGenerated),
  MockSpec<Reference>(as: #MockReferenceGenerated),
  MockSpec<UploadTask>(as: #MockUploadTaskGenerated),
  MockSpec<TaskSnapshot>(as: #MockTaskSnapshotGenerated),
])
void main() {}

// Test data factory for common test scenarios
class TestDataFactory {
  static Map<String, dynamic> createUserData({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
  }) {
    return {
      'uid': uid ?? 'test-uid',
      'displayName': displayName ?? 'Test User',
      'email': email ?? 'test@example.com',
      'photoUrl': photoUrl ?? 'https://example.com/photo.jpg',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  static Map<String, dynamic> createAppointmentData({
    String? id,
    String? userId,
    String? providerId,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
  }) {
    return {
      'id': id ?? 'appointment-${DateTime.now().millisecondsSinceEpoch}',
      'userId': userId ?? 'test-user-id',
      'providerId': providerId ?? 'test-provider-id',
      'service': 'Child Care',
      'startTime': (startTime ?? DateTime.now().add(Duration(hours: 1)))
          .toIso8601String(),
      'endTime':
          (endTime ?? DateTime.now().add(Duration(hours: 2))).toIso8601String(),
      'status': status ?? 'pending',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  static Map<String, dynamic> createProviderData({
    String? uid,
    String? displayName,
    List<String>? services,
  }) {
    return {
      'uid': uid ?? 'provider-${DateTime.now().millisecondsSinceEpoch}',
      'displayName': displayName ?? 'Test Provider',
      'email': 'provider@example.com',
      'services': services ?? ['Child Care', 'Elder Care'],
      'availability': {
        'monday': {'start': '09:00', 'end': '17:00'},
        'tuesday': {'start': '09:00', 'end': '17:00'},
        'wednesday': {'start': '09:00', 'end': '17:00'},
        'thursday': {'start': '09:00', 'end': '17:00'},
        'friday': {'start': '09:00', 'end': '17:00'},
      },
      'rating': 4.5,
      'reviewCount': 10,
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  static Map<String, dynamic> createBroadcastMessageData({
    String? id,
    String? title,
    String? message,
    String? type,
  }) {
    return {
      'id': id ?? 'broadcast-${DateTime.now().millisecondsSinceEpoch}',
      'title': title ?? 'Test Broadcast',
      'message': message ?? 'This is a test broadcast message',
      'type': type ?? 'text',
      'targetAudience': 'all',
      'scheduledTime':
          DateTime.now().add(Duration(minutes: 5)).toIso8601String(),
      'status': 'scheduled',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}

// Test environment setup helper
class TestEnvironment {
  static late MockFirebaseAuthGenerated mockAuth;
  static late MockFirebaseFirestoreGenerated mockFirestore;
  static late MockFirebaseStorageGenerated mockStorage;

  static void setupTestEnvironment() {
    mockAuth = MockFirebaseAuthGenerated();
    mockFirestore = MockFirebaseFirestoreGenerated();
    mockStorage = MockFirebaseStorageGenerated();
  }

  static void clearTestData() {
    // Reset mocks
    reset(mockAuth);
    reset(mockFirestore);
    reset(mockStorage);
  }
}
