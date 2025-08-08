import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/user_group.dart';

enum ShareSource {
  whatsappGroup,
  telegramGroup,
  signalGroup,
  discord,
  messenger,
  email,
  sms,
  copyLink,
}

extension ShareSourceExtension on ShareSource {
  String get displayName {
    switch (this) {
      case ShareSource.whatsappGroup:
        return 'WhatsApp Group';
      case ShareSource.telegramGroup:
        return 'Telegram Group';
      case ShareSource.signalGroup:
        return 'Signal Group';
      case ShareSource.discord:
        return 'Discord';
      case ShareSource.messenger:
        return 'Messenger';
      case ShareSource.email:
        return 'Email';
      case ShareSource.sms:
        return 'SMS';
      case ShareSource.copyLink:
        return 'Copy Link';
    }
  }

  String get iconName {
    switch (this) {
      case ShareSource.whatsappGroup:
        return 'whatsapp';
      case ShareSource.telegramGroup:
        return 'telegram';
      case ShareSource.signalGroup:
        return 'signal';
      case ShareSource.discord:
        return 'discord';
      case ShareSource.messenger:
        return 'messenger';
      case ShareSource.email:
        return 'email';
      case ShareSource.sms:
        return 'sms';
      case ShareSource.copyLink:
        return 'link';
    }
  }

  String get shareUrl {
    switch (this) {
      case ShareSource.whatsappGroup:
        return 'https://wa.me/?text=';
      case ShareSource.telegramGroup:
        return 'https://t.me/share/url?url=';
      case ShareSource.signalGroup:
        return 'https://signal.me/#p/';
      case ShareSource.discord:
        return 'https://discord.com/channels/';
      case ShareSource.messenger:
        return 'https://www.facebook.com/sharer/sharer.php?u=';
      case ShareSource.email:
        return 'mailto:?subject=Meeting Invitation&body=';
      case ShareSource.sms:
        return 'sms:?body=';
      case ShareSource.copyLink:
        return '';
    }
  }
}

class MeetingShareService {
  static const String _baseUrl = 'https://app-oint.com';

  /// Builds a smart share URL with UTM tracking and group context
  String buildGroupShareUrl({
    required String meetingId,
    required String groupId,
    required ShareSource source,
    String? customMessage,
  }) {
    final encodedMessage = customMessage != null
        ? Uri.encodeComponent(customMessage)
        : Uri.encodeComponent('Join our meeting!');

    final params = {
      'g': groupId,
      'src': source.name,
      'utm_medium': 'group_share',
      'utm_source': source.name,
      'utm_campaign': 'meeting_invite',
      'ref': 'group_share',
    };

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$_baseUrl/m/$meetingId?$queryString';
  }

  /// Builds a share message with the meeting URL
  String buildShareMessage({
    required String meetingUrl,
    required String groupName,
    String? customMessage,
  }) {
    final defaultMessage = 'Join our meeting in $groupName!';
    final message = customMessage ?? defaultMessage;

    return '$message\n\n$meetingUrl';
  }

  /// Shares to a specific platform
  Future<bool> shareToPlatform({
    required ShareSource source,
    required String meetingId,
    required String groupId,
    required String groupName,
    String? customMessage,
  }) async {
    try {
      final shareUrl = buildGroupShareUrl(
        meetingId: meetingId,
        groupId: groupId,
        source: source,
        customMessage: customMessage,
      );

      final message = buildShareMessage(
        meetingUrl: shareUrl,
        groupName: groupName,
        customMessage: customMessage,
      );

      // Log share event
      await _logShareEvent(
        meetingId: meetingId,
        groupId: groupId,
        source: source,
        shareUrl: shareUrl,
      );

      // Handle different share methods
      switch (source) {
        case ShareSource.copyLink:
          // Copy to clipboard
          // await Clipboard.setData(ClipboardData(text: shareUrl));
          return true;

        case ShareSource.email:
          final emailUrl = '${source.shareUrl}${Uri.encodeComponent(message)}';
          return await _launchUrl(emailUrl);

        case ShareSource.sms:
          final smsUrl = '${source.shareUrl}${Uri.encodeComponent(message)}';
          return await _launchUrl(smsUrl);

        default:
          // Social platforms
          final platformUrl =
              '${source.shareUrl}${Uri.encodeComponent(message)}';
          return await _launchUrl(platformUrl);
      }
    } catch (e) {
      print('Error sharing meeting: $e');
      return false;
    }
  }

  /// Share to multiple platforms
  Future<Map<ShareSource, bool>> shareToMultiplePlatforms({
    required List<ShareSource> sources,
    required String meetingId,
    required String groupId,
    required String groupName,
    String? customMessage,
  }) async {
    final results = <ShareSource, bool>{};

    for (final source in sources) {
      final success = await shareToPlatform(
        source: source,
        meetingId: meetingId,
        groupId: groupId,
        groupName: groupName,
        customMessage: customMessage,
      );
      results[source] = success;
    }

    return results;
  }

  /// Get available share sources for a group
  List<ShareSource> getAvailableShareSources(UserGroup group) {
    // For now, return all sources
    // In the future, this could be based on group settings or user preferences
    return ShareSource.values
        .where((source) => source != ShareSource.copyLink)
        .toList();
  }

  /// Log share event for analytics
  Future<void> _logShareEvent({
    required String meetingId,
    required String groupId,
    required ShareSource source,
    required String shareUrl,
  }) async {
    // This would typically log to Firebase Analytics or a custom analytics service
    final event = {
      'event': 'share_link_created',
      'meetingId': meetingId,
      'groupId': groupId,
      'source': source.name,
      'shareUrl': shareUrl,
      'timestamp': DateTime.now().toIso8601String(),
    };

    print('Share event: $event');
    // await FirebaseAnalytics.instance.logEvent(name: 'share_link_created', parameters: event);
  }

  /// Launch URL with error handling
  Future<bool> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Error launching URL: $e');
      return false;
    }
  }
}

// Riverpod provider
final meetingShareServiceProvider = Provider<MeetingShareService>((ref) {
  return MeetingShareService();
});


