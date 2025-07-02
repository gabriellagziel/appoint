import 'package:mocktail/mocktail.dart';

import '../../lib/services/auth_service.dart';
import '../../lib/infra/firestore_service.dart';
import '../../lib/infra/firebase_storage_service.dart';

class MockFirestoreService extends Mock implements FirestoreService {}

class MockAuthService extends Mock implements AuthService {}

class MockFirebaseStorageService extends Mock
    implements FirebaseStorageService {}
