import 'package:flutter/material.dart';

class ParticipantList extends StatelessWidget {
  final List<Map<String, dynamic>> participants;
  const ParticipantList({super.key, required this.participants});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: participants.map((p) {
          final name = p['name'] ?? p['userId'] ?? 'User';
          final status = p['status'] ?? 'pending';
          final arrived = p['arrived'] == true;
          final isLate = p['isLate'] == true;
          final lateReason = p['lateReason'];

          return ListTile(
            leading: CircleAvatar(
                child: Text(name.toString().substring(0, 1).toUpperCase())),
            title: Row(
              children: [
                Expanded(child: Text(name)),
                if (isLate)
                  const Icon(Icons.schedule, color: Colors.orange, size: 16),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status: $status'),
                if (isLate && lateReason != null && lateReason.isNotEmpty)
                  Text('Late: $lateReason',
                      style:
                          const TextStyle(color: Colors.orange, fontSize: 12)),
              ],
            ),
            trailing: arrived
                ? const Icon(Icons.check_circle, color: Colors.green)
                : isLate
                    ? const Icon(Icons.schedule, color: Colors.orange)
                    : const SizedBox(),
          );
        }).toList(),
      ),
    );
  }
}







