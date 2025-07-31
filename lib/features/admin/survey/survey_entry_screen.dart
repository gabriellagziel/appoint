import 'package:appoint/features/admin/survey/survey_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyEntryScreen extends ConsumerWidget {
  const SurveyEntryScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final surveysAsync = ref.watch(surveysStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Management'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateSurveyDialog(context, ref),
            tooltip: 'Create New Survey',
          ),
        ],
      ),
      body: surveysAsync.when(
        data: (surveys) {
          if (surveys.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.quiz, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No surveys available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Create your first survey to get started',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: surveys.length,
            itemBuilder: (context, final index) {
              final survey = surveys[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.quiz, color: Colors.white),
                  ),
                  title: Text(
                    survey['title'] as String? ?? 'Untitled Survey',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(survey['description'] as String? ?? 'No description'),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.orange[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${survey['rewardPoints'] ?? 0} points',
                            style: TextStyle(
                              color: Colors.orange[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) =>
                        _handleSurveyAction(context, ref, survey['id'] as String, value),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'responses',
                        child: Row(
                          children: [
                            Icon(Icons.analytics),
                            SizedBox(width: 8),
                            Text('View Responses'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  onTap: () => _showSurveyDetails(context, survey),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, final stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading surveys: $error'),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateSurveyDialog(
    BuildContext context,
    final WidgetRef ref,
  ) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final rewardPointsController = TextEditingController(text: '10');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Survey'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Survey Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: rewardPointsController,
              decoration: const InputDecoration(
                labelText: 'Reward Points',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                ref.read(surveyNotifierProvider.notifier).createSurvey({
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'rewardPoints':
                      int.tryParse(rewardPointsController.text) ?? 10,
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _handleSurveyAction(
    final BuildContext context,
    final WidgetRef ref,
    String surveyId,
    final String action,
  ) {
    switch (action) {
      case 'edit':
        // TODO(username): Implement this featurent edit survey
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit survey - Coming soon!')),
        );
      case 'responses':
        // TODO(username): Implement this featurenses screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('View responses - Coming soon!')),
        );
      case 'delete':
        _showDeleteConfirmation(context, ref, surveyId);
    }
  }

  void _showDeleteConfirmation(
    BuildContext context,
    final WidgetRef ref,
    final String surveyId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Survey'),
        content: const Text(
          'Are you sure you want to delete this survey? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(surveyNotifierProvider.notifier).deleteSurvey(surveyId);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSurveyDetails(
    BuildContext context,
    final Map<String, dynamic> survey,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(survey['title'] as String? ?? 'Survey Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${survey['description'] ?? 'No description'}'),
            const SizedBox(height: 8),
            Text('Reward Points: ${survey['rewardPoints'] ?? 0}'),
            const SizedBox(height: 8),
            Text('Status: ${survey['status'] ?? 'Unknown'}'),
            if (survey['createdAt'] != null)
              Text('Created: ${survey['createdAt']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
