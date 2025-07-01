import 'package:flutter/material.dart';

import 'package:appoint/theme/app_spacing.dart';
import 'package:appoint/theme/app_text_styles.dart';

/// Dropdown widget to select a timezone using Material 3 styling.
class TimezoneSelector extends StatefulWidget {
  const TimezoneSelector({super.key});

  @override
  State<TimezoneSelector> createState() => _TimezoneSelectorState();
}

class _TimezoneSelectorState extends State<TimezoneSelector> {
  static const List<String> _timezones = [
    'UTC',
    'America/New_York',
    'America/Chicago',
    'America/Denver',
    'America/Los_Angeles',
    'Europe/London',
    'Europe/Paris',
    'Asia/Tokyo',
    'Asia/Kolkata',
    'Australia/Sydney',
  ];

  String? _selectedTimezone;

  @override
  Widget build(final BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Timezone',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
      value: _selectedTimezone,
      style: AppTextStyles.body,
      items: _timezones
          .map((final tz) => DropdownMenuItem(value: tz, child: Text(tz)))
          .toList(),
      onChanged: (final value) {
        setState(() {
          _selectedTimezone = value;
        });
        if (value != null) {
          // Removed debug print: debugPrint('Selected timezone: $value');
        }
      },
    );
  }
}
