import 'package:flutter/material.dart';
import 'package:appoint/features/studio_business/screens/business_calendar_screen.dart';
import 'package:appoint/features/studio_business/screens/business_availability_screen.dart';

class BusinessEntryScreen extends StatelessWidget {
  const BusinessEntryScreen({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (final context, final constraints) {
            final isWide = constraints.maxWidth > 600;
            return isWide
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _NavTile(
                        icon: Icons.calendar_month,
                        label: 'Calendar',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (final _) => const BusinessCalendarScreen()),
                        ),
                      ),
                      const SizedBox(width: 32),
                      _NavTile(
                        icon: Icons.access_time,
                        label: 'Availability',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (final _) =>
                                  const BusinessAvailabilityScreen()),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _NavTile(
                        icon: Icons.calendar_month,
                        label: 'Calendar',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (final _) => const BusinessCalendarScreen()),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _NavTile(
                        icon: Icons.access_time,
                        label: 'Availability',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (final _) =>
                                  const BusinessAvailabilityScreen()),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _NavTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(final BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(label, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
