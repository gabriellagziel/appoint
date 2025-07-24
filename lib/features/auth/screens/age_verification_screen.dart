import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/providers/age_verification_provider.dart';

class AgeVerificationScreen extends ConsumerStatefulWidget {
  const AgeVerificationScreen({super.key});

  @override
  ConsumerState<AgeVerificationScreen> createState() => _AgeVerificationScreenState();
}

class _AgeVerificationScreenState extends ConsumerState<AgeVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _birthDateController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ageVerification),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Icon(
                Icons.cake,
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.ageVerificationTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.ageVerificationDescription,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _birthDateController,
                decoration: InputDecoration(
                  labelText: l10n.birthDate,
                  hintText: l10n.birthDateHint,
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: _selectDate,
                validator: (value) {
                  if (_selectedDate == null) {
                    return l10n.birthDateRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.security,
                      color: Colors.blue.shade700,
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.ageVerificationPrivacyNotice,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blue.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyAge,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.verifyAge),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.ageVerificationLegalNotice,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 100);
    final lastDate = DateTime(now.year - 5); // Minimum age of 5

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: AppLocalizations.of(context)!.selectBirthDate,
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
        _birthDateController.text = '${date.day}/${date.month}/${date.year}';
      });
    }
  }

  Future<void> _verifyAge() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final ageVerificationNotifier = ref.read(ageVerificationProvider.notifier);
      final result = await ageVerificationNotifier.verifyAge(_selectedDate!);

      if (!mounted) return;

      if (result.isMinor) {
        // User is under 13 - requires COPPA flow
        context.push('/coppa-flow', extra: {
          'birthDate': _selectedDate!,
          'age': result.age,
        });
      } else if (result.age < 18) {
        // User is between 13-17 - requires parental notification
        context.push('/parent-notification', extra: {
          'birthDate': _selectedDate!,
          'age': result.age,
        });
      } else {
        // Adult user - continue with normal registration
        context.push('/register', extra: {
          'birthDate': _selectedDate!,
          'age': result.age,
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.ageVerificationError),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}