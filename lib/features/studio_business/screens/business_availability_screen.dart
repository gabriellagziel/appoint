import 'package:appoint/features/studio_business/providers/business_availability_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessAvailabilityScreen extends ConsumerWidget {
  const BusinessAvailabilityScreen({super.key});

  String _getDayName(int weekday) {
    switch (weekday) {
      case 0:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return 'Unknown';
    }
  }

  Future<void> _pickTime(
    final BuildContext context,
    final TimeOfDay initial,
    void Function(TimeOfDay) onPicked,
  ) async {
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final availability = ref.watch(businessAvailabilityProvider);
    final notifier = ref.read(businessAvailabilityProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Availability'),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: availability.length,
        separatorBuilder: (_, final __) => const Divider(height: 1),
        itemBuilder: (context, final idx) {
          final avail = availability[idx];
          return ListTile(
            leading: Icon(
              avail.isOpen ? Icons.check_circle : Icons.cancel,
              color: avail.isOpen ? Colors.green : Colors.red,
            ),
            title: Text(_getDayName(avail.weekday)),
            subtitle: avail.isOpen
                ? Row(
                    children: [
                      Text('From: ${avail.start.format(context)}'),
                      const SizedBox(width: 16),
                      Text('To: ${avail.end.format(context)}'),
                    ],
                  )
                : const Text('Closed'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: avail.isOpen,
                  onChanged: (v) => notifier.toggleOpen(avail.weekday, v),
                ),
                if (avail.isOpen) ...[
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    tooltip: 'Set Start',
                    onPressed: () => _pickTime(
                      context,
                      avail.start,
                      (t) => notifier.setHours(avail.weekday, t, avail.end),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.access_time_filled),
                    tooltip: 'Set End',
                    onPressed: () => _pickTime(
                      context,
                      avail.end,
                      (t) => notifier.setHours(avail.weekday, avail.start, t),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
