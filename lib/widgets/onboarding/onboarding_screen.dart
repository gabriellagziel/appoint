import 'package:flutter/material.dart';

/// Simple onboarding flow with progress indicator and skip/next buttons.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<_OnboardingPage> _pages = const [
    _OnboardingPage(title: 'Welcome', description: 'Welcome to Appoint!'),
    _OnboardingPage(
      title: 'Core Features',
      description: 'Discover the core features.',
    ),
    _OnboardingPage(
      title: 'Scheduling Flow',
      description: 'Easily schedule appointments.',
    ),
    _OnboardingPage(
      title: 'Upgrade Plan',
      description: 'Upgrade anytime for more.',
    ),
  ];

  void _next() {
    if (_index < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      OnboardingPrefs.setCompleted();
      Navigator.of(context).pop();
    }
  }

  void _skip() {
    OnboardingPrefs.setCompleted();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (i) => setState(() => _index = i),
                  children: _pages,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_index < _pages.length - 1)
                      TextButton(onPressed: _skip, child: const Text('Skip'))
                    else
                      const SizedBox(width: 60),
                    Row(
                      children: List.generate(
                        _pages.length,
                        (i) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i == _index ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _next,
                      child:
                          Text(_index == _pages.length - 1 ? 'Finish' : 'Next'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
}

/// Mock storage for onboarding completion.
class OnboardingPrefs {
  static bool _completed = false;
  static Future<bool> isCompleted() async => _completed;
  static Future<void> setCompleted() async {
    _completed = true;
  }
}
