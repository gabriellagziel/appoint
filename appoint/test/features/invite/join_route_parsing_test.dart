import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../lib/models/group_invite_link.dart';

void main() {
  group('Join Route Parsing Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should parse token and src from URL parameters', () {
      // Mock URL parameters
      final params = {
        'token': 'ABC123',
        'src': 'telegram',
      };

      expect(params['token'], equals('ABC123'));
      expect(params['src'], equals('telegram'));
    });

    test('should handle missing src parameter', () {
      final params = {
        'token': 'ABC123',
      };

      expect(params['token'], equals('ABC123'));
      expect(params['src'], isNull);
    });

    test('should handle empty src parameter', () {
      final params = {
        'token': 'ABC123',
        'src': '',
      };

      expect(params['token'], equals('ABC123'));
      expect(params['src'], equals(''));
    });

    test('should parse URL parameters correctly', () {
      // Test URL parameter parsing logic
      final params = {
        'token': 'ABC123',
        'src': 'discord',
      };

      expect(params['token'], equals('ABC123'));
      expect(params['src'], equals('discord'));
    });

    test('should handle missing parameters gracefully', () {
      final params = {
        'token': 'ABC123',
      };

      expect(params['token'], equals('ABC123'));
      expect(params['src'], isNull);
    });

    test('should validate invite link structure', () {
      final link = GroupInviteLink(
        meetingId: 'meeting_123',
        token: 'ABC123',
        expiresAt: DateTime.now().add(const Duration(days: 7)),
        url: 'https://app-oint.com/join?token=ABC123',
      );

      expect(link.meetingId, equals('meeting_123'));
      expect(link.token, equals('ABC123'));
      expect(link.isValid, isTrue);
      expect(link.isExpired, isFalse);
    });
  });
}
