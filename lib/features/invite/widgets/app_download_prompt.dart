import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AppDownloadPrompt extends StatelessWidget {
  const AppDownloadPrompt({
    super.key,
    required this.meetingTitle,
    required this.appointmentId,
    this.shareId,
  });

  final String meetingTitle;
  final String appointmentId;
  final String? shareId;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Invitation Accepted!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'You\'ve accepted the invitation to "$meetingTitle". To complete your RSVP and join the meeting, please download the App-Oint app.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildDownloadButtons(),
            const SizedBox(height: 24),
            _buildQRCode(),
            const SizedBox(height: 16),
            Text(
              'After installing, the app will automatically open and complete your RSVP.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadButtons() {
    return Column(
      children: [
        _buildDownloadButton(
          'Download for iOS',
          'https://apps.apple.com/app/app-oint/id123456789',
          Icons.apple,
          Colors.black,
        ),
        const SizedBox(height: 12),
        _buildDownloadButton(
          'Download for Android',
          'https://play.google.com/store/apps/details?id=com.appoint.app',
          Icons.android,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildDownloadButton(String text, String url, IconData icon, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _openStore(url),
        icon: Icon(icon, color: Colors.white),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildQRCode() {
    // Generate deep link for QR code
    final deepLink = _generateDeepLink();
    
    return Column(
      children: [
        Text(
          'Or scan this QR code:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: QrImageView(
            data: deepLink,
            version: QrVersions.auto,
            size: 120,
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  String _generateDeepLink() {
    final baseUrl = 'https://app-oint.com/invite/$appointmentId';
    final params = <String, String>{
      'creatorId': 'guest',
      'source': 'whatsapp_group',
      'shareId': shareId ?? '',
      'group_share': '1',
      'guest_accepted': 'true',
    };

    final queryString = params.entries
        .where((e) => e.value.isNotEmpty)
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$baseUrl?$queryString';
  }

  Future<void> _openStore(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
} 