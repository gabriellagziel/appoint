// test/mocks.dart
import 'package:appoint/services/admin_service.dart';
import 'package:appoint/services/ambassador_quota_service.dart';
import 'package:appoint/services/ambassador_service.dart';
import 'package:appoint/services/appointment_service.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:appoint/services/calendar_service.dart';
import 'package:appoint/services/family_service.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:appoint/services/payment_service.dart';
import 'package:appoint/services/playtime_service.dart';
import 'package:appoint/services/studio_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

class MockNotificationService extends Mock implements NotificationService {}

class MockAppointmentService extends Mock implements AppointmentService {}

class MockAdminService extends Mock implements AdminService {}

class MockAmbassadorService extends Mock implements AmbassadorService {}

class MockAmbassadorQuotaService extends Mock
    implements AmbassadorQuotaService {}

class MockCalendarService extends Mock implements CalendarService {}

class MockPaymentService extends Mock implements PaymentService {}

class MockStudioService extends Mock implements StudioService {}

class MockFamilyService extends Mock implements FamilyService {}

class MockPlaytimeService extends Mock implements PlaytimeService {}
