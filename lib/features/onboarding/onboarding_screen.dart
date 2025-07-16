import 'package:appoint/config/theme.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/services/analytics_service.dart';
import 'package:appoint/services/onboarding_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = false;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to APP-OINT',
      subtitle: 'Your all-in-one platform for appointments, family coordination, and safe gaming',
      description: 'Connect with businesses, coordinate with family, and enjoy safe gaming experiences all in one place.',
      icon: Icons.app_registration,
      color: AppTheme.primaryColor,
      image: 'assets/images/onboarding/welcome.png',
    ),
    OnboardingPage(
      title: 'Easy Appointment Booking',
      subtitle: 'Book appointments with local businesses instantly',
      description: 'Find and book appointments with local businesses, salons, studios, and service providers with just a few taps.',
      icon: Icons.calendar_today,
      color: AppTheme.secondaryColor,
      image: 'assets/images/onboarding/booking.png',
    ),
    OnboardingPage(
      title: 'Family Coordination',
      subtitle: 'Stay connected with your family',
      description: 'Coordinate schedules, manage family activities, and keep everyone in sync with our family features.',
      icon: Icons.family_restroom,
      color: AppTheme.accentColor,
      image: 'assets/images/onboarding/family.png',
    ),
    OnboardingPage(
      title: 'Safe Gaming for Kids',
      subtitle: 'Parent-approved gaming experiences',
      description: 'Let your children enjoy safe, educational gaming with friends while you maintain full control and oversight.',
      icon: Icons.games,
      color: Colors.green,
      image: 'assets/images/onboarding/playtime.png',
    ),
    OnboardingPage(
      title: 'Ready to Get Started?',
      subtitle: 'Join thousands of families using APP-OINT',
      description: 'Create your account and start exploring all the features that make APP-OINT the perfect platform for modern families.',
      icon: Icons.rocket_launch,
      color: AppTheme.primaryColor,
      image: 'assets/images/onboarding/get-started.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _trackOnboardingStart();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _trackOnboardingStart() {
    AnalyticsService().trackOnboardingStart();
  }

  void _trackOnboardingStep(int stepNumber) {
    AnalyticsService().trackOnboardingStep(
      stepName: _pages[stepNumber].title,
      stepNumber: stepNumber + 1,
      totalSteps: _pages.length,
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _trackOnboardingStep(_currentPage + 1);
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await OnboardingService().markOnboardingComplete();
      AnalyticsService().trackOnboardingComplete();
      
      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing onboarding: $e'),
            backgroundColor: Colors.red,
          ),
        );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator and skip button
            _buildHeader(l10n),
            
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  _trackOnboardingStep(index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index], l10n);
                },
              ),
            ),
            
            // Navigation buttons
            _buildNavigation(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Progress dots
          Row(
            children: List.generate(
              _pages.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == _currentPage 
                    ? _pages[_currentPage].color 
                    : Colors.grey[300],
                ),
              ),
            ),
          ),
          
          // Skip button
          if (_currentPage < _pages.length - 1)
            TextButton(
              onPressed: _skipOnboarding,
              child: Text(
                l10n.skip,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon or image
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              page.icon,
              size: 60,
              color: page.color,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Title
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Subtitle
          Text(
            page.subtitle,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: page.color,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            page.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          if (_currentPage > 0)
            TextButton.icon(
              onPressed: _previousPage,
              icon: const Icon(Icons.arrow_back),
              label: Text(l10n.back),
            )
          else
            const SizedBox(width: 80),
          
          // Next/Get Started button
          SizedBox(
            width: 160,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: _pages[_currentPage].color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    _currentPage == _pages.length - 1 
                      ? l10n.getStarted 
                      : l10n.next,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final String image;

  const OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.image,
  });
} 