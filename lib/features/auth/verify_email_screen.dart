import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool _linkSent = false;

  void _openEmailApp() {
    // TODO: Use url_launcher to open default email app if desired.
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Verify your email')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.mail, size: 80, color: Theme.of(context).primaryColor),
              const SizedBox(height: 24),
              const Text(
                'A verification link has been sent to your email address. Please click the link to verify your account before signing in.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _openEmailApp,
                child: const Text('Open Email App'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _linkSent
                    ? null
                    : () {
                        setState(() {
                          _linkSent = true;
                        });
                        // TODO: Resend verification link using Firebase.
                      },
                child:
                    Text(_linkSent ? 'Link Sent' : 'Resend Verification Email'),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Back to login'),
              ),
            ],
          ),
        ),
      );
}
