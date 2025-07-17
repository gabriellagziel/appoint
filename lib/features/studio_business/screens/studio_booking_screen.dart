import 'package:appoint/features/studio_business/models/staff_profile.dart';
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
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: const Text('Studio Booking')),
        body: const Center(
          child: Text('Studio booking is only available on web'),
        ),
      );
    }

    final profileAsync = ref.watch(businessProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Studio Booking')),
      body: profileAsync == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                              profileAsync.name,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text('Phone: ${profileAsync.phone}'),
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

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _processBooking,
                        child: _isProcessing
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
    if (_formKey.currentState!.validate()) {
      setState(() => _isProcessing = true);

      try {
        // Check weekly usage for upgrade modal
        final weeklyUsage = ref.read(weeklyUsageProvider.notifier);
        if (weeklyUsage.shouldShowUpgradeModal) {
          _showUpgradeModal(weeklyUsage.upgradeCode);
          return;
        }

        // Create booking
        final bookingNotifier = ref.read(bookingProvider.notifier);
        await bookingNotifier.createBooking(
          staffProfileId: selectedStaff!.id,
          businessProfileId: 'business1', // This should come from the profile
          date: selectedDate!,
          startTime: selectedTimeSlot!,
          endTime: _getEndTime(selectedTimeSlot!),
          cost: selectedStaff!.hourlyRate,
        );

        // Increment weekly usage
        await weeklyUsage.incrementUsage();

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const StudioBookingConfirmScreen(),
            ),
          );
        }
      } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
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
    // Implementation of _selectDate method
  }

  void _selectTime(BuildContext context) {
    // Implementation of _selectTime method
  }
}

class StudioBookingConfirmScreen extends StatelessWidget {
  const StudioBookingConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Booking Confirmed')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 64),
            SizedBox(height: 16),
            Text(
              'Your studio booking has been confirmed!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('You will receive a confirmation email shortly.'),
          ],
        ),
      ),
    );
}
