import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/l10n/l10n.dart';
import 'package:appoint/services/consent_logging_service.dart';

class ConsentCheckbox extends ConsumerStatefulWidget {
  const ConsentCheckbox({
    super.key,
    required this.onConsentChanged,
    this.initialValue = false,
    this.isRequired = true,
  });

  final ValueChanged<bool> onConsentChanged;
  final bool initialValue;
  final bool isRequired;

  @override
  ConsumerState<ConsentCheckbox> createState() => _ConsentCheckboxState();
}

class _ConsentCheckboxState extends ConsumerState<ConsentCheckbox> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _isChecked,
              onChanged: (value) {
                setState(() {
                  _isChecked = value ?? false;
                });
                widget.onConsentChanged(_isChecked);
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildConsentText(context, l10n, theme),
            ),
          ],
        ),
        if (widget.isRequired && !_isChecked)
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 4),
            child: Text(
              l10n.consentRequired,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildConsentText(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyMedium,
        children: [
          TextSpan(text: l10n.iAgreeToThe),
          const TextSpan(text: ' '),
          TextSpan(
            text: l10n.termsOfService,
            style: TextStyle(
              color: theme.colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _navigateToTerms(context),
          ),
          const TextSpan(text: ' '),
          TextSpan(text: l10n.and),
          const TextSpan(text: ' '),
          TextSpan(
            text: l10n.privacyPolicy,
            style: TextStyle(
              color: theme.colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _navigateToPrivacy(context),
          ),
        ],
      ),
    );
  }

  void _navigateToTerms(BuildContext context) {
    Navigator.of(context).pushNamed('/terms');
  }

  void _navigateToPrivacy(BuildContext context) {
    Navigator.of(context).pushNamed('/privacy');
  }
}

/// Enhanced consent widget with logging capabilities
class ConsentForm extends ConsumerStatefulWidget {
  const ConsentForm({
    super.key,
    required this.onConsentComplete,
    this.showSeparateCheckboxes = false,
    this.isSignupFlow = true,
  });

  final VoidCallback onConsentComplete;
  final bool showSeparateCheckboxes;
  final bool isSignupFlow;

  @override
  ConsumerState<ConsentForm> createState() => _ConsentFormState();
}

class _ConsentFormState extends ConsumerState<ConsentForm> {
  bool _termsAccepted = false;
  bool _privacyAccepted = false;
  bool _combinedAccepted = false;
  bool _isLogging = false;

  bool get _isValid {
    if (widget.showSeparateCheckboxes) {
      return _termsAccepted && _privacyAccepted;
    }
    return _combinedAccepted;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.showSeparateCheckboxes) ...[
          ConsentCheckbox(
            onConsentChanged: (value) {
              setState(() {
                _termsAccepted = value;
              });
            },
            initialValue: _termsAccepted,
          ),
          const SizedBox(height: 12),
          _buildPrivacyCheckbox(l10n),
        ] else
          ConsentCheckbox(
            onConsentChanged: (value) {
              setState(() {
                _combinedAccepted = value;
              });
            },
            initialValue: _combinedAccepted,
          ),
        
        const SizedBox(height: 16),
        
        ElevatedButton(
          onPressed: _isValid && !_isLogging ? _handleAcceptConsent : null,
          child: _isLogging 
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(widget.isSignupFlow ? l10n.createAccount : l10n.acceptAndContinue),
        ),
        
        if (widget.isSignupFlow)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l10n.consentSignupNotice,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  Widget _buildPrivacyCheckbox(AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _privacyAccepted,
          onChanged: (value) {
            setState(() {
              _privacyAccepted = value ?? false;
            });
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(text: l10n.iHaveReadAndAgreeToThe),
                const TextSpan(text: ' '),
                TextSpan(
                  text: l10n.privacyPolicy,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Navigator.of(context).pushNamed('/privacy'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleAcceptConsent() async {
    if (!_isValid) return;

    setState(() {
      _isLogging = true;
    });

    try {
      // Log consent acceptance to Firebase
      await ConsentLoggingService.logCombinedAcceptance(
        additionalData: {
          'platform': 'mobile',
          'signup_flow': widget.isSignupFlow,
          'separate_checkboxes': widget.showSeparateCheckboxes,
        },
      );

      // Call completion callback
      widget.onConsentComplete();
    } catch (e) {
      // Show error but don't block the user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Consent logged with warning: ${e.toString()}'),
            backgroundColor: Colors.orange,
          ),
        );
        // Still allow continuation
        widget.onConsentComplete();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLogging = false;
        });
      }
    }
  }
}

/// Provider for checking consent status
final consentStatusProvider = FutureProvider.autoDispose<bool>((ref) async {
  return await ConsentLoggingService.hasValidConsent();
});