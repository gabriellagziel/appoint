import 'package:flutter/material.dart';
import 'package:appoint/features/event_forms/models/form_field_def.dart';

class FormLogicRulesEditor extends StatefulWidget {
  final List<FormFieldDef> fields;
  final Function(String, Map<String, dynamic>) onRulesChanged;

  const FormLogicRulesEditor({
    super.key,
    required this.fields,
    required this.onRulesChanged,
  });

  @override
  State<FormLogicRulesEditor> createState() => _FormLogicRulesEditorState();
}

class _FormLogicRulesEditorState extends State<FormLogicRulesEditor> {
  String? _selectedFieldId;
  String? _conditionFieldId;
  String _operator = 'equals';
  String _conditionValue = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conditional Logic',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),

          // Field selector
          DropdownButtonFormField<String>(
            value: _selectedFieldId,
            decoration: const InputDecoration(
              labelText: 'Select Field',
              border: OutlineInputBorder(),
            ),
            items: widget.fields.map((field) {
              return DropdownMenuItem(
                value: field.id,
                child: Text(field.label),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedFieldId = value;
              });
            },
          ),

          if (_selectedFieldId != null) ...[
            const SizedBox(height: 16),

            // Condition field selector
            DropdownButtonFormField<String>(
              value: _conditionFieldId,
              decoration: const InputDecoration(
                labelText: 'Show when this field',
                border: OutlineInputBorder(),
              ),
              items: widget.fields
                  .where((field) => field.id != _selectedFieldId)
                  .map((field) {
                return DropdownMenuItem(
                  value: field.id,
                  child: Text(field.label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _conditionFieldId = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // Operator selector
            DropdownButtonFormField<String>(
              value: _operator,
              decoration: const InputDecoration(
                labelText: 'Operator',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'equals', child: Text('Equals')),
                DropdownMenuItem(
                    value: 'not_equals', child: Text('Not Equals')),
                DropdownMenuItem(value: 'contains', child: Text('Contains')),
                DropdownMenuItem(
                    value: 'greater_than', child: Text('Greater Than')),
                DropdownMenuItem(value: 'less_than', child: Text('Less Than')),
              ],
              onChanged: (value) {
                setState(() {
                  _operator = value!;
                });
              },
            ),

            const SizedBox(height: 16),

            // Value input
            TextField(
              decoration: const InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _conditionValue = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _canSaveCondition() ? _saveCondition : null,
                    child: const Text('Save Condition'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearCondition,
                    child: const Text('Clear'),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),

          // Current conditions display
          Text(
            'Current Conditions',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          _buildConditionsList(),
        ],
      ),
    );
  }

  Widget _buildConditionsList() {
    final fieldsWithConditions =
        widget.fields.where((field) => field.visibleIf != null).toList();

    if (fieldsWithConditions.isEmpty) {
      return Text(
        'No conditional logic set',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
      );
    }

    return Column(
      children: fieldsWithConditions.map((field) {
        final condition = field.visibleIf!;
        final conditionField = widget.fields.firstWhere(
          (f) => f.id == condition['fieldId'],
          orElse: () => field,
        );

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(field.label),
            subtitle: Text(
              'Shown when "${conditionField.label}" ${_getOperatorText(condition['operator'])} "${condition['value']}"',
            ),
            trailing: IconButton(
              onPressed: () => _removeCondition(field.id),
              icon: const Icon(Icons.delete, size: 18),
              color: Colors.red[600],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getOperatorText(String? operator) {
    switch (operator) {
      case 'equals':
        return 'equals';
      case 'not_equals':
        return 'does not equal';
      case 'contains':
        return 'contains';
      case 'greater_than':
        return 'is greater than';
      case 'less_than':
        return 'is less than';
      default:
        return 'equals';
    }
  }

  bool _canSaveCondition() {
    return _selectedFieldId != null &&
        _conditionFieldId != null &&
        _conditionValue.isNotEmpty;
  }

  void _saveCondition() {
    if (!_canSaveCondition()) return;

    final condition = {
      'fieldId': _conditionFieldId,
      'operator': _operator,
      'value': _conditionValue,
    };

    widget.onRulesChanged(_selectedFieldId!, condition);

    setState(() {
      _selectedFieldId = null;
      _conditionFieldId = null;
      _conditionValue = '';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Condition saved')),
    );
  }

  void _clearCondition() {
    setState(() {
      _selectedFieldId = null;
      _conditionFieldId = null;
      _conditionValue = '';
    });
  }

  void _removeCondition(String fieldId) {
    widget.onRulesChanged(fieldId, {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Condition removed')),
    );
  }
}
