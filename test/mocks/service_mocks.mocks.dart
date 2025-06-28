import 'package:mockito/mockito.dart';

import '../../lib/core/auth_service.dart';
import '../../lib/infra/firestore_service.dart';
import '../../lib/infra/firebase_storage_service.dart';

class MockFirestoreService extends Mock implements FirestoreService {}

class MockAuthService extends Mock implements AuthService {}

class MockFirebaseStorageService extends Mock
    implements FirebaseStorageService {}
