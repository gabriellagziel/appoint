import 'package:flutter/material.dart';

void main() {
  runApp(const AppointApp());
}

class AppointApp extends StatelessWidget {
  const AppointApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Appoint',
      routes: {
        '/ambassador-onboarding':
            (context) => const _SimpleScreen('Ambassador Onboarding'),
        '/chat-booking': (context) => const _SimpleScreen('Chat Booking'),
        '/business-calendar': (context) => const _BusinessCalendarRoute(),
      },
      home: Scaffold(
        appBar: AppBar(title: const Text('Appoint')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Book Appointment'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () {}, child: const Text('My Profile')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Edit Profile'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Save Changes'),
              ),
              const SizedBox(height: 16),
              const Icon(Icons.calendar_month),
              const SizedBox(height: 8),
              ElevatedButton(onPressed: () {}, child: const Text('Confirm')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Delete My Account'),
              ),
              const SizedBox(height: 8),
              TextButton(onPressed: () {}, child: const Text('Delete Account')),
              const SizedBox(height: 8),
              TextButton(onPressed: () {}, child: const Text('Cancel')),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimpleScreen extends StatelessWidget {
  const _SimpleScreen(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}

class _BusinessCalendarRoute extends StatelessWidget {
  const _BusinessCalendarRoute();

  @override
  Widget build(BuildContext context) {
    return const _BusinessCalendarLazy();
  }
}

class _BusinessCalendarLazy extends StatelessWidget {
  const _BusinessCalendarLazy();

  @override
  Widget build(BuildContext context) {
    return const _BusinessCalendarShim();
  }
}

// Lightweight indirection to avoid import cycle from tests
class _BusinessCalendarShim extends StatelessWidget {
  const _BusinessCalendarShim();

  @override
  Widget build(BuildContext context) {
    return const _SimpleScreen('Business Calendar');
  }
}
