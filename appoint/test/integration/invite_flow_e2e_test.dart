import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../lib/models/group_invite_link.dart';

void main() {
  group('Invite Flow E2E Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should create valid invite link', () {
      final invite = GroupInviteLink(
        meetingId: 'meeting_123',
        token: 'ABC123',
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        url: 'https://app-oint.com/join?token=ABC123',
        singleUse: true,
      );

      expect(invite.isValid, isTrue);
      expect(invite.isExpired, isFalse);
      expect(invite.isConsumed, isFalse);
      expect(invite.isActive, isTrue);
    });

    test('should handle expired invite', () {
      final invite = GroupInviteLink(
        meetingId: 'meeting_123',
        token: 'EXPIRED',
        expiresAt: DateTime.now().subtract(const Duration(days: 1)),
        url: 'https://app-oint.com/join?token=EXPIRED',
      );

      expect(invite.isExpired, isTrue);
      expect(invite.isValid, isFalse);
      expect(invite.isActive, isFalse);
    });

    test('should handle consumed single-use invite', () {
      final invite = GroupInviteLink(
        meetingId: 'meeting_123',
        token: 'USED',
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        url: 'https://app-oint.com/join?token=USED',
        singleUse: true,
        consumedAt: DateTime.now().subtract(const Duration(hours: 1)),
      );

      expect(invite.isConsumed, isTrue);
      expect(invite.isActive, isFalse);
      expect(invite.isValid, isFalse);
    });

    test('should add source to URL', () {
      final invite = GroupInviteLink(
        meetingId: 'meeting_123',
        token: 'ABC123',
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        url: 'https://app-oint.com/join?token=ABC123',
      );

      final urlWithSource = invite.withSource('telegram');
      expect(urlWithSource, contains('src=telegram'));
    });

    test('should handle missing source', () {
      final invite = GroupInviteLink(
        meetingId: 'meeting_123',
        token: 'ABC123',
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        url: 'https://app-oint.com/join?token=ABC123',
      );

      final urlWithoutSource = invite.withSource(null);
      expect(urlWithoutSource, equals(invite.url));
    });

    test('should format expiration display correctly', () {
      final invite = GroupInviteLink(
        meetingId: 'meeting_123',
        token: 'ABC123',
        expiresAt: DateTime.now().add(const Duration(days: 2)),
        url: 'https://app-oint.com/join?token=ABC123',
      );

      final display = invite.expirationDisplay;
      expect(display, contains('Expires in 2 days'));
    });
  });
}


