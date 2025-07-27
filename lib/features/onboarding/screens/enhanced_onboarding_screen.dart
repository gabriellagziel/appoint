import 'package:appoint/features/onboarding/services/onboarding_service.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/widgets/app_logo.dart';
import 'package:appoint/constants/app_branding.dart';

final onboardingServiceProvider = Provider<OnboardingService>((ref) => OnboardingService());

final onboardingStepProvider = StateProvider<int>((ref) => 0);

final userTypeProvider = StateProvider<UserType?>((ref) => null);

final onboardingDataProvider = StateProvider<Map<String, dynamic>>((ref) => {});

class EnhancedOnboardingScreen extends ConsumerStatefulWidget {
  const EnhancedOnboardingScreen({super.key});

  @override
  ConsumerState<EnhancedOnboardingScreen> createState() => _EnhancedOnboardingScreenState();
}

class _EnhancedOnboardingScreenState extends ConsumerState<EnhancedOnboardingScreen> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for form fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // Selected values
  String? _selectedLanguage;
  String? _selectedCountry;
  String? _selectedTimezone;
  List<String> _selectedInterests = [];

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
    final currentStep = ref.watch(onboardingStepProvider);
    final userType = ref.watch(userTypeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
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
                  itemBuilder: (context, index) {
                    return _buildOnboardingPage(_onboardingPages[index]);
                  },
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

  Widget _buildProgressIndicator(int currentStep) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(6, (index) {
          final isActive = index <= currentStep;
          final isCurrent = index == currentStep;
          
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWelcomeStep(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App logo/icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.schedule,
              color: Colors.white,
              size: 60,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Welcome text
          Text(
            'Welcome to APP-OINT',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Your all-in-one platform for appointments, family coordination, and business management.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Feature highlights
          _buildFeatureHighlight(Icons.calendar_today, 'Smart Scheduling'),
          const SizedBox(height: 16),
          _buildFeatureHighlight(Icons.family_restroom, 'Family Coordination'),
          const SizedBox(height: 16),
          _buildFeatureHighlight(Icons.business, 'Business Management'),
        ],
      ),
    );
  }

  Widget _buildFeatureHighlight(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildUserTypeStep(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'How will you use APP-OINT?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // User type options
          _buildUserTypeOption(
            UserType.personal,
            'Personal',
            'Manage your appointments and family activities',
            Icons.person,
          ),
          
          const SizedBox(height: 16),
          
          _buildUserTypeOption(
            UserType.business,
            'Business',
            'Manage your studio or service business',
            Icons.business,
          ),
          
          const SizedBox(height: 16),
          
          _buildUserTypeOption(
            UserType.family,
            'Family',
            'Coordinate activities with your family',
            Icons.family_restroom,
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeOption(UserType type, String title, String description, IconData icon) {
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

  Widget _buildLanguageStep(AppLocalizations l10n) {
    final languages = [
      {'code': 'en', 'name': 'English'},
      {'code': 'es', 'name': 'Español'},
      {'code': 'fr', 'name': 'Français'},
      {'code': 'de', 'name': 'Deutsch'},
      {'code': 'it', 'name': 'Italiano'},
      {'code': 'pt', 'name': 'Português'},
      {'code': 'ar', 'name': 'العربية'},
      {'code': 'zh', 'name': '中文'},
      {'code': 'ja', 'name': '日本語'},
      {'code': 'ko', 'name': '한국어'},
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Choose your language',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          Expanded(
            child: ListView.builder(
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                final isSelected = _selectedLanguage == language['code'];
                
                return ListTile(
                  leading: Radio<String>(
                    value: language['code']!,
                    groupValue: _selectedLanguage,
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value;
                      });
                    },
                  ),
                  title: Text(language['name']!),
                  trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
                  onTap: () {
                    setState(() {
                      _selectedLanguage = language['code'];
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStep(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tell us about yourself',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // Name field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Email field
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Phone field
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number (Optional)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferencesStep(AppLocalizations l10n) {
    final interests = [
      'Health & Wellness',
      'Beauty & Spa',
      'Education & Training',
      'Professional Services',
      'Entertainment',
      'Sports & Fitness',
      'Technology',
      'Food & Dining',
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'What interests you?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Select topics that interest you (optional)',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemCount: interests.length,
              itemBuilder: (context, index) {
                final interest = interests[index];
                final isSelected = _selectedInterests.contains(interest);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedInterests.remove(interest);
                      } else {
                        _selectedInterests.add(interest);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue[50] : Colors.grey[100],
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        interest,
                        style: TextStyle(
                          color: isSelected ? Colors.blue : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionStep(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.green,
              size: 60,
            ),
          ),
          
          const SizedBox(height: 32),
          
          Text(
            'You\'re all set!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Welcome to APP-OINT. We\'re excited to help you manage your appointments and activities.',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Summary of selections
          _buildSummaryItem('User Type', _getUserTypeName(ref.watch(userTypeProvider))),
          _buildSummaryItem('Language', _getLanguageName(_selectedLanguage)),
          if (_nameController.text.isNotEmpty)
            _buildSummaryItem('Name', _nameController.text),
        ],
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

  Widget _buildNavigationButtons(int currentStep, UserType? userType, AppLocalizations l10n) {
    return Container(
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
              onPressed: _canProceed(currentStep, userType) ? _handleNext : null,
              child: Text(currentStep == 5 ? 'Get Started' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }

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

  void _completeOnboarding() async {
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
