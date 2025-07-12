import 'package:appoint/infra/firebase_storage_service.dart';
import 'package:appoint/infra/firestore_service.dart';
import 'package:appoint/services/appointment_service.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

class MockNotificationService extends Mock implements NotificationService {}

class MockAppointmentService extends Mock implements AppointmentService {}

class MockFirestoreService extends Mock implements FirestoreService {}

class MockFirebaseStorageService extends Mock
    implements FirebaseStorageService {}
