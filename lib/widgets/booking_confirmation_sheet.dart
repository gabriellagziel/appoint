import 'package:flutter/material.dart';

class BookingConfirmationSheet extends StatelessWidget {

  const BookingConfirmationSheet({
    required this.onConfirm,
    required this.onCancel,
    required this.summaryText,
    super.key,
  });
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String summaryText;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Confirm Appointment',
              style: Theme.of(context).textTheme.titleLarge,),
          const SizedBox(height: 12),
          Text(summaryText),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCancel,
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
}
