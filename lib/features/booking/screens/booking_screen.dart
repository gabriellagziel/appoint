import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController notesController = TextEditingController();

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 0)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _submitBooking() async {
    if (selectedDate != null && selectedTime != null) {
      final DateTime bookingDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      final String notes = notesController.text.trim();

      final booking = Booking(dateTime: bookingDateTime, notes: notes);
      final service = BookingService();
      await service.submitBooking(booking);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking submitted')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book a Meeting')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickDate,
              child: Text(selectedDate == null
                  ? 'Select Date'
                  : 'Date: ${selectedDate!.toLocal()}'.split(' ')[0]),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _pickTime,
              child: Text(selectedTime == null
                  ? 'Select Time'
                  : 'Time: ${selectedTime!.format(context)}'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Meeting Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitBooking,
              child: const Text('Book Now'),
            ),
            const SizedBox(height: 24),
            const Expanded(child: BookingListView()),
          ],
        ),
      ),
    );
  }
}

class BookingListView extends StatelessWidget {
  const BookingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .orderBy('dateTime')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error loading bookings');
        }
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final bookings = snapshot.data!.docs;

        if (bookings.isEmpty) {
          return const Text('No bookings found');
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final data = bookings[index].data() as Map<String, dynamic>;
            final dateTime =
                DateTime.tryParse(data['dateTime'] ?? '') ?? DateTime.now();
            final notes = data['notes'] ?? '';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('\uD83D\uDCC5 ${dateTime.toLocal()}'),
                subtitle: Text(notes),
              ),
            );
          },
        );
      },
    );
  }
}
