// Platform-agnostic imports
import 'package:flutter/services.dart';
import '../../models/group_invite_link.dart';
import '../analytics/analytics_service.dart';
import 'package:flutter/foundation.dart';

// Conditional web imports
import 'share_service_web.dart'
    if (dart.library.io) 'share_service_mobile.dart';

class ShareService {
  /// Share invite link with optional source tracking
  static Future<void> shareInviteLink(GroupInviteLink link,
      {String? src}) async {
    if (kIsWeb) {
      await ShareServiceWeb.shareInviteLink(link, src: src);
    } else {
      await _mobileShare(link, src: src);
    }
  }

  /// Mobile-specific sharing implementation
  static Future<void> _mobileShare(GroupInviteLink link, {String? src}) async {
    final shareUrl = link.withSource(src);

    try {
      // Copy to clipboard for mobile
      await Clipboard.setData(ClipboardData(text: shareUrl));
      _showToast(
          "Link copied. Paste into any group: WhatsApp, Telegram, iMessage, Messenger, Instagram DMs, Facebook Groups, Discord, Signal.");

      // Track analytics
      AnalyticsService.track("share_invite_clicked", {
        "src": src ?? "unknown",
        "meetingId": link.meetingId,
        "platform": "mobile",
      });
    } catch (e) {
      _showToast("Failed to copy link");
    }
  }

  /// Show toast message
  static void _showToast(String message) {
    // TODO: Implement proper toast system
    print('TOAST: $message');
  }

  /// Generate platform-specific URL
  static String generatePlatformUrl(GroupInviteLink link, String platform) {
    final baseUrl = link.withSource(platform);

    switch (platform.toLowerCase()) {
      case 'whatsapp':
        return 'https://wa.me/?text=${Uri.encodeComponent("Join my meeting: $baseUrl")}';
      case 'telegram':
        return 'https://t.me/share/url?url=${Uri.encodeComponent(baseUrl)}&text=${Uri.encodeComponent("Join my meeting")}';
      case 'imessage':
        return 'sms:&body=${Uri.encodeComponent("Join my meeting: $baseUrl")}';
      case 'messenger':
        return 'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(baseUrl)}';
      default:
        return baseUrl;
    }
  }

  /// Get platform display name
  static String getPlatformDisplayName(String platform) {
    switch (platform.toLowerCase()) {
      case 'whatsapp':
        return 'WhatsApp';
      case 'telegram':
        return 'Telegram';
      case 'imessage':
        return 'iMessage';
      case 'messenger':
        return 'Messenger';
      case 'instagram':
        return 'Instagram';
      case 'facebook':
        return 'Facebook';
      case 'discord':
        return 'Discord';
      case 'signal':
        return 'Signal';
      default:
        return platform;
    }
  }

  /// Get platform icon
  static String getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'whatsapp':
        return '📱';
      case 'telegram':
        return '📬';
      case 'imessage':
        return '💬';
      case 'messenger':
        return '💙';
      case 'instagram':
        return '📷';
      case 'facebook':
        return '📘';
      case 'discord':
        return '🎮';
      case 'signal':
        return '🔒';
      default:
        return '📤';
    }
  }

  /// Get supported platforms
  static List<String> getSupportedPlatforms() {
    return [
      'whatsapp',
      'telegram',
      'imessage',
      'messenger',
      'instagram',
      'facebook',
      'discord',
      'signal',
    ];
  }
}
