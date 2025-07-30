import 'package:flutter/material.dart';

/// Screen listing survey responses with the ability to view details.
class SurveyResponsesScreen extends StatelessWidget {
  const SurveyResponsesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responses = _dummyResponses;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Responses'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: responses.length,
        itemBuilder: (context, final index) {
          final r = responses[index];
          return Card(
            child: ListTile(
              title: Text('Response #${index + 1}'),
              subtitle: Text('Submitted by: ${r['user']}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SurveyResponseDetailScreen(response: r),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class SurveyResponseDetailScreen extends StatelessWidget {
  const SurveyResponseDetailScreen({required this.response, super.key});
  final Map<String, dynamic> response;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Response Detail'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User: ${response['user']}'),
              const SizedBox(height: 12),
              ...response['answers'].entries.map<Widget>(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('${e.key}: ${e.value}'),
                    ),
                  ),
            ],
          ),
        ),
      );
}

final List<Map<String, dynamic>> _dummyResponses = [
  {
    'user': 'alice@example.com',
    'answers': {'Q1': 'Yes', 'Q2': 'Blue', 'Q3': '5'},
  },
  {
    'user': 'bob@example.com',
    'answers': {'Q1': 'No', 'Q2': 'Green', 'Q3': '3'},
  },
];
