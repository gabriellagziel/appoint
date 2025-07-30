import 'package:flutter/material.dart';

/// Simple screen prompting for parental consent with affirmative and decline actions.
class ParentalConsentPrompt extends StatelessWidget {
  const ParentalConsentPrompt({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Parental Consent'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Parental Consent Required',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'We need your consent to proceed. Please review the information and select an option below.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                child: const Text('I Consent'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {},
                child: const Text('I Do Not Consent'),
              ),
            ],
          ),
        ),
      );
}
