import 'package:flutter/material.dart';

/// Screen allowing parents to manage basic parental controls.
class ParentalSettingsScreen extends StatefulWidget {
  const ParentalSettingsScreen({super.key});

  @override
  State<ParentalSettingsScreen> createState() => _ParentalSettingsScreenState();
}

class _ParentalSettingsScreenState extends State<ParentalSettingsScreen> {
  bool _restrictMatureContent = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Parental Settings'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                title: const Text('Restrict mature content'),
                value: _restrictMatureContent,
                onChanged: (value) {
                  setState(() {
                    _restrictMatureContent = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Manage Child Accounts'),
              ),
            ],
          ),
        ),
      );
}
