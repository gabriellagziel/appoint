import 'package:appoint/models/support_ticket.dart';
import 'package:flutter_test/flutter_test.dart';

import '../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('SupportTicket', () {
    test('toJson/fromJson round trip', () {
      final ticket = SupportTicket(
        id: '1',
        userId: 'u1',
        subject: 'Help',
        message: 'Need assistance',
        createdAt: DateTime(2024),
      );
      json = ticket.toJson();
      copy = SupportTicket.fromJson(json);
      expect(copy.id, ticket.id);
      expect(copy.userId, ticket.userId);
      expect(copy.subject, ticket.subject);
      expect(copy.message, ticket.message);
      expect(copy.createdAt, ticket.createdAt);
      expect(copy.status, ticket.status);
    });
  });
}
