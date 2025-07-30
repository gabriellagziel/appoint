import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusinessDashboardScreen extends StatelessWidget {
  const BusinessDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome, Business Owner!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text('📅 Bookings'),
              const SizedBox(height: 10),
              const BookingTableWidget(),
              const Divider(),
              const Text('🧑 Staff Availability'),
              const SizedBox(height: 10),
              const StaffAvailabilityWidget(),
              const Divider(),
              const Text('📊 Stats & Analytics'),
              const Divider(),
              const Text('⚙️ Settings'),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingTableWidget extends StatelessWidget {
  const BookingTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .orderBy('dateTime')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text('Error loading bookings');
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final bookings = snapshot.data!.docs;

        if (bookings.isEmpty) return const Text('No bookings yet');

        return DataTable(
          columns: const [
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Notes')),
          ],
          rows: bookings.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final date =
                DateTime.tryParse(data['dateTime'] ?? '') ?? DateTime.now();
            final notes = data['notes'] ?? '';
            return DataRow(cells: [
              DataCell(Text(date.toLocal().toString())),
              DataCell(Text(notes)),
            ]);
          }).toList(),
        );
      },
    );
  }
}

class StaffAvailabilityWidget extends StatelessWidget {
  const StaffAvailabilityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('staff_availability')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text('Error loading availability');
        if (!snapshot.hasData) return const CircularProgressIndicator();

        final staff = snapshot.data!.docs;

        if (staff.isEmpty) return const Text('No staff availability found');

        return Column(
          children: staff.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final staffId = data['staffId'] ?? 'Unknown';
            final date =
                DateTime.tryParse(data['date'] ?? '') ?? DateTime.now();
            final slots = (data['availableSlots'] as List<dynamic>? ?? [])
                .map((e) => e.toString())
                .join(', ');
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                title: Text(
                    '$staffId – ${date.toLocal().toString().split(' ')[0]}'),
                subtitle: Text('Slots: $slots'),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
