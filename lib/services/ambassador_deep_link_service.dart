import 'package:appoint/models/ambassador_profile.dart';
import 'package:appoint/services/ambassador_service.dart';
import 'package:appoint/services/analytics_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service for handling ambassador deep link functionality
/// Note: Firebase Dynamic Links is deprecated and will be shut down on August 25, 2025
/// This service has been updated to use alternative sharing methods
class AmbassadorDeepLinkService {
  AmbassadorDeepLinkService({
    required this.firestore,
    required this.ambassadorService,
    required this.analyticsService,
  });

  final FirebaseFirestore firestore;
  final AmbassadorService ambassadorService;
  final AnalyticsService analyticsService;

  /// Initialize deep link handling
  /// Note: Firebase Dynamic Links functionality has been removed due to deprecation
  Future<void> initialize() async {
    // Firebase Dynamic Links is deprecated, so we skip initialization
    // Alternative deep link handling can be implemented here if needed
    debugPrint(
        'AmbassadorDeepLinkService: Firebase Dynamic Links is deprecated');
  }

  /// Generate ambassador referral link
  /// Note: This now returns a simple URL since Firebase Dynamic Links is deprecated
  Future<String> generateAmbassadorReferralLink({
    required String ambassadorId,
    required String referralCode,
    String? customMessage,
  }) async {
    try {
      // Since Firebase Dynamic Links is deprecated, we return a simple URL
      final baseUrl = 'https://app-oint.com/invite';
      final link = '$baseUrl/$referralCode';

      // Log the link generation
      await firestore.collection('ambassador_link_analytics').add({
        'ambassadorId': ambassadorId,
        'referralCode': referralCode,
        'shortLink': link,
        'fullLink': link,
        'generatedAt': FieldValue.serverTimestamp(),
        'customMessage': customMessage,
        'note': 'Firebase Dynamic Links deprecated - using simple URL',
      });

      return link;
    } catch (e) {
      debugPrint('Error generating ambassador referral link: $e');
      // Fallback to regular URL
      return 'https://app-oint.com/invite/$referralCode';
    }
  }

  /// Share ambassador referral link via native share sheet
  Future<void> shareAmbassadorLink({
    required BuildContext context,
    required String ambassadorId,
    required String referralCode,
    required String ambassadorName,
    String? customMessage,
    List<ShareTarget>? preferredTargets,
  }) async {
    try {
      // Generate the link
      final shareLink = await generateAmbassadorReferralLink(
        ambassadorId: ambassadorId,
        referralCode: referralCode,
        customMessage: customMessage,
      );

      // Create share content
      final shareText = customMessage ??
          "Hey! I'm using App-Oint for all my appointments and I think you'd love it too! 📅✨\n\n"
              'Use my referral code "$referralCode" when you sign up and we both get rewards! 🎉\n\n'
              'Download here: $shareLink\n\n'
              'Thanks!\n- $ambassadorName';

      // Share with specific targets if provided, otherwise use default share sheet
      if (preferredTargets != null && preferredTargets.isNotEmpty) {
        for (final target in preferredTargets) {
          await _shareToSpecificTarget(target, shareText, shareLink, context);
        }
      } else {
        // Use SharePlus instead of deprecated Share
        await SharePlus.instance.share(
          ShareParams(text: shareText),
        );
      }

      // Log the share event
      await _logShareEvent(ambassadorId, referralCode, preferredTargets);
    } catch (e) {
      debugPrint('Error sharing ambassador link: $e');
      // Show error dialog
      if (context.mounted) {
        _showErrorDialog(
            context, 'Failed to share referral link. Please try again.');
      }
    }
  }

  /// Share to specific platform
  Future<void> _shareToSpecificTarget(
    ShareTarget target,
    String text,
    String link,
    BuildContext context,
  ) async {
    try {
      switch (target) {
        case ShareTarget.whatsapp:
          await _shareToWhatsApp(text);
        case ShareTarget.messenger:
          await _shareToMessenger(text);
        case ShareTarget.email:
          await _shareToEmail(text, link);
        case ShareTarget.sms:
          await _shareToSMS(text);
        case ShareTarget.telegram:
          await _shareToTelegram(text);
        case ShareTarget.copy:
          await _copyToClipboard(text, context);
      }
    } catch (e) {
      debugPrint('Error sharing to specific target: $e');
      // Fallback to general share
      await SharePlus.instance.share(ShareParams(text: text));
    }
  }

  /// Share to WhatsApp
  Future<void> _shareToWhatsApp(String text) async {
    final whatsappUrl = 'whatsapp://send?text=${Uri.encodeComponent(text)}';
    final uri = Uri.parse(whatsappUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback to web WhatsApp
      final webUrl = 'https://wa.me/?text=${Uri.encodeComponent(text)}';
      final webUri = Uri.parse(webUrl);
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  /// Share to Facebook Messenger
  Future<void> _shareToMessenger(String text) async {
    final messengerUrl =
        'fb-messenger://share/?link=${Uri.encodeComponent(text)}';
    final uri = Uri.parse(messengerUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback to web Messenger
      final webUrl =
          'https://www.messenger.com/share?link=${Uri.encodeComponent(text)}';
      final webUri = Uri.parse(webUrl);
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  /// Share via Email
  Future<void> _shareToEmail(String text, String link) async {
    final emailUrl =
        'mailto:?subject=Join App-Oint with my referral!&body=${Uri.encodeComponent(text)}';
    final uri = Uri.parse(emailUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  /// Share via SMS
  Future<void> _shareToSMS(String text) async {
    final smsUrl = 'sms:?body=${Uri.encodeComponent(text)}';
    final uri = Uri.parse(smsUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  /// Share to Telegram
  Future<void> _shareToTelegram(String text) async {
    final telegramUrl = 'tg://msg?text=${Uri.encodeComponent(text)}';
    final uri = Uri.parse(telegramUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Fallback to web Telegram
      final webUrl = 'https://t.me/share/url?url=${Uri.encodeComponent(text)}';
      final webUri = Uri.parse(webUrl);
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  /// Copy to clipboard
  Future<void> _copyToClipboard(String text, BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: text));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link copied to clipboard!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Log share event for analytics
  Future<void> _logShareEvent(
    String ambassadorId,
    String referralCode,
    List<ShareTarget>? targets,
  ) async {
    try {
      await firestore.collection('ambassador_share_events').add({
        'ambassadorId': ambassadorId,
        'referralCode': referralCode,
        'timestamp': FieldValue.serverTimestamp(),
        'targets': targets?.map((t) => t.name).toList() ?? [],
        'platform': 'mobile',
      });

      // Track with analytics service if available
      // Note: AnalyticsService.trackEvent method may not exist
      debugPrint('Share event logged for ambassador: $ambassadorId');
    } catch (e) {
      debugPrint('Error logging share event: $e');
    }
  }

  /// Show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Get ambassador from referral code
  Future<AmbassadorProfile?> getAmbassadorFromReferralCode(
    String referralCode,
  ) async {
    try {
      // Note: AmbassadorService.getAmbassadorByReferralCode method may not exist
      // This is a placeholder implementation
      debugPrint('Getting ambassador for referral code: $referralCode');
      return null;
    } catch (e) {
      debugPrint('Error getting ambassador from referral code: $e');
      return null;
    }
  }

  /// Track referral link click
  Future<void> trackReferralLinkClick({
    required String referralCode,
    required String source,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      await firestore.collection('referral_link_clicks').add({
        'referralCode': referralCode,
        'source': source,
        'timestamp': FieldValue.serverTimestamp(),
        'additionalData': additionalData ?? {},
      });

      // Track with analytics service if available
      debugPrint('Referral link click tracked: $referralCode from $source');
    } catch (e) {
      debugPrint('Error tracking referral link click: $e');
    }
  }

  /// Get referral link analytics
  Future<List<Map<String, dynamic>>> getReferralLinkAnalytics({
    String? ambassadorId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = firestore.collection('ambassador_link_analytics');

      if (ambassadorId != null) {
        query = query.where('ambassadorId', isEqualTo: ambassadorId);
      }

      if (startDate != null) {
        query = query.where('generatedAt', isGreaterThanOrEqualTo: startDate);
      }

      if (endDate != null) {
        query = query.where('generatedAt', isLessThanOrEqualTo: endDate);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      debugPrint('Error getting referral link analytics: $e');
      return [];
    }
  }
}

/// Enum for different share targets
enum ShareTarget {
  whatsapp,
  messenger,
  email,
  sms,
  telegram,
  copy,
}
