// Web-only share service
import 'dart:html' as html;
import '../../models/group_invite_link.dart';
import '../analytics/analytics_service.dart';

class ShareServiceWeb {
  /// Share invite link with optional source tracking
  static Future<void> shareInviteLink(GroupInviteLink link,
      {String? src}) async {
    final shareUrl = link.withSource(src);

    try {
      // Try web share if supported
      if (await _supportsWebShare()) {
        await _webShare(shareUrl);
      } else {
        // Fallback to clipboard
        await _copyToClipboard(shareUrl);
        _showToast(
            "Link copied. Paste into any group: WhatsApp, Telegram, iMessage, Messenger, Instagram DMs, Facebook Groups, Discord, Signal.");
      }

      // Track analytics
      AnalyticsService.track("share_invite_clicked", {
        "src": src ?? "unknown",
        "meetingId": link.meetingId,
        "platform": _getPlatform(),
      });
    } catch (e) {
      // Fallback to clipboard on any error
      await _copyToClipboard(shareUrl);
      _showToast("Link copied to clipboard");
    }
  }

  /// Check if Web Share API is supported
  static Future<bool> _supportsWebShare() async {
    try {
      final navigator = html.window.navigator;
      return navigator.share != null;
    } catch (e) {
      return false;
    }
  }

  /// Use Web Share API
  static Future<void> _webShare(String url) async {
    final shareData = {
      'title': 'Join my meeting on App-Oint',
      'text': 'I\'d like you to join my meeting. Click the link to join!',
      'url': url,
    };

    await html.window.navigator.share(shareData);
  }

  /// Copy to clipboard
  static Future<void> _copyToClipboard(String text) async {
    try {
      // Try web clipboard API first
      await html.window.navigator.clipboard?.writeText(text);
    } catch (e) {
      // Fallback to execCommand
      final textArea = html.TextAreaElement()
        ..value = text
        ..style.position = 'fixed'
        ..style.left = '-999999px'
        ..style.top = '-999999px';

      html.document.body?.append(textArea);
      textArea.select();
      html.document.execCommand('copy');
      textArea.remove();
    }
  }

  /// Show toast message
  static void _showToast(String message) {
    // TODO: Implement proper toast system
    print('TOAST: $message');
  }

  /// Get current platform
  static String _getPlatform() {
    try {
      final userAgent = html.window.navigator.userAgent.toLowerCase();
      if (userAgent.contains('android')) return 'android';
      if (userAgent.contains('iphone') || userAgent.contains('ipad')) {
        return 'ios';
      }
      return 'web';
    } catch (e) {
      return 'unknown';
    }
  }
}
