import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Note: firebase_dynamic_links package not added to pubspec.yaml yet
// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:appoint/models/ambassador_profile.dart';

// Temporary stub classes until firebase_dynamic_links is added
class FirebaseDynamicLinks {
  static FirebaseDynamicLinks instance = FirebaseDynamicLinks();
  Future<PendingDynamicLinkData?> getInitialLink() async => null;
  Stream<PendingDynamicLinkData> get onLink => Stream.empty();
  Future<ShortDynamicLink> buildShortLink(dynamic params) async => ShortDynamicLink('');
}

class PendingDynamicLinkData {
  final Uri link;
  PendingDynamicLinkData(this.link);
}

class ShortDynamicLink {
  final String shortUrl;
  ShortDynamicLink(this.shortUrl);
}

enum ShortDynamicLinkPathLength { short }

/// Service for handling Ambassador deep links and mobile sharing
class AmbassadorDeepLinkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _domainPrefix = 'https://appoint.page.link';
  static const String _androidPackageName = 'com.appoint.app';
  static const String _iosAppStoreId = '123456789'; // Replace with actual App Store ID
  static const String _iosBundleId = 'com.appoint.app';

  /// Initialize deep link handling
  Future<void> initialize() async {
    // Handle deep links when app is opened from cold start
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    
    if (initialLink != null) {
      await _handleDynamicLink(initialLink);
    }

    // Handle deep links when app is already running
    FirebaseDynamicLinks.instance.onLink.listen(
      _handleDynamicLink,
      onError: (error) {
        debugPrint('Dynamic link error: $error');
      },
    );
  }

  /// Generate a dynamic link for ambassador referral
  Future<String> generateAmbassadorReferralLink({
    required String ambassadorId,
    required String referralCode,
    String? customMessage,
  }) async {
    try {
      final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: _domainPrefix,
        link: Uri.parse('https://app-oint.com/invite/$referralCode'),
        androidParameters: const AndroidParameters(
          packageName: _androidPackageName,
          minimumVersion: 1,
        ),
        iosParameters: const IOSParameters(
          bundleId: _iosBundleId,
          minimumVersion: '1.0.0',
          appStoreId: _iosAppStoreId,
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Join App-Oint with my referral!',
          description: customMessage ?? 
              'I\'m inviting you to join App-Oint, the best appointment booking app. Use my referral code to get started!',
          imageUrl: Uri.parse('https://app-oint.com/assets/invite-banner.png'),
        ),
        dynamicLinkParametersOptions: const DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
        ),
      );

      final ShortDynamicLink shortLink = 
          await FirebaseDynamicLinks.instance.buildShortLink(parameters);

      // Log the link generation
      await _firestore.collection('ambassador_link_analytics').add({
        'ambassadorId': ambassadorId,
        'referralCode': referralCode,
        'shortLink': shortLink.shortUrl.toString(),
        'fullLink': parameters.link.toString(),
        'generatedAt': FieldValue.serverTimestamp(),
        'customMessage': customMessage,
      });

      return shortLink.shortUrl.toString();
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
      // Generate the dynamic link
      final shareLink = await generateAmbassadorReferralLink(
        ambassadorId: ambassadorId,
        referralCode: referralCode,
        customMessage: customMessage,
      );

      // Create share content
      final shareText = customMessage ?? 
          'Hey! I\'m using App-Oint for all my appointments and I think you\'d love it too! 📅✨\n\n'
          'Use my referral code "$referralCode" when you sign up and we both get rewards! 🎉\n\n'
          'Download here: $shareLink\n\n'
          'Thanks!\n- $ambassadorName';

      // Share with specific targets if provided, otherwise use default share sheet
      if (preferredTargets != null && preferredTargets.isNotEmpty) {
        for (final target in preferredTargets) {
          await _shareToSpecificTarget(target, shareText, shareLink, context);
        }
      } else {
        // Use general share sheet
        final box = context.findRenderObject() as RenderBox?;
        final sharePositionOrigin = box!.localToGlobal(Offset.zero) & box.size;

        await Share.share(
          shareText,
          subject: 'Join App-Oint with my referral!',
          sharePositionOrigin: sharePositionOrigin,
        );
      }

      // Log the share event
      await _logShareEvent(ambassadorId, referralCode, preferredTargets);

    } catch (e) {
      debugPrint('Error sharing ambassador link: $e');
      // Show error dialog
      if (context.mounted) {
        _showErrorDialog(context, 'Failed to share referral link. Please try again.');
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
          break;
        case ShareTarget.messenger:
          await _shareToMessenger(text);
          break;
        case ShareTarget.email:
          await _shareToEmail(text, link);
          break;
        case ShareTarget.sms:
          await _shareToSMS(text);
          break;
        case ShareTarget.telegram:
          await _shareToTelegram(text);
          break;
        case ShareTarget.twitter:
          await _shareToTwitter(text);
          break;
        case ShareTarget.linkedin:
          await _shareToLinkedIn(text);
          break;
        case ShareTarget.copy:
          await _copyToClipboard(text, context);
          break;
      }
    } catch (e) {
      debugPrint('Error sharing to ${target.name}: $e');
      // Fallback to general share
      await Share.share(text);
    }
  }

  /// Share to WhatsApp
  Future<void> _shareToWhatsApp(String text) async {
    final encodedText = Uri.encodeComponent(text);
    final whatsappUrl = 'https://wa.me/?text=$encodedText';
    
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
    } else {
      throw Exception('WhatsApp not available');
    }
  }

  /// Share to Messenger
  Future<void> _shareToMessenger(String text) async {
    final encodedText = Uri.encodeComponent(text);
    final messengerUrl = 'fb-messenger://share/?text=$encodedText';
    
    if (await canLaunchUrl(Uri.parse(messengerUrl))) {
      await launchUrl(Uri.parse(messengerUrl), mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Messenger not available');
    }
  }

  /// Share via Email
  Future<void> _shareToEmail(String text, String link) async {
    final subject = Uri.encodeComponent('Join App-Oint with my referral!');
    final body = Uri.encodeComponent(text);
    final emailUrl = 'mailto:?subject=$subject&body=$body';
    
    if (await canLaunchUrl(Uri.parse(emailUrl))) {
      await launchUrl(Uri.parse(emailUrl));
    } else {
      throw Exception('Email not available');
    }
  }

  /// Share via SMS
  Future<void> _shareToSMS(String text) async {
    final body = Uri.encodeComponent(text);
    final smsUrl = Platform.isAndroid ? 'sms:?body=$body' : 'sms:&body=$body';
    
    if (await canLaunchUrl(Uri.parse(smsUrl))) {
      await launchUrl(Uri.parse(smsUrl));
    } else {
      throw Exception('SMS not available');
    }
  }

  /// Share to Telegram
  Future<void> _shareToTelegram(String text) async {
    final encodedText = Uri.encodeComponent(text);
    final telegramUrl = 'tg://msg?text=$encodedText';
    
    if (await canLaunchUrl(Uri.parse(telegramUrl))) {
      await launchUrl(Uri.parse(telegramUrl), mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Telegram not available');
    }
  }

  /// Share to Twitter
  Future<void> _shareToTwitter(String text) async {
    final encodedText = Uri.encodeComponent(text);
    final twitterUrl = 'https://twitter.com/intent/tweet?text=$encodedText';
    
    if (await canLaunchUrl(Uri.parse(twitterUrl))) {
      await launchUrl(Uri.parse(twitterUrl), mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Twitter not available');
    }
  }

  /// Share to LinkedIn
  Future<void> _shareToLinkedIn(String text) async {
    final encodedText = Uri.encodeComponent(text);
    final linkedinUrl = 'https://www.linkedin.com/sharing/share-offsite/?url=$encodedText';
    
    if (await canLaunchUrl(Uri.parse(linkedinUrl))) {
      await launchUrl(Uri.parse(linkedinUrl), mode: LaunchMode.externalApplication);
    } else {
      throw Exception('LinkedIn not available');
    }
  }

  /// Copy to clipboard
  Future<void> _copyToClipboard(String text, BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Referral link copied to clipboard!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  /// Handle incoming dynamic links
  Future<void> _handleDynamicLink(PendingDynamicLinkData dynamicLinkData) async {
    try {
      final Uri link = dynamicLinkData.link;
      debugPrint('Received dynamic link: $link');

      // Extract referral code from the link
      final pathSegments = link.pathSegments;
      if (pathSegments.length >= 2 && pathSegments[0] == 'invite') {
        final referralCode = pathSegments[1];
        await _processReferralCode(referralCode);
      }
    } catch (e) {
      debugPrint('Error handling dynamic link: $e');
    }
  }

  /// Process referral code from deep link
  Future<void> _processReferralCode(String referralCode) async {
    try {
      // Find the ambassador by referral code
      final ambassadorQuery = await _firestore
          .collection('ambassador_share_codes')
          .where('shareCode', isEqualTo: referralCode)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (ambassadorQuery.docs.isNotEmpty) {
        final ambassadorData = ambassadorQuery.docs.first.data();
        final ambassadorId = ambassadorData['ambassadorId'] as String;

        // Store referral in app preferences or user profile
        await _storeReferralCode(referralCode, ambassadorId);

        // Track link click
        await _trackLinkClick(referralCode, ambassadorId);

        debugPrint('Referral code processed: $referralCode for ambassador: $ambassadorId');
      } else {
        debugPrint('Invalid or expired referral code: $referralCode');
      }
    } catch (e) {
      debugPrint('Error processing referral code: $e');
    }
  }

  /// Store referral code for later use during registration
  Future<void> _storeReferralCode(String referralCode, String ambassadorId) async {
    // Store in shared preferences or secure storage
    // This will be used when the user actually registers
    await _firestore.collection('pending_referrals').add({
      'referralCode': referralCode,
      'ambassadorId': ambassadorId,
      'clickedAt': FieldValue.serverTimestamp(),
      'deviceId': await _getDeviceId(),
      'isProcessed': false,
    });
  }

  /// Track link click for analytics
  Future<void> _trackLinkClick(String referralCode, String ambassadorId) async {
    await _firestore.collection('ambassador_link_clicks').add({
      'referralCode': referralCode,
      'ambassadorId': ambassadorId,
      'clickedAt': FieldValue.serverTimestamp(),
      'deviceId': await _getDeviceId(),
      'platform': Platform.isAndroid ? 'android' : 'ios',
    });
  }

  /// Log share event for analytics
  Future<void> _logShareEvent(
    String ambassadorId, 
    String referralCode, 
    List<ShareTarget>? targets,
  ) async {
    await _firestore.collection('ambassador_share_events').add({
      'ambassadorId': ambassadorId,
      'referralCode': referralCode,
      'targets': targets?.map((t) => t.name).toList() ?? ['general'],
      'sharedAt': FieldValue.serverTimestamp(),
      'platform': Platform.isAndroid ? 'android' : 'ios',
    });
  }

  /// Get device ID for tracking
  Future<String> _getDeviceId() async {
    // In production, use a proper device ID service
    return 'device_${DateTime.now().millisecondsSinceEpoch}';
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

  /// Generate QR code data for referral link
  String generateQRCodeData({
    required String referralCode,
    required String ambassadorId,
  }) {
    return 'https://app-oint.com/invite/$referralCode';
  }

  /// Get available share targets based on platform and installed apps
  Future<List<ShareTarget>> getAvailableShareTargets() async {
    final List<ShareTarget> availableTargets = [
      ShareTarget.copy,
      ShareTarget.email,
      ShareTarget.sms,
    ];

    // Check for specific apps (simplified)
    try {
      if (await canLaunchUrl(Uri.parse('whatsapp://send'))) {
        availableTargets.add(ShareTarget.whatsapp);
      }
      if (await canLaunchUrl(Uri.parse('fb-messenger://share'))) {
        availableTargets.add(ShareTarget.messenger);
      }
      if (await canLaunchUrl(Uri.parse('tg://msg'))) {
        availableTargets.add(ShareTarget.telegram);
      }
      
      // Always add web-based sharing options
      availableTargets.addAll([
        ShareTarget.twitter,
        ShareTarget.linkedin,
      ]);
    } catch (e) {
      debugPrint('Error checking available share targets: $e');
    }

    return availableTargets;
  }
}

/// Share target options
enum ShareTarget {
  whatsapp,
  messenger,
  email,
  sms,
  telegram,
  twitter,
  linkedin,
  copy,
}

extension ShareTargetExtension on ShareTarget {
  String get displayName {
    switch (this) {
      case ShareTarget.whatsapp:
        return 'WhatsApp';
      case ShareTarget.messenger:
        return 'Messenger';
      case ShareTarget.email:
        return 'Email';
      case ShareTarget.sms:
        return 'SMS';
      case ShareTarget.telegram:
        return 'Telegram';
      case ShareTarget.twitter:
        return 'Twitter';
      case ShareTarget.linkedin:
        return 'LinkedIn';
      case ShareTarget.copy:
        return 'Copy Link';
    }
  }

  IconData get icon {
    switch (this) {
      case ShareTarget.whatsapp:
        return Icons.chat;
      case ShareTarget.messenger:
        return Icons.message;
      case ShareTarget.email:
        return Icons.email;
      case ShareTarget.sms:
        return Icons.sms;
      case ShareTarget.telegram:
        return Icons.send;
      case ShareTarget.twitter:
        return Icons.alternate_email;
      case ShareTarget.linkedin:
        return Icons.business;
      case ShareTarget.copy:
        return Icons.copy;
    }
  }

  Color get color {
    switch (this) {
      case ShareTarget.whatsapp:
        return const Color(0xFF25D366);
      case ShareTarget.messenger:
        return const Color(0xFF006AFF);
      case ShareTarget.email:
        return const Color(0xFF34495E);
      case ShareTarget.sms:
        return const Color(0xFF2ECC71);
      case ShareTarget.telegram:
        return const Color(0xFF0088CC);
      case ShareTarget.twitter:
        return const Color(0xFF1DA1F2);
      case ShareTarget.linkedin:
        return const Color(0xFF0077B5);
      case ShareTarget.copy:
        return const Color(0xFF95A5A6);
    }
  }
}