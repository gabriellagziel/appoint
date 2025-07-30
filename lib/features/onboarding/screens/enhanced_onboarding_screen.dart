import 'package:appoint/constants/app_branding.dart';
import 'package:appoint/features/onboarding/services/onboarding_service.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingServiceProvider =
    Provider<OnboardingService>((ref) => OnboardingService());

final onboardingStepProvider = StateProvider<int>((ref) => 0);

final userTypeProvider = StateProvider<UserType?>((ref) => null);

final onboardingDataProvider = StateProvider<Map<String, dynamic>>((ref) => {});

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;

  const OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class EnhancedOnboardingScreen extends ConsumerStatefulWidget {
  const EnhancedOnboardingScreen({super.key});

  @override
  ConsumerState<EnhancedOnboardingScreen> createState() =>
      _EnhancedOnboardingScreenState();
}

class _EnhancedOnboardingScreenState
    extends ConsumerState<EnhancedOnboardingScreen> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Selected values
  String? _selectedLanguage;
  // TODO: Implement country and timezone selection
  // String? _selectedCountry;
  // String? _selectedTimezone;
  final List<String> _selectedInterests = [];

  // Onboarding state
  int _currentPage = 0;

  // Onboarding pages
  final List<OnboardingPage> _onboardingPages = [
    const OnboardingPage(
      title: 'Welcome',
      subtitle: 'Welcome to APP-OINT',
      description:
          'Your all-in-one platform for appointments, family coordination, and safe gaming.',
      icon: Icons.app_registration,
      color: Colors.blue,
    ),
    const OnboardingPage(
      title: 'User Type',
      subtitle: 'How will you use APP-OINT?',
      description: 'Choose how you plan to use our platform.',
      icon: Icons.person,
      color: Colors.purple,
    ),
    const OnboardingPage(
      title: 'Language',
      subtitle: 'Select your language',
      description: 'Choose your preferred language for the app.',
      icon: Icons.language,
      color: Colors.orange,
    ),
    const OnboardingPage(
      title: 'Profile',
      subtitle: 'Tell us about yourself',
      description: 'Help us personalize your experience.',
      icon: Icons.account_circle,
      color: Colors.green,
    ),
    const OnboardingPage(
      title: 'Preferences',
      subtitle: 'Customize your experience',
      description: 'Set your preferences and interests.',
      icon: Icons.settings,
      color: Colors.red,
    ),
    const OnboardingPage(
      title: 'Complete',
      subtitle: 'You\'re all set!',
      description: 'Welcome to APP-OINT! Let\'s get started.',
      icon: Icons.check_circle,
      color: Colors.teal,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _detectLanguage();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _detectLanguage() {
    final locale = Localizations.localeOf(context);
    setState(() {
      _selectedLanguage = locale.languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Implement step and user type tracking
    // final currentStep = ref.watch(onboardingStepProvider);
    // final userType = ref.watch(userTypeProvider);
    // final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo/icon
              const AppLogo(size: 120),

              const SizedBox(height: 48),

              Text(
                'Welcome to APP-OINT',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                AppBranding.fullSlogan,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Onboarding content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _onboardingPages.length,
                  itemBuilder: (context, index) =>
                      _buildOnboardingPage(_onboardingPages[index]),
                ),
              ),

              // Page indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _onboardingPages.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Theme.of(context).primaryColor
                          : Colors.grey[300],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    TextButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Previous'),
                    )
                  else
                    const SizedBox(width: 80),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _onboardingPages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // Complete onboarding
                        _completeOnboarding();
                      }
                    },
                    child: Text(
                      _currentPage < _onboardingPages.length - 1
                          ? 'Next'
                          : 'Get Started',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            page.icon,
            size: 80,
            color: page.color,
          ),
          const SizedBox(height: 32),
          Text(
            page.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: page.color,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.subtitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[700],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeOption(
      UserType type, String title, String description, IconData icon) {
    final selectedType = ref.watch(userTypeProvider);
    final isSelected = selectedType == type;

    return GestureDetector(
      onTap: () {
        ref.read(userTypeProvider.notifier).state = type;
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.blue[50] : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey[600],
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.blue : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.blue, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String? value) {
    if (value == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(
          int currentStep, UserType? userType, AppLocalizations l10n) =>
      Container(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            // Back button
            if (currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text('Back'),
                ),
              ),

            if (currentStep > 0) const SizedBox(width: 16),

            // Next/Complete button
            Expanded(
              child: ElevatedButton(
                onPressed:
                    _canProceed(currentStep, userType) ? _handleNext : null,
                child: Text(currentStep == 5 ? 'Get Started' : 'Next'),
              ),
            ),
          ],
        ),
      );

  bool _canProceed(int currentStep, UserType? userType) {
    switch (currentStep) {
      case 0: // Welcome
        return true;
      case 1: // User type
        return userType != null;
      case 2: // Language
        return _selectedLanguage != null;
      case 3: // Profile
        return _formKey.currentState?.validate() ?? false;
      case 4: // Preferences
        return true;
      case 5: // Completion
        return true;
      default:
        return false;
    }
  }

  void _handleNext() {
    final currentStep = ref.read(onboardingStepProvider);

    if (currentStep == 5) {
      _completeOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    try {
      final service = ref.read(onboardingServiceProvider);

      // Save onboarding data
      final onboardingData = {
        'userType': ref.read(userTypeProvider),
        'language': _selectedLanguage,
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'interests': _selectedInterests,
        'completedAt': DateTime.now().toIso8601String(),
      };

      await service.completeOnboarding(onboardingData);

      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete onboarding: $e')),
      );
    }
  }
}

String _getUserTypeName(UserType? type) {
  switch (type) {
    case UserType.personal:
      return 'Personal';
    case UserType.business:
      return 'Business';
    case UserType.family:
      return 'Family';
    default:
      return 'Not selected';
  }
}

String _getLanguageName(String? code) {
  final languages = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'it': 'Italiano',
    'pt': 'Português',
    'ar': 'العربية',
    'zh': '中文',
    'ja': '日本語',
    'ko': '한국어',
  };

  return languages[code] ?? 'Not selected';
}

enum UserType {
  personal,
  business,
  family,
}
