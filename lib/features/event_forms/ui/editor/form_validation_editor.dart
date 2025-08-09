import 'package:flutter/material.dart';
import 'package:appoint/features/event_forms/models/form_field_def.dart';

class FormValidationEditor extends StatefulWidget {
  final FormFieldDef field;
  final Function(FormFieldDef) onFieldUpdated;

  const FormValidationEditor({
    super.key,
    required this.field,
    required this.onFieldUpdated,
  });

  @override
  State<FormValidationEditor> createState() => _FormValidationEditorState();
}

class _FormValidationEditorState extends State<FormValidationEditor> {
  late TextEditingController _regexController;
  late TextEditingController _minController;
  late TextEditingController _maxController;
  late TextEditingController _customErrorController;
  bool _isRequired = false;

  @override
  void initState() {
    super.initState();
    _regexController = TextEditingController(text: widget.field.regex);
    _minController = TextEditingController(text: widget.field.min?.toString() ?? '');
    _maxController = TextEditingController(text: widget.field.max?.toString() ?? '');
    _customErrorController = TextEditingController();
    _isRequired = widget.field.required;
  }

  @override
  void dispose() {
    _regexController.dispose();
    _minController.dispose();
    _maxController.dispose();
    _customErrorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Validation Rules',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          
          // Required field
          SwitchListTile(
            title: const Text('Required'),
            subtitle: const Text('This field must be filled'),
            value: _isRequired,
            onChanged: (value) {
              setState(() {
                _isRequired = value;
              });
              _updateField();
            },
          ),
          
          const Divider(),
          
          // Type-specific validation
          _buildTypeSpecificValidation(),
          
          const Divider(),
          
          // Regex validation
          _buildRegexValidation(),
          
          const Divider(),
          
          // Min/Max validation
          _buildMinMaxValidation(),
        ],
      ),
    );
  }

  Widget _buildTypeSpecificValidation() {
    switch (widget.field.type) {
      case FormFieldType.text:
      case FormFieldType.textarea:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Text Validation',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController,
                    decoration: const InputDecoration(
                      labelText: 'Min Length',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _updateField(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _maxController,
                    decoration: const InputDecoration(
                      labelText: 'Max Length',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _updateField(),
                  ),
                ),
              ],
            ),
          ],
        );
        
      case FormFieldType.number:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Number Validation',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController,
                    decoration: const InputDecoration(
                      labelText: 'Min Value',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _updateField(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _maxController,
                    decoration: const InputDecoration(
                      labelText: 'Max Value',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _updateField(),
                  ),
                ),
              ],
            ),
          ],
        );
        
      case FormFieldType.date:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date Validation',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController,
                    decoration: const InputDecoration(
                      labelText: 'Min Days from Now',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _updateField(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _maxController,
                    decoration: const InputDecoration(
                      labelText: 'Max Days from Now',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _updateField(),
                  ),
                ),
              ],
            ),
          ],
        );
        
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildRegexValidation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pattern Validation',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _regexController,
          decoration: const InputDecoration(
            labelText: 'Regular Expression',
            hintText: 'e.g., ^[A-Za-z]+$',
            border: OutlineInputBorder(),
            helperText: 'Leave empty for no pattern validation',
          ),
          onChanged: (_) => _updateField(),
        ),
        const SizedBox(height: 8),
        Text(
          'Common patterns: Email, Phone, etc.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMinMaxValidation() {
    if (widget.field.type == FormFieldType.text || 
        widget.field.type == FormFieldType.textarea ||
        widget.field.type == FormFieldType.number ||
        widget.field.type == FormFieldType.date) {
      return const SizedBox.shrink(); // Already handled above
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Range Validation',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _minController,
                decoration: const InputDecoration(
                  labelText: 'Min',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _updateField(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _maxController,
                decoration: const InputDecoration(
                  labelText: 'Max',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (_) => _updateField(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _updateField() {
    final updatedField = widget.field.copyWith(
      required: _isRequired,
      regex: _regexController.text.isEmpty ? null : _regexController.text,
      min: _minController.text.isEmpty ? null : int.tryParse(_minController.text),
      max: _maxController.text.isEmpty ? null : int.tryParse(_maxController.text),
    );
    
    widget.onFieldUpdated(updatedField);
  }
}
