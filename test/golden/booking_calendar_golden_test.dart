import 'package:appoint/widgets/calendar/tablet_calendar_overflow_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Demo widget for BookingCalendar golden test
class BookingCalendarDemo extends StatelessWidget {
  const BookingCalendarDemo({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Booking Calendar'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Available Time',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ResponsiveCalendarGrid(
                    children: [
                      _buildTimeSlot('9:00 AM', true),
                      _buildTimeSlot('9:30 AM', true),
                      _buildTimeSlot('10:00 AM', false),
                      _buildTimeSlot('10:30 AM', true),
                      _buildTimeSlot('11:00 AM', true),
                      _buildTimeSlot('11:30 AM', false),
                      _buildTimeSlot('12:00 PM', true),
                      _buildTimeSlot('12:30 PM', true),
                      _buildTimeSlot('1:00 PM', false),
                      _buildTimeSlot('1:30 PM', true),
                      _buildTimeSlot('2:00 PM', true),
                      _buildTimeSlot('2:30 PM', true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildTimeSlot(String time, bool isAvailable) => Card(
        color: isAvailable ? Colors.blue[50] : Colors.grey[200],
        child: InkWell(
          onTap: isAvailable ? () {} : null,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isAvailable ? Icons.access_time : Icons.block,
                  color: isAvailable ? Colors.blue : Colors.grey,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isAvailable ? Colors.blue[800] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isAvailable ? 'Available' : 'Booked',
                  style: TextStyle(
                    fontSize: 12,
                    color: isAvailable ? Colors.green[600] : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

void main() {
  testWidgets('BookingCalendar matches golden', (tester) async {
    await tester.pumpWidget(const BookingCalendarDemo());
    await expectLater(
      find.byType(BookingCalendarDemo),
      matchesGoldenFile('goldens/booking_calendar.png'),
    );
  });
}
