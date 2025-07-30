import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/models/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormBuilder extends StatefulWidget {
  const FormBuilder({
    required this.onFieldsChanged,
    super.key,
    this.initialFields = const [],
  });
  final List<CustomFormField> initialFields;
  final ValueChanged<List<CustomFormField>> onFieldsChanged;

  @override
  State<FormBuilder> createState() => _FormBuilderState();
}

class _FormBuilderState extends State<FormBuilder> {
  late List<CustomFormField> _fields;
  int _nextOrder = 0;

  @override
  void initState() {
    super.initState();
    _fields = List.from(widget.initialFields);
    _nextOrder = _fields.isEmpty
        ? 0
        : _fields.map((f) => f.order).reduce((a, b) => a > b ? a : b) + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Form Fields',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ElevatedButton.icon(
              onPressed: _addNewField,
              icon: const Icon(Icons.add),
              label: const Text('Add Field'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_fields.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.dynamic_form,
                  size: 48,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No form fields yet',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add form fields to collect information from your users',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: _reorderFields,
            itemCount: _fields.length,
            itemBuilder: (context, index) {
              final field = _fields[index];
              return _buildFieldCard(field, index);
            },
          ),
        const SizedBox(height: 16),
        if (_fields.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.blue.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Preview your form fields below',
                    style: TextStyle(color: Colors.blue.shade700),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFieldCard(CustomFormField field, int index) {
    return Card(
      key: ValueKey(field.id),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getFieldIcon(field.type), color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              field.label,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (field.required)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Required',
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getFieldTypeDisplayName(field.type),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _editField(field, index),
                      icon: const Icon(Icons.edit, size: 20),
                      tooltip: 'Edit Field',
                    ),
                    IconButton(
                      onPressed: () => _deleteField(index),
                      icon: const Icon(Icons.delete, size: 20),
                      tooltip: 'Delete Field',
                    ),
                    const Icon(Icons.drag_handle, color: Colors.grey),
                  ],
                ),
              ],
            ),
            if (field.description != null) ...[
              const SizedBox(height: 8),
              Text(
                field.description!,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
            const SizedBox(height: 12),
            _buildFieldPreview(field),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldPreview(CustomFormField field) {
    switch (field.type) {
      case CustomFormFieldType.text:
      case CustomFormFieldType.email:
      case CustomFormFieldType.phone:
        return TextFormField(
          enabled: false,
          decoration: InputDecoration(
            labelText: field.label,
            hintText: field.placeholder ?? 'Enter text',
            border: const OutlineInputBorder(),
          ),
        );

      case CustomFormFieldType.textarea:
        return TextFormField(
          enabled: false,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: field.label,
            hintText: field.placeholder ?? 'Enter text',
            border: const OutlineInputBorder(),
          ),
        );

      case CustomFormFieldType.number:
        return TextFormField(
          enabled: false,
          decoration: InputDecoration(
            labelText: field.label,
            hintText: 'Enter number',
            border: const OutlineInputBorder(),
            suffixText: field.minValue != null && field.maxValue != null
                ? '${field.minValue}-${field.maxValue}'
                : null,
          ),
        );

      case CustomFormFieldType.choice:
        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: field.label,
            border: const OutlineInputBorder(),
          ),
          items: field.options
              ?.map(
                (option) => DropdownMenuItem(
                  value: option,
                  child: Text(option),
                ),
              )
              .toList(),
          onChanged: null,
        );

      case CustomFormFieldType.multiselect:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(field.label),
            const SizedBox(height: 8),
            ...?field.options?.map(
              (option) => CheckboxListTile(
                title: Text(option),
                value: false,
                onChanged: null,
                dense: true,
              ),
            ),
          ],
        );

      case CustomFormFieldType.boolean:
        return CheckboxListTile(
          title: Text(field.label),
          value: false,
          onChanged: null,
        );

      case CustomFormFieldType.rating:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(field.label),
            const SizedBox(height: 8),
            Row(
              children: List.generate(
                field.maxValue ?? 5,
                (index) => const Icon(
                  Icons.star_border,
                  color: Colors.amber,
                  size: 32,
                ),
              ),
            ),
          ],
        );

      case CustomFormFieldType.date:
        return TextFormField(
          enabled: false,
          decoration: InputDecoration(
            labelText: field.label,
            hintText: 'Select date',
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
        );

      case CustomFormFieldType.time:
        return TextFormField(
          enabled: false,
          decoration: InputDecoration(
            labelText: field.label,
            hintText: 'Select time',
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.access_time),
          ),
        );

      case CustomFormFieldType.datetime:
        return TextFormField(
          enabled: false,
          decoration: InputDecoration(
            labelText: field.label,
            hintText: 'Select date and time',
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.event),
          ),
        );
    }
  }

  IconData _getFieldIcon(CustomFormFieldType type) {
    switch (type) {
      case CustomFormFieldType.text:
      case CustomFormFieldType.textarea:
        return Icons.text_fields;
      case CustomFormFieldType.number:
        return Icons.numbers;
      case CustomFormFieldType.email:
        return Icons.email;
      case CustomFormFieldType.phone:
        return Icons.phone;
      case CustomFormFieldType.choice:
        return Icons.radio_button_checked;
      case CustomFormFieldType.multiselect:
        return Icons.check_box;
      case CustomFormFieldType.date:
        return Icons.calendar_today;
      case CustomFormFieldType.time:
        return Icons.access_time;
      case CustomFormFieldType.datetime:
        return Icons.event;
      case CustomFormFieldType.boolean:
        return Icons.toggle_on;
      case CustomFormFieldType.rating:
        return Icons.star;
    }
  }

  String _getFieldTypeDisplayName(CustomFormFieldType type) {
    switch (type) {
      case CustomFormFieldType.text:
        return 'Text Field';
      case CustomFormFieldType.textarea:
        return 'Text Area Field';
      case CustomFormFieldType.number:
        return 'Number Field';
      case CustomFormFieldType.email:
        return 'Email Field';
      case CustomFormFieldType.phone:
        return 'Phone Field';
      case CustomFormFieldType.choice:
        return 'Choice Field';
      case CustomFormFieldType.multiselect:
        return 'Multi-select Field';
      case CustomFormFieldType.date:
        return 'Date Field';
      case CustomFormFieldType.time:
        return 'Time Field';
      case CustomFormFieldType.datetime:
        return 'Date & Time Field';
      case CustomFormFieldType.boolean:
        return 'Boolean Field';
      case CustomFormFieldType.rating:
        return 'Rating Field';
    }
  }

  void _addNewField() {
    _showFieldEditor(null, -1);
  }

  void _editField(CustomFormField field, int index) {
    _showFieldEditor(field, index);
  }

  void _deleteField(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Field'),
        content: const Text('Are you sure you want to delete this field?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _fields.removeAt(index);
                _updateFieldsOrder();
                widget.onFieldsChanged(_fields);
              });
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _reorderFields(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final field = _fields.removeAt(oldIndex);
      _fields.insert(newIndex, field);
      _updateFieldsOrder();
      widget.onFieldsChanged(_fields);
    });
  }

  void _updateFieldsOrder() {
    for (var i = 0; i < _fields.length; i++) {
      _fields[i] = _fields[i].copyWith(order: i);
    }
  }

  void _showFieldEditor(CustomFormField? field, int index) {
    showDialog(
      context: context,
      builder: (context) => FieldEditorDialog(
        field: field,
        onSave: (newField) {
          setState(() {
            if (index >= 0) {
              _fields[index] = newField;
            } else {
              final fieldWithOrder = newField.copyWith(order: _nextOrder++);
              _fields.add(fieldWithOrder);
            }
            widget.onFieldsChanged(_fields);
          });
        },
      ),
    );
  }
}

class FieldEditorDialog extends StatefulWidget {
  const FieldEditorDialog({
    required this.onSave,
    super.key,
    this.field,
  });
  final CustomFormField? field;
  final ValueChanged<CustomFormField> onSave;

  @override
  State<FieldEditorDialog> createState() => _FieldEditorDialogState();
}

class _FieldEditorDialogState extends State<FieldEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _placeholderController = TextEditingController();
  final _defaultValueController = TextEditingController();
  final _minValueController = TextEditingController();
  final _maxValueController = TextEditingController();
  final _minLengthController = TextEditingController();
  final _maxLengthController = TextEditingController();
  final _validationPatternController = TextEditingController();
  final _validationMessageController = TextEditingController();

  CustomFormFieldType _selectedType = CustomFormFieldType.text;
  bool _isRequired = false;
  List<String> _options = [];
  final _optionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.field != null) {
      final field = widget.field!;
      _labelController.text = field.label;
      _descriptionController.text = field.description ?? '';
      _placeholderController.text = field.placeholder ?? '';
      _defaultValueController.text = field.defaultValue ?? '';
      _selectedType = field.type;
      _isRequired = field.required;
      _options = List.from(field.options ?? []);
      _minValueController.text = field.minValue?.toString() ?? '';
      _maxValueController.text = field.maxValue?.toString() ?? '';
      _minLengthController.text = field.minLength?.toString() ?? '';
      _maxLengthController.text = field.maxLength?.toString() ?? '';
      _validationPatternController.text = field.validationPattern ?? '';
      _validationMessageController.text = field.validationMessage ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(widget.field == null ? 'Add Field' : 'Edit Field'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Field Type
                DropdownButtonFormField<CustomFormFieldType>(
                  value: _selectedType,
                  decoration: InputDecoration(
                    labelText: 'Field Type',
                    border: const OutlineInputBorder(),
                  ),
                  items: CustomFormFieldType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type,
                          child: Text(_getFieldTypeDisplayName(type)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Label
                TextFormField(
                  controller: _labelController,
                  decoration: InputDecoration(
                    labelText: 'Field Label',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Field Label (Required)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                // Placeholder
                if (_selectedType == CustomFormFieldType.text ||
                    _selectedType == CustomFormFieldType.textarea ||
                    _selectedType == CustomFormFieldType.email ||
                    _selectedType == CustomFormFieldType.phone ||
                    _selectedType == CustomFormFieldType.number) ...[
                  TextFormField(
                    controller: _placeholderController,
                    decoration: InputDecoration(
                      labelText: 'Placeholder (Optional)',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Required toggle
                CheckboxListTile(
                  title: const Text('Required Field'),
                  value: _isRequired,
                  onChanged: (value) {
                    setState(() {
                      _isRequired = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Type-specific fields
                ..._buildTypeSpecificFields(l10n),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveField,
          child: const Text('Save'),
        ),
      ],
    );
  }

  List<Widget> _buildTypeSpecificFields(AppLocalizations l10n) {
    switch (_selectedType) {
      case CustomFormFieldType.choice:
      case CustomFormFieldType.multiselect:
        return [
          Text('Options', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _optionController,
                  decoration: InputDecoration(
                    labelText: 'Add Option',
                    border: const OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (_) => _addOption(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addOption,
                child: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_options.isNotEmpty)
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ListView.builder(
                itemCount: _options.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(_options[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeOption(index),
                  ),
                ),
              ),
            ),
        ];

      case CustomFormFieldType.number:
      case CustomFormFieldType.rating:
        return [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _minValueController,
                  decoration: InputDecoration(
                    labelText: 'Minimum Value',
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _maxValueController,
                  decoration: InputDecoration(
                    labelText: 'Maximum Value',
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
        ];

      case CustomFormFieldType.text:
      case CustomFormFieldType.textarea:
        return [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _minLengthController,
                  decoration: InputDecoration(
                    labelText: 'Minimum Length',
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _maxLengthController,
                  decoration: InputDecoration(
                    labelText: 'Maximum Length',
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _validationPatternController,
            decoration: InputDecoration(
              labelText: 'Validation Pattern (Optional)',
              border: const OutlineInputBorder(),
              hintText: 'RegEx pattern',
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _validationMessageController,
            decoration: InputDecoration(
              labelText: 'Validation Message (Optional)',
              border: const OutlineInputBorder(),
            ),
          ),
        ];

      default:
        return [];
    }
  }

  void _addOption() {
    final option = _optionController.text.trim();
    if (option.isNotEmpty && !_options.contains(option)) {
      setState(() {
        _options.add(option);
        _optionController.clear();
      });
    }
  }

  void _removeOption(int index) {
    setState(() {
      _options.removeAt(index);
    });
  }

  String _getFieldTypeDisplayName(CustomFormFieldType type) {
    switch (type) {
      case CustomFormFieldType.text:
        return 'Text Field';
      case CustomFormFieldType.textarea:
        return 'Text Area Field';
      case CustomFormFieldType.number:
        return 'Number Field';
      case CustomFormFieldType.email:
        return 'Email Field';
      case CustomFormFieldType.phone:
        return 'Phone Field';
      case CustomFormFieldType.choice:
        return 'Choice Field';
      case CustomFormFieldType.multiselect:
        return 'Multi-select Field';
      case CustomFormFieldType.date:
        return 'Date Field';
      case CustomFormFieldType.time:
        return 'Time Field';
      case CustomFormFieldType.datetime:
        return 'Date & Time Field';
      case CustomFormFieldType.boolean:
        return 'Boolean Field';
      case CustomFormFieldType.rating:
        return 'Rating Field';
    }
  }

  void _saveField() {
    if (!_formKey.currentState!.validate()) return;

    // Validate options for choice/multiselect fields
    if ((_selectedType == CustomFormFieldType.choice ||
            _selectedType == CustomFormFieldType.multiselect) &&
        _options.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Options are required for choice fields')),
      );
      return;
    }

    final field = CustomFormField(
      id: widget.field?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: _selectedType,
      label: _labelController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      placeholder: _placeholderController.text.trim().isEmpty
          ? null
          : _placeholderController.text.trim(),
      defaultValue: _defaultValueController.text.trim().isEmpty
          ? null
          : _defaultValueController.text.trim(),
      required: _isRequired,
      order: widget.field?.order ?? 0,
      options: _options.isEmpty ? null : _options,
      minValue: _minValueController.text.trim().isEmpty
          ? null
          : int.tryParse(_minValueController.text.trim()),
      maxValue: _maxValueController.text.trim().isEmpty
          ? null
          : int.tryParse(_maxValueController.text.trim()),
      minLength: _minLengthController.text.trim().isEmpty
          ? null
          : int.tryParse(_minLengthController.text.trim()),
      maxLength: _maxLengthController.text.trim().isEmpty
          ? null
          : int.tryParse(_maxLengthController.text.trim()),
      validationPattern: _validationPatternController.text.trim().isEmpty
          ? null
          : _validationPatternController.text.trim(),
      validationMessage: _validationMessageController.text.trim().isEmpty
          ? null
          : _validationMessageController.text.trim(),
    );

    widget.onSave(field);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _labelController.dispose();
    _descriptionController.dispose();
    _placeholderController.dispose();
    _defaultValueController.dispose();
    _minValueController.dispose();
    _maxValueController.dispose();
    _minLengthController.dispose();
    _maxLengthController.dispose();
    _validationPatternController.dispose();
    _validationMessageController.dispose();
    _optionController.dispose();
    super.dispose();
  }
}
