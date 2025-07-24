import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/l10n/l10n.dart';
import 'package:appoint/services/consent_logging_service.dart';

class PrivacyScreen extends ConsumerWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyPolicy),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.privacyPolicy,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.privacyLastUpdated,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              l10n.privacyIntroductionTitle,
              l10n.privacyIntroductionContent,
            ),
            
            _buildSection(
              context,
              l10n.REDACTED_TOKEN,
              l10n.REDACTED_TOKEN,
            ),
            
            _buildSection(
              context,
              l10n.privacyHowWeUseTitle,
              l10n.privacyHowWeUseContent,
            ),
            
            _buildSection(
              context,
              l10n.privacyInformationSharingTitle,
              l10n.REDACTED_TOKEN,
            ),
            
            _buildSection(
              context,
              l10n.privacyChildrenProtectionTitle,
              l10n.REDACTED_TOKEN,
            ),
            
            _buildSection(
              context,
              l10n.privacyDataSecurityTitle,
              l10n.privacyDataSecurityContent,
            ),
            
            _buildSection(
              context,
              l10n.privacyUserRightsTitle,
              l10n.privacyUserRightsContent,
            ),
            
            _buildSection(
              context,
              l10n.privacyCookiesTitle,
              l10n.privacyCookiesContent,
            ),
            
            _buildSection(
              context,
              l10n.privacyThirdPartyTitle,
              l10n.privacyThirdPartyContent,
            ),
            
            _buildSection(
              context,
              l10n.privacyChangesTitle,
              l10n.privacyChangesContent,
            ),
            
            _buildSection(
              context,
              l10n.privacyContactTitle,
              l10n.privacyContactContent,
            ),
            
            const SizedBox(height: 32),
            
            // Privacy acceptance (for new users)
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _acceptPrivacy(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 48),
                    ),
                    child: Text(l10n.acceptPrivacyPolicy),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.goBack),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Future<void> _acceptPrivacy(BuildContext context) async {
    try {
      await ConsentLoggingService.logPrivacyAcceptance(
        additionalData: {
          'platform': 'mobile',
          'source': 'privacy_screen',
        },
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Privacy policy acceptance logged successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Privacy policy accepted (logging issue: $e)'),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.of(context).pop(true);
      }
    }
  }
}