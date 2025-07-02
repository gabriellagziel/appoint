import 'package:mocktail/mocktail.dart';
import 'package:appoint/services/auth_service.dart';
import 'package:appoint/services/notification_service.dart';
import 'package:appoint/services/appointment_service.dart';

class MockAuthService extends Mock implements AuthService {}
class MockNotificationService extends Mock implements NotificationService {}
class MockAppointmentService extends Mock implements AppointmentService {}
