import 'package:appoint/l10n/l10n_contribution.dart';
import 'package:flutter/material.dart';

/// Simple UI allowing ambassadors to submit missing translations.
class LocalizationContributionScreen extends StatefulWidget {
  const LocalizationContributionScreen({super.key});

  @override
  State<LocalizationContributionScreen> createState() =>
      _LocalizationContributionScreenState();
}

class _LocalizationContributionScreenState
    extends State<LocalizationContributionScreen> {
  String? _selectedLocale;

  @override
  Widget build(BuildContext context) {
    final locales = missingTranslations.keys.toList()..sort();
    _selectedLocale ??= locales.isNotEmpty ? locales.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Localization Contribution'),
      ),
      body: _selectedLocale == null
          ? const Center(child: Text('No missing translations'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: DropdownButton<String>(
                    value: _selectedLocale,
                    onChanged: (val) => setState(() => _selectedLocale = val),
                    items: [
                      for (locale in locales)
                        DropdownMenuItem(
                          value: locale,
                          child: Text(locale),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      for (key in missingTranslations[_selectedLocale]!)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: key,
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // TODO(username): Implement this featurend translations to backend
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
