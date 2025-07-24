import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/l10n/l10n.dart';
import 'package:appoint/services/consent_logging_service.dart';

class TermsScreen extends ConsumerWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.termsOfService),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.termsOfService,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.termsLastUpdated,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              l10n.termsAcceptanceTitle,
              l10n.termsAcceptanceContent,
            ),
            
            _buildSection(
              context,
              l10n.termsDescriptionTitle,
              l10n.termsDescriptionContent,
            ),
            
            _buildSection(
              context,
              l10n.termsUserAccountsTitle,
              l10n.termsUserAccountsContent,
            ),
            
            _buildSection(
              context,
              l10n.termsMinorProtectionTitle,
              l10n.termsMinorProtectionContent,
            ),
            
            _buildSection(
              context,
              l10n.termsProhibitedUsesTitle,
              l10n.termsProhibitedUsesContent,
            ),
            
            _buildSection(
              context,
              l10n.termsContentLicenseTitle,
              l10n.termsContentLicenseContent,
            ),
            
            _buildSection(
              context,
              l10n.termsPrivacyTitle,
              l10n.termsPrivacyContent,
            ),
            
            _buildSection(
              context,
              l10n.termsTerminationTitle,
              l10n.termsTerminationContent,
            ),
            
            _buildSection(
              context,
              l10n.termsChangesTitle,
              l10n.termsChangesContent,
            ),
            
            _buildSection(
              context,
              l10n.termsContactTitle,
              l10n.termsContactContent,
            ),
            
            const SizedBox(height: 32),
            
            // Accept Terms Button (for new users)
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _acceptTerms(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 48),
                    ),
                    child: Text(l10n.acceptTerms),
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

  Future<void> _acceptTerms(BuildContext context) async {
    try {
      await ConsentLoggingService.logTermsAcceptance(
        additionalData: {
          'platform': 'mobile',
          'source': 'terms_screen',
        },
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terms acceptance logged successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terms accepted (logging issue: $e)'),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.of(context).pop(true);
      }
    }
  }
}