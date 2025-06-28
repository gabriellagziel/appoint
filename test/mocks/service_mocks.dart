import 'package:mockito/annotations.dart';

import '../../lib/core/auth_service.dart';
import '../../lib/infra/firestore_service.dart';
import '../../lib/infra/firebase_storage_service.dart';

@GenerateMocks([FirestoreService, AuthService, FirebaseStorageService])
void main() {}
