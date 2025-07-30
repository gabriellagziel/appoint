import 'package:appoint/models/family_link.dart';
import 'package:appoint/providers/family_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConsentControls extends ConsumerStatefulWidget {
  const ConsentControls({
    required this.familyLink,
    super.key,
    this.onConsentChanged,
  });
  final FamilyLink familyLink;
  final VoidCallback? onConsentChanged;

  @override
  ConsumerState<ConsentControls> createState() => _ConsentControlsState();
}

class _ConsentControlsState extends ConsumerState<ConsentControls> {
  bool _isLoading = false;
  bool _hasConsented = false;

  @override
  void initState() {
    super.initState();
    _checkConsentStatus();
  }

  void _checkConsentStatus() {
    // Check if current user has already consented
    _hasConsented = widget.familyLink.consentedAt != null;
  }

  Future<void> _updateConsent(bool grant) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(familyServiceProvider).updateConsent(
            widget.familyLink.id,
            grant,
          );

      setState(() {
        _hasConsented = grant;
      });

      widget.onConsentChanged?.call();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              grant
                  ? 'Consent granted successfully!'
                  : 'Consent revoked successfully!',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update consent: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _hasConsented ? Icons.check_circle : Icons.pending,
                    color: _hasConsented ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Parental Consent',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _hasConsented
                    ? 'You have granted consent for this family link.'
                    : 'You have not yet granted consent for this family link.',
                style: TextStyle(
                  color: _hasConsented ? Colors.green : Colors.orange,
                ),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            _hasConsented ? null : () => _updateConsent(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Grant Consent'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            _hasConsented ? () => _updateConsent(false) : null,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Revoke Consent'),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              const Text(
                'Note: Both parents must grant consent for full access.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      );
}
