import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/models/support_ticket.dart';
import '../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('SupportTicket', () {
    test('toJson/fromJson round trip', () {
      final ticket = SupportTicket(
        id: '1',
        userId: 'u1',
        subject: 'Help',
        message: 'Need assistance',
        createdAt: DateTime(2024, 1, 1),
      );
      final json = ticket.toJson();
      final copy = SupportTicket.fromJson(json);
      expect(copy.id, ticket.id);
      expect(copy.userId, ticket.userId);
      expect(copy.subject, ticket.subject);
      expect(copy.message, ticket.message);
      expect(copy.createdAt, ticket.createdAt);
      expect(copy.status, ticket.status);
    });
  });
}
