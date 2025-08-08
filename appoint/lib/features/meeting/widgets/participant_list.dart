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
          return ListTile(
            leading: CircleAvatar(
                child: Text(name.toString().substring(0, 1).toUpperCase())),
            title: Text(name),
            subtitle: Text('Status: $status'),
            trailing:
                arrived ? const Icon(Icons.check_circle) : const SizedBox(),
          );
        }).toList(),
      ),
    );
  }
}
