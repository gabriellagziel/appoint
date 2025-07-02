import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/models/staff_member.dart';
import 'package:appoint/models/staff_availability.dart';
import 'package:appoint/providers/studio_provider.dart';

class StudioBookingSelection {
  final StaffMember staff;
  final DateTime date;
  final TimeOfDay slot;

  StudioBookingSelection({
    required this.staff,
    required this.date,
    required this.slot,
  });
}

class StudioBookingScreen extends ConsumerStatefulWidget {
  const StudioBookingScreen({super.key});

  @override
  ConsumerState<StudioBookingScreen> createState() =>
      _StudioBookingScreenState();
}

class _StudioBookingScreenState extends ConsumerState<StudioBookingScreen> {
  StaffMember? _selectedStaff;
  DateTime? _selectedDate;
  TimeOfDay? _selectedSlot;

  TimeOfDay _parseTimeSlot(final String slot) {
    final parts = slot.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
        _selectedSlot = null;
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    final studioId = ModalRoute.of(context)!.settings.arguments as String;
    final staffListAsync = ref.watch(staffListProvider(studioId));
    AsyncValue<StaffAvailability>? availability;
    if (_selectedStaff != null && _selectedDate != null) {
      availability = ref.watch(staffAvailabilityProvider({
        'staffId': _selectedStaff!.id,
        'date': _selectedDate!,
      }));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Studio Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            staffListAsync.when(
              data: (final staff) => DropdownButton<StaffMember>(
                value: _selectedStaff,
                hint: const Text('Select Staff'),
                onChanged: (final value) {
                  setState(() {
                    _selectedStaff = value;
                    _selectedSlot = null;
                  });
                },
                items: staff
                    .map((final s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.displayName),
                        ))
                    .toList(),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (final _, final __) => const Text('Error loading staff'),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(_selectedDate == null
                  ? 'Pick Date'
                  : _selectedDate!.toLocal().toString().split(' ')[0]),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const SizedBox(height: 16),
            if (availability != null)
              availability.when(
                data: (final avail) {
                  final slots = avail.availableSlots;
                  if (slots == null || slots.isEmpty) {
                    return const Text('No slots');
                  }
                  return Wrap(
                    spacing: 8,
                    children: slots.map((final slot) {
                      final timeSlot = _parseTimeSlot(slot);
                      final selected = _selectedSlot == timeSlot;
                      return ChoiceChip(
                        label: Text(slot),
                        selected: selected,
                        onSelected: (final _) {
                          setState(() {
                            _selectedSlot = timeSlot;
                          });
                        },
                      );
                    }).toList(),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (final _, final __) => const Text('Error loading slots'),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: _selectedStaff != null &&
                      _selectedDate != null &&
                      _selectedSlot != null
                  ? () {
                      final args = StudioBookingSelection(
                        staff: _selectedStaff!,
                        date: _selectedDate!,
                        slot: _selectedSlot!,
                      );
                      Navigator.pushNamed(context, '/studio/confirm',
                          arguments: args);
                    }
                  : null,
              child: const Text('Next'),
            )
          ],
        ),
      ),
    );
  }
}
