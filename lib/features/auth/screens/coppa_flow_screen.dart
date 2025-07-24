import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/providers/coppa_flow_provider.dart';

class COPPAFlowScreen extends ConsumerStatefulWidget {
  final DateTime birthDate;
  final int age;

  const COPPAFlowScreen({
    super.key,
    required this.birthDate,
    required this.age,
  });

  @override
  ConsumerState<COPPAFlowScreen> createState() => _COPPAFlowScreenState();
}

class _COPPAFlowScreenState extends ConsumerState<COPPAFlowScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  final _parentEmailController = TextEditingController();
  final _parentPhoneController = TextEditingController();
  String _selectedContactMethod = 'email';
  bool _isLoading = false;

  @override
  void dispose() {
    _pageController.dispose();
    _parentEmailController.dispose();
    _parentPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.parentalApprovalRequired),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / 4,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildWelcomePage(l10n),
                _buildExplanationPage(l10n),
                _buildParentContactPage(l10n),
                _buildVerificationPendingPage(l10n),
              ],
            ),
          ),
          // Navigation buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (_currentPage > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(l10n.back),
                    ),
                  ),
                if (_currentPage > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleNextButton,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_getNextButtonText(l10n)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomePage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.family_restroom,
            size: 80,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.coppaWelcomeTitle,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.coppaWelcomeMessage(widget.age),
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.security,
                  color: Colors.blue.shade700,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.coppaProtectionNotice,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationPage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.coppaExplanationTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          _buildStepCard(
            l10n,
            1,
            l10n.coppaStep1Title,
            l10n.coppaStep1Description,
            Icons.contact_mail,
          ),
          const SizedBox(height: 16),
          _buildStepCard(
            l10n,
            2,
            l10n.coppaStep2Title,
            l10n.coppaStep2Description,
            Icons.smartphone,
          ),
          const SizedBox(height: 16),
          _buildStepCard(
            l10n,
            3,
            l10n.coppaStep3Title,
            l10n.coppaStep3Description,
            Icons.verified_user,
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info,
                  color: Colors.orange.shade700,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.coppaTimeEstimate,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard(AppLocalizations l10n, int step, String title, String description, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParentContactPage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.coppaParentContactTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.coppaContactMethodLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: Text(l10n.email),
                  value: 'email',
                  groupValue: _selectedContactMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedContactMethod = value!;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: Text(l10n.phone),
                  value: 'phone',
                  groupValue: _selectedContactMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedContactMethod = value!;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_selectedContactMethod == 'email') ...[
            TextFormField(
              controller: _parentEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: l10n.parentEmail,
                hintText: l10n.parentEmailHint,
                prefixIcon: const Icon(Icons.email),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.parentEmailRequired;
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return l10n.invalidEmailFormat;
                }
                return null;
              },
            ),
          ] else ...[
            TextFormField(
              controller: _parentPhoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: l10n.parentPhone,
                hintText: l10n.parentPhoneHint,
                prefixIcon: const Icon(Icons.phone),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return l10n.parentPhoneRequired;
                }
                return null;
              },
            ),
          ],
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.coppaPrivacyAssurance,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.coppaPrivacyDetails,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationPendingPage(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.schedule,
            size: 80,
            color: Colors.orange,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.coppaVerificationPendingTitle,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.coppaVerificationPendingMessage,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.mobile_friendly,
                  color: Colors.blue.shade700,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.coppaParentAppRequired,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.coppaParentAppInstructions,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Open app store or share download link
            },
            icon: const Icon(Icons.download),
            label: Text(l10n.downloadParentApp),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  String _getNextButtonText(AppLocalizations l10n) {
    switch (_currentPage) {
      case 0:
        return l10n.getStarted;
      case 1:
        return l10n.continueButton;
      case 2:
        return l10n.sendVerification;
      case 3:
        return l10n.done;
      default:
        return l10n.next;
    }
  }

  Future<void> _handleNextButton() async {
    if (_currentPage < 3) {
      if (_currentPage == 2) {
        // Send parent verification
        await _sendParentVerification();
      }
      
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Close the flow
      context.go('/');
    }
  }

  Future<void> _sendParentVerification() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final coppaNotifier = ref.read(coppaFlowProvider.notifier);
      
      if (_selectedContactMethod == 'email') {
        await coppaNotifier.sendParentEmailVerification(
          _parentEmailController.text,
          widget.birthDate,
          widget.age,
        );
      } else {
        await coppaNotifier.sendParentPhoneVerification(
          _parentPhoneController.text,
          widget.birthDate,
          widget.age,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.verificationSendError),
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