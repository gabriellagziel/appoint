import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not authenticated')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('analyticsData')
            .where('businessProfileId', isEqualTo: user.uid)
            .orderBy('date', descending: true)
            .limit(30)
            .snapshots(),
        builder: (context, final snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final analyticsData = snapshot.data?.docs ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KPI Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildKPICard(
                        'Total Bookings',
                        _getTotalBookings(analyticsData),
                        Icons.calendar_today,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildKPICard(
                        'Revenue',
                        '\$${_getTotalRevenue(analyticsData)}',
                        Icons.attach_money,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildKPICard(
                        'Active Clients',
                        _getActiveClients(analyticsData),
                        Icons.people,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildKPICard(
                        'Avg. Rating',
                        _getAverageRating(analyticsData),
                        Icons.star,
                        Colors.yellow,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Recent Activity
                const Text(
                  'Recent Activity',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                if (analyticsData.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No analytics data available yet.'),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: analyticsData.length,
                    itemBuilder: (context, final index) {
                      final data =
                          analyticsData[index].data()! as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getActivityColor(data['type']),
                            child: Icon(
                              _getActivityIcon(data['type']),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(data['title'] ?? 'Activity'),
                          subtitle: Text(data['description'] ?? ''),
                          trailing: Text(data['date'] ?? ''),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKPICard(final String title, final String value,
      IconData icon, final Color color,) => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );

  String _getTotalBookings(List<QueryDocumentSnapshot> data) {
    var total = 0;
    for (doc in data) {
      final analytics = doc.data()! as Map<String, dynamic>;
      if (analytics['type'] == 'booking') {
        total += (analytics['count'] ?? 0) as int;
      }
    }
    return total.toString();
  }

  String _getTotalRevenue(List<QueryDocumentSnapshot> data) {
    double total = 0;
    for (doc in data) {
      final analytics = doc.data()! as Map<String, dynamic>;
      if (analytics['type'] == 'revenue') {
        total += (analytics['amount'] ?? 0).toDouble();
      }
    }
    return total.toStringAsFixed(2);
  }

  String _getActiveClients(List<QueryDocumentSnapshot> data) {
    var total = 0;
    for (doc in data) {
      final analytics = doc.data()! as Map<String, dynamic>;
      if (analytics['type'] == 'client') {
        total += (analytics['count'] ?? 0) as int;
      }
    }
    return total.toString();
  }

  String _getAverageRating(List<QueryDocumentSnapshot> data) {
    double total = 0;
    var count = 0;
    for (doc in data) {
      final analytics = doc.data()! as Map<String, dynamic>;
      if (analytics['type'] == 'rating') {
        total += (analytics['rating'] ?? 0).toDouble();
        count++;
      }
    }
    return count > 0 ? (total / count).toStringAsFixed(1) : '0.0';
  }

  Color _getActivityColor(String? type) {
    switch (type) {
      case 'booking':
        return Colors.blue;
      case 'revenue':
        return Colors.green;
      case 'client':
        return Colors.orange;
      case 'rating':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

  IconData _getActivityIcon(String? type) {
    switch (type) {
      case 'booking':
        return Icons.calendar_today;
      case 'revenue':
        return Icons.attach_money;
      case 'client':
        return Icons.people;
      case 'rating':
        return Icons.star;
      default:
        return Icons.info;
    }
  }
}
