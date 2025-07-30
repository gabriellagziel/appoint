import 'package:appoint/features/studio_business/models/staff_profile.dart';
import 'package:appoint/features/studio_business/models/business_profile.dart';
import 'package:appoint/features/studio_business/providers/booking_provider.dart';
import 'package:appoint/features/studio_business/providers/business_profile_provider.dart';
import 'package:appoint/features/studio_business/providers/weekly_usage_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StudioBookingScreen extends ConsumerStatefulWidget {
  const StudioBookingScreen({super.key});

  @override
  ConsumerState<StudioBookingScreen> createState() =>
      _StudioBookingScreenState();
}

class _StudioBookingScreenState extends ConsumerState<StudioBookingScreen> {
  DateTime? selectedDate;
  String? selectedTimeSlot;
  StaffProfile? selectedStaff;
  bool isConfirming = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  bool _isProcessing = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: const Text('Studio Booking')),
        body: const Center(
          child: Text('Studio booking is only available on web'),
        ),
      );
    }

    final profile = ref.watch(studioBusinessProfileProvider);
    final bookingAsync = ref.watch(bookingProvider);

    if (profile == null) {
      return const Scaffold(
        appBar: AppBar(title: Text('Studio Booking')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Studio Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Business Info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text('Phone: ${profile.phone}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Customer Details Form
              const Text(
                'Customer Details',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixText: '+1 ',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Preferred Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Preferred Time',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () => _selectTime(context),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Show booking state
              bookingAsync.when(
                data: (booking) => const SizedBox.shrink(),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red.shade600),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Error: ${error.toString()}',
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing || bookingAsync.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  ) 
                      ? null 
                      : _processBooking,
                  child: _isProcessing || bookingAsync.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  )
                      ? const CircularProgressIndicator()
                      : const Text('Send Booking Invite'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TODO(username): Implement time slot selector and staff selector when needed

  Future<void> _processBooking() async {
    final profile = ref.read(studioBusinessProfileProvider);
    if (_formKey.currentState!.validate() && profile != null) {
      setState(() => _isProcessing = true);

      try {
        // Check weekly usage for upgrade modal
        final weeklyUsage = ref.read(weeklyUsageProvider.notifier);
        if (weeklyUsage.shouldShowUpgradeModal) {
          _showUpgradeModal(weeklyUsage.upgradeCode);
          return;
        }

        // Create booking using submitBooking method
        final bookingNotifier = ref.read(bookingProvider.notifier);
        await bookingNotifier.submitBooking(
          staffProfileId: selectedStaff?.id ?? 'default-staff-id',
          businessProfileId: profile.id,
          date: selectedDate ?? DateTime.now(),
          startTime: selectedTimeSlot ?? '09:00',
          endTime: _getEndTime(selectedTimeSlot ?? '09:00'),
          cost: selectedStaff?.hourlyRate ?? 50.0,
        );

        // Increment weekly usage
        await weeklyUsage.incrementUsage();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking submitted successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
        if (mounted) {
          setState(() => _isProcessing = false);
        }
      }
    }
  }

  String _getEndTime(String startTime) {
    final parts = startTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final endMinute = minute + 30;
    final endHour = hour + (endMinute >= 60 ? 1 : 0);
    final finalMinute = endMinute >= 60 ? endMinute - 60 : endMinute;

    return '${endHour.toString().padLeft(2, '0')}:${finalMinute.toString().padLeft(2, '0')}';
  }

  void _showUpgradeModal(String upgradeCode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Upgrade to Business'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("You've exceeded the weekly booking limit."),
            const SizedBox(height: 16),
            Text('Your upgrade code: $upgradeCode'),
            const SizedBox(height: 16),
            const Text('Please activate your business profile to continue.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/business/connect');
            },
            child: const Text('Activate Business Profile'),
          ),
        ],
      ),
    );
  }

  void _selectDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((date) {
      if (date != null) {
        setState(() {
          selectedDate = date;
          _dateController.text = '${date.day}/${date.month}/${date.year}';
        });
      }
    });
  }

  void _selectTime(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    ).then((time) {
      if (time != null) {
        setState(() {
          selectedTimeSlot = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
          _timeController.text = time.format(context);
        });
      }
    });
  }
}
