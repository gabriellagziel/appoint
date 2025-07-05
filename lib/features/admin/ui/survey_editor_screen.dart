import 'package:flutter/material.dart';

/// Basic survey editor allowing admins to create and reorder questions.
class SurveyEditorScreen extends StatefulWidget {
  const SurveyEditorScreen({super.key});

  @override
  State<SurveyEditorScreen> createState() => _SurveyEditorScreenState();
}

class _SurveyEditorScreenState extends State<SurveyEditorScreen> {
  final List<_QuestionItem> _questions = [];

  @override
  void dispose() {
    for (final q in _questions) {
      q.controller.dispose();
    }
    super.dispose();
  }

  void _addQuestion() {
    setState(() {
      _questions.add(_QuestionItem());
    });
  }

  void _removeQuestion(final int index) {
    setState(() {
      _questions[index].controller.dispose();
      _questions.removeAt(index);
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey Editor'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_questions.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No questions added')),
            ),
          ..._questions.asMap().entries.map(
                (final entry) => _buildQuestionCard(entry.key, entry.value),
              ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _addQuestion,
            icon: const Icon(Icons.add),
            label: const Text('Add Question'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(final int index, final _QuestionItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: item.controller,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: item.type,
              items: const [
                DropdownMenuItem(value: 'text', child: Text('Text')),
                DropdownMenuItem(
                    value: 'multiple', child: Text('Multiple Choice')),
                DropdownMenuItem(value: 'rating', child: Text('Rating')),
              ],
              onChanged: (final val) =>
                  setState(() => item.type = val ?? 'text'),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeQuestion(index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionItem {
  final TextEditingController controller = TextEditingController();
  String type = 'text';
}
