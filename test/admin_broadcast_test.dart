import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/models/admin_broadcast_message.dart';
import 'package:appoint/models/user_profile.dart';

void main() {
  group('AdminBroadcastMessage Tests', () {
    test('should create AdminBroadcastMessage with required fields', () {
      final message = AdminBroadcastMessage(
        id: 'test-id',
        title: 'Test Message',
        content: 'Test content',
        type: BroadcastMessageType.text,
        targetingFilters: const BroadcastTargetingFilters(),
        createdByAdminId: 'admin-id',
        createdByAdminName: 'Admin User',
        createdAt: DateTime.now(),
        status: BroadcastMessageStatus.pending,
      );

      expect(message.id, 'test-id');
      expect(message.title, 'Test Message');
      expect(message.content, 'Test content');
      expect(message.type, BroadcastMessageType.text);
      expect(message.status, BroadcastMessageStatus.pending);
    });

    test('should create BroadcastTargetingFilters with optional fields', () {
      final filters = BroadcastTargetingFilters(
        countries: ['US', 'CA'],
        cities: ['New York', 'Toronto'],
        subscriptionTiers: ['premium', 'basic'],
        userRoles: ['user', 'admin'],
      );

      expect(filters.countries, ['US', 'CA']);
      expect(filters.cities, ['New York', 'Toronto']);
      expect(filters.subscriptionTiers, ['premium', 'basic']);
      expect(filters.userRoles, ['user', 'admin']);
    });

    test('should create UserProfile with required fields', () {
      final user = UserProfile(
        id: 'user-id',
        name: 'Test User',
        email: 'test@example.com',
      );

      expect(user.id, 'user-id');
      expect(user.name, 'Test User');
      expect(user.email, 'test@example.com');
    });
  });
}