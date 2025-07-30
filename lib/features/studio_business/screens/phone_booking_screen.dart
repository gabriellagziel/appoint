import 'package:appoint/features/studio_business/providers/business_profile_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneBookingScreen extends ConsumerStatefulWidget {
  const PhoneBookingScreen({super.key});

  @override
  ConsumerState<PhoneBookingScreen> createState() => _PhoneBookingScreenState();
}

class _PhoneBookingScreenState extends ConsumerState<PhoneBookingScreen> {
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
    final profileAsync = ref.watch(businessProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Phone Booking')),
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

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      _dateController.text =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      _timeController.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _processBooking() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final phoneNumber = _phoneController.text.trim();
      final customerName = _nameController.text.trim();
      final date = _dateController.text;
      final time = _timeController.text;

      // Generate unique booking code
      final bookingCode = _generateBookingCode();

      // Check if user exists in Firestore
      final userExists = await _checkUserExists(phoneNumber);

      if (userExists) {
        // Send in-app notification and create booking
        await _createBookingForExistingUser(
            phoneNumber, customerName, date, time, bookingCode,);
        _showSuccessDialog('In-app notification sent to existing user');
      } else {
        // Open WhatsApp with download link and booking code
        await _openWhatsApp(phoneNumber, customerName, date, time, bookingCode);
      }

      // Save booking request to Firestore
      await _saveBookingRequest(
          customerName, phoneNumber, date, time, bookingCode,);
    } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
    
    // Always reset processing state
    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }

  Future<bool> _checkUserExists(String phoneNumber) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      // If error, assume user doesn't exist and proceed with WhatsApp
      return false;
    }
  }

  Future<void> _createBookingForExistingUser(
      final String phoneNumber,
      final String customerName,
      final String date,
      final String time,
      String bookingCode,) async {
    // TODO(username): Implement push notification via FCM and create booking record
    // Creating booking for existing user: $phoneNumber, $customerName, $date, $time, $bookingCode
  }

  Future<void> _openWhatsApp(
      final String phoneNumber,
      final String customerName,
      final String date,
      final String time,
      String bookingCode,) async {
    final message = '''
Hi $customerName!

You've been invited to book a session with us.

Date: $date
Time: $time
Booking Code: $bookingCode

Download our app: https://appoint.app/download

We'll see you soon!
    '''
        .trim();

    final url =
        'https://wa.me/1$phoneNumber?text=${Uri.encodeComponent(message)}';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw Exception('Could not launch WhatsApp');
    }
  }

  Future<void> _saveBookingRequest(
      final String customerName,
      final String phoneNumber,
      final String date,
      final String time,
      String bookingCode,) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await FirebaseFirestore.instance.collection('booking_requests').add({
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'date': date,
      'time': time,
      'bookingCode': bookingCode,
      'businessProfileId': user.uid,
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  String _generateBookingCode() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'BK$random';
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
