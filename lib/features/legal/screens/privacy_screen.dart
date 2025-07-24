import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/services/consent_logging_service.dart';

class PrivacyScreen extends ConsumerWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: January 2024',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              '1. Introduction',
              'APP-OINT respects your privacy and is committed to protecting your personal data. This privacy policy explains how we look after your personal data when you visit our platform and tells you about your privacy rights and how the law protects you.',
            ),
            
            _buildSection(
              context,
              '2. Information We Collect',
              'We may collect, use, store and transfer different kinds of personal data about you including: identity data (first name, last name, username), contact data (email address, telephone numbers), technical data (internet protocol address, browser type and version, time zone setting), profile data (your username and password, your interests, preferences, feedback), usage data (information about how you use our platform), and marketing data (your preferences in receiving marketing from us).',
            ),
            
            _buildSection(
              context,
              '3. How We Use Your Information',
              'We use your personal data to: register you as a new customer, process and deliver your service including managing payments and communicating with you about your service, manage our relationship with you (including notifying you about changes to our terms or privacy policy), enable you to partake in a prize draw, competition or complete a survey, administer and protect our business and this platform (including troubleshooting, data analysis, testing, system maintenance, support, reporting and hosting of data), deliver relevant platform content and advertisements to you and measure or understand the effectiveness of the advertising we serve to you.',
            ),
            
            _buildSection(
              context,
              '4. Information Sharing',
              'We may share your personal information in the following situations: with service providers who perform services on our behalf, for business transfers in connection with any merger, sale, or transfer of all or a portion of our business, for legal requirements to comply with applicable law, legal process, or governmental request, to protect rights and safety when we believe in good faith that disclosure is necessary to protect our rights, protect your safety or the safety of others, investigate fraud, or respond to a government request.',
            ),
            
            _buildSection(
              context,
              '5. Children\'s Privacy (COPPA Compliance)',
              'Our service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13. If you are a parent or guardian and you are aware that your child has provided us with personal data, please contact us. If we become aware that we have collected personal data from children without verification of parental consent, we take steps to remove that information from our servers.',
            ),
            
            _buildSection(
              context,
              '6. Data Security',
              'We have put in place appropriate security measures to prevent your personal data from being accidentally lost, used or accessed in an unauthorized way, altered or disclosed. We limit access to your personal data to those employees, agents, contractors and other third parties who have a business need to know.',
            ),
            
            _buildSection(
              context,
              '7. Your Data Protection Rights (GDPR)',
              'Under certain circumstances, you have rights under data protection laws in relation to your personal data: the right to request access to your personal data, the right to request correction of your personal data, the right to request erasure of your personal data, the right to object to processing of your personal data, the right to request restriction of processing your personal data, the right to request transfer of your personal data, and the right to withdraw consent at any time where we are relying on consent to process your personal data.',
            ),
            
            _buildSection(
              context,
              '8. Cookies',
              'We use cookies and similar tracking technologies to track the activity on our service and hold certain information. Cookies are files with small amount of data which may include an anonymous unique identifier. You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent.',
            ),
            
            _buildSection(
              context,
              '9. Third-Party Services',
              'Our service may contain links to other sites that are not operated by us. If you click on a third party link, you will be directed to that third party\'s site. We strongly advise you to review the privacy policy of every site you visit.',
            ),
            
            _buildSection(
              context,
              '10. Changes to This Privacy Policy',
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the \'last updated\' date.',
            ),
            
            _buildSection(
              context,
              '11. Contact Us',
              'If you have any questions about this Privacy Policy, please contact us at privacy@app-oint.com.',
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
                    child: const Text('Accept Privacy Policy'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Go Back'),
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