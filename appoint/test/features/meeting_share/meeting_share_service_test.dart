import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../lib/features/meeting_share/services/meeting_share_service.dart';
import '../../lib/models/user_group.dart';

void main() {
  group('Meeting Share Service Tests', () {
    test('buildGroupShareUrl creates correct URL with UTM parameters', () {
      final service = MeetingShareService();

      final url = service.buildGroupShareUrl(
        meetingId: 'test-meeting-123',
        groupId: 'test-group-456',
        source: ShareSource.whatsappGroup,
      );

      expect(url, contains('https://app-oint.com/m/test-meeting-123'));
      expect(url, contains('g=test-group-456'));
      expect(url, contains('src=whatsappGroup'));
      expect(url, contains('utm_medium=group_share'));
      expect(url, contains('utm_source=whatsappGroup'));
      expect(url, contains('utm_campaign=meeting_invite'));
    });

    test('buildShareMessage creates correct message', () {
      final service = MeetingShareService();

      final message = service.buildShareMessage(
        meetingUrl: 'https://app-oint.com/m/test-meeting-123',
        groupName: 'Test Group',
        customMessage: 'Join our meeting!',
      );

      expect(message, contains('Join our meeting!'));
      expect(message, contains('Test Group'));
      expect(message, contains('https://app-oint.com/m/test-meeting-123'));
    });

    test('getAvailableShareSources returns correct sources', () {
      final service = MeetingShareService();
      final group = UserGroup(
        id: 'test-group',
        name: 'Test Group',
        createdBy: 'user-1',
        members: ['user-1', 'user-2'],
        admins: ['user-1'],
        createdAt: DateTime.now(),
      );

      final sources = service.getAvailableShareSources(group);

      expect(sources, contains(ShareSource.whatsappGroup));
      expect(sources, contains(ShareSource.telegramGroup));
      expect(sources, contains(ShareSource.email));
      expect(sources, isNot(contains(ShareSource.copyLink)));
    });

    test('ShareSource extension methods work correctly', () {
      expect(ShareSource.whatsappGroup.displayName, equals('WhatsApp Group'));
      expect(ShareSource.telegramGroup.displayName, equals('Telegram Group'));
      expect(ShareSource.email.displayName, equals('Email'));

      expect(ShareSource.whatsappGroup.iconName, equals('whatsapp'));
      expect(ShareSource.telegramGroup.iconName, equals('telegram'));
      expect(ShareSource.email.iconName, equals('email'));

      expect(
          ShareSource.whatsappGroup.shareUrl, equals('https://wa.me/?text='));
      expect(ShareSource.telegramGroup.shareUrl,
          equals('https://t.me/share/url?url='));
      expect(ShareSource.email.shareUrl,
          equals('mailto:?subject=Meeting Invitation&body='));
    });
  });
}


