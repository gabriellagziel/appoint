import 'package:flutter/material.dart';
import 'package:appoint/features/event_forms/models/form_field_def.dart';

class FormFieldPalette extends StatelessWidget {
  final Function(FormFieldType) onFieldSelected;

  const FormFieldPalette({
    super.key,
    required this.onFieldSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.widgets),
                const SizedBox(width: 8),
                Text(
                  'Field Types',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),

          // Field types list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                _buildFieldTypeCard(context, FormFieldType.text, 'Text Input',
                    'Single line text'),
                _buildFieldTypeCard(context, FormFieldType.textarea,
                    'Text Area', 'Multi-line text'),
                _buildFieldTypeCard(
                    context, FormFieldType.number, 'Number', 'Numeric input'),
                _buildFieldTypeCard(
                    context, FormFieldType.date, 'Date', 'Date picker'),
                _buildFieldTypeCard(context, FormFieldType.dropdown, 'Dropdown',
                    'Single choice'),
                _buildFieldTypeCard(context, FormFieldType.multiselect,
                    'Multi-Select', 'Multiple choices'),
                _buildFieldTypeCard(context, FormFieldType.checkbox, 'Checkbox',
                    'Yes/No question'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldTypeCard(
    BuildContext context,
    FormFieldType type,
    String title,
    String description,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => onFieldSelected(type),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  _getFieldIcon(type),
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),

              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),

              // Drag handle
              Icon(
                Icons.drag_indicator,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getFieldIcon(FormFieldType type) {
    switch (type) {
      case FormFieldType.text:
        return Icons.text_fields;
      case FormFieldType.textarea:
        return Icons.subject;
      case FormFieldType.number:
        return Icons.numbers;
      case FormFieldType.date:
        return Icons.calendar_today;
      case FormFieldType.dropdown:
        return Icons.arrow_drop_down;
      case FormFieldType.multiselect:
        return Icons.checklist;
      case FormFieldType.checkbox:
        return Icons.check_box;
    }
  }
}
