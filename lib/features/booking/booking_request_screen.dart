import 'dart:core';
import 'package:flutter/material.dart';

class BookingRequestArgs {
  final String inviteeId;
  final DateTime? scheduledAt;
  final bool openCall;

  BookingRequestArgs({
    required this.inviteeId,
    this.scheduledAt,
    required this.openCall,
  });
}

class BookingRequestScreen extends StatefulWidget {
  const BookingRequestScreen({Key? key}) : super(key: key);

  @override
  State<BookingRequestScreen> createState() => _BookingRequestScreenState();
}

class _BookingRequestScreenState extends State<BookingRequestScreen> {
  DateTime? _selectedDateTime;
  bool _openCall = false;
  final TextEditingController _inviteeController = TextEditingController();

  @override
  void dispose() {
    _inviteeController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    setState(() {
      _selectedDateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Booking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _inviteeController,
              decoration: const InputDecoration(labelText: 'Invitee ID'),
            ),
            SwitchListTile(
              title: const Text('Request Open Call'),
              value: _openCall,
              onChanged: (v) => setState(() => _openCall = v),
            ),
            if (!_openCall)
              ListTile(
                title: Text(_selectedDateTime == null
                    ? 'Pick Date & Time'
                    : _selectedDateTime.toString()),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDateTime,
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final args = BookingRequestArgs(
                  inviteeId: _inviteeController.text,
                  scheduledAt: _selectedDateTime,
                  openCall: _openCall,
                );
                Navigator.pushNamed(context, '/booking/confirm',
                    arguments: args);
              },
              child: const Text('Next'),
            )
          ],
        ),
      ),
    );
  }
}
