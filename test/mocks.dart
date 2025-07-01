// test/mocks.dart
import 'package:mockito/annotations.dart';
import 'package:REDACTED_TOKEN/REDACTED_TOKEN.dart';
import 'package:REDACTED_TOKEN/REDACTED_TOKEN.dart';
import 'package:file_picker/file_picker.dart';
import 'package:appoint/infra/firestore_service.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:appoint/infra/firebase_storage_service.dart';
import 'package:appoint/services/admin_service.dart';
import 'package:appoint/services/ambassador_service.dart';
import 'package:appoint/services/family_service.dart';
import 'package:appoint/services/business_subscription_service.dart';
import 'package:appoint/generated/pigeon_auth_api.dart';
import 'package:appoint/generated/pigeon_firestore_api.dart';

@GenerateMocks([
  FirebaseFirestorePlatform,
  FirebaseCrashlyticsPlatform,
  FilePicker,
  FirestoreService,
  AuthService,
  FirebaseStorageService,
  AdminService,
  AmbassadorService,
  FamilyService,
  BusinessSubscriptionService,
  AuthHostApi,
  FirestoreHostApi,
])
void main() {} 