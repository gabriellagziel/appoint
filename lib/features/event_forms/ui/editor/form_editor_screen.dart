import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/event_forms/models/meeting_form.dart';
import 'package:appoint/features/event_forms/models/form_field_def.dart';
import 'package:appoint/features/event_forms/providers/form_providers.dart';
import 'package:appoint/features/event_forms/ui/editor/form_field_palette.dart';
import 'package:appoint/features/event_forms/ui/editor/form_field_tile.dart';
import 'package:appoint/features/event_forms/ui/editor/form_validation_editor.dart';
import 'package:appoint/features/event_forms/ui/editor/form_logic_rules_editor.dart';

class FormEditorScreen extends ConsumerStatefulWidget {
  final String meetingId;
  final String? formId; // null for new form

  const FormEditorScreen({
    super.key,
    required this.meetingId,
    this.formId,
  });

  @override
  ConsumerState<FormEditorScreen> createState() => _FormEditorScreenState();
}

class _FormEditorScreenState extends ConsumerState<FormEditorScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isRequiredForAccept = false;
  bool _isActive = false;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadFormData() async {
    if (widget.formId != null) {
      // Load existing form
      final formAsync = ref.read(activeFormProvider(widget.meetingId));
      final form = await formAsync.value;

      if (form != null) {
        _titleController.text = form.title;
        _descriptionController.text = form.description ?? '';
        _isRequiredForAccept = form.requiredForAccept;
        _isActive = form.active;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formWithFieldsAsync =
        ref.watch(activeFormWithFieldsProvider(widget.meetingId));

    return Scaffold(
      appBar: _buildAppBar(),
      body: Row(
        children: [
          // Left panel - Field palette
          SizedBox(
            width: 280,
            child: FormFieldPalette(
              onFieldSelected: _addField,
            ),
          ),

          // Center panel - Form canvas
          Expanded(
            child: _buildFormCanvas(formWithFieldsAsync),
          ),

          // Right panel - Inspector
          SizedBox(
            width: 320,
            child: _buildInspector(formWithFieldsAsync),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: TextField(
        controller: _titleController,
        style: Theme.of(context).textTheme.headlineSmall,
        decoration: const InputDecoration(
          hintText: 'Form Title',
          border: InputBorder.none,
        ),
        onChanged: (_) => _markUnsavedChanges(),
      ),
      actions: [
        // Status indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _isActive ? Colors.green : Colors.orange,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _isActive ? 'Active' : 'Draft',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        const SizedBox(width: 16),

        // Save button
        TextButton(
          onPressed: _hasUnsavedChanges ? _saveForm : null,
          child: const Text('Save'),
        ),

        // Publish button
        ElevatedButton(
          onPressed: _canPublish() ? _publishForm : null,
          child: const Text('Publish'),
        ),

        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildFormCanvas(
      AsyncValue<Map<String, dynamic>> formWithFieldsAsync) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          left: BorderSide(color: Theme.of(context).dividerColor),
          right: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: formWithFieldsAsync.when(
        data: (data) {
          final form = data['form'] as MeetingForm?;
          final fields = data['fields'] as List<FormFieldDef>? ?? [];

          if (form == null) {
            return _buildEmptyState();
          }

          return Column(
            children: [
              // Form metadata
              _buildFormMetadata(form),

              // Fields list
              Expanded(
                child: _buildFieldsList(fields),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(error),
      ),
    );
  }

  Widget _buildFormMetadata(MeetingForm form) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            form.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (form.description?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(
              form.description!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                '${form.requiredForAccept ? "Required" : "Optional"} for RSVP acceptance',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldsList(List<FormFieldDef> fields) {
    if (fields.isEmpty) {
      return _buildEmptyFieldsState();
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: fields.length,
      onReorder: (oldIndex, newIndex) {
        _reorderFields(fields, oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final field = fields[index];
        return FormFieldTile(
          key: ValueKey(field.id),
          field: field,
          onEdit: () => _editField(field),
          onDuplicate: () => _duplicateField(field),
          onDelete: () => _deleteField(field),
          onSelect: () => _selectField(field),
        );
      },
    );
  }

  Widget _buildInspector(AsyncValue<Map<String, dynamic>> formWithFieldsAsync) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: formWithFieldsAsync.when(
        data: (data) {
          final form = data['form'] as MeetingForm?;
          final fields = data['fields'] as List<FormFieldDef>? ?? [];

          if (form == null) {
            return _buildEmptyInspector();
          }

          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                // Tab bar
                Container(
                  color: Colors.grey[100],
                  child: const TabBar(
                    tabs: [
                      Tab(text: 'Form'),
                      Tab(text: 'Field'),
                      Tab(text: 'Logic'),
                    ],
                  ),
                ),

                // Tab content
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildFormInspector(form),
                      _buildFieldInspector(fields),
                      _buildLogicInspector(fields),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(error),
      ),
    );
  }

  Widget _buildFormInspector(MeetingForm form) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Form Settings',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),

          // Title
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Form Title',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _markUnsavedChanges(),
          ),
          const SizedBox(height: 16),

          // Description
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _markUnsavedChanges(),
          ),
          const SizedBox(height: 16),

          // Required for RSVP
          SwitchListTile(
            title: const Text('Required for RSVP'),
            subtitle: const Text(
                'Participants must complete this form before accepting'),
            value: _isRequiredForAccept,
            onChanged: (value) {
              setState(() {
                _isRequiredForAccept = value;
                _markUnsavedChanges();
              });
            },
          ),

          // Active status
          SwitchListTile(
            title: const Text('Active'),
            subtitle: const Text('Form is currently accepting responses'),
            value: _isActive,
            onChanged: (value) {
              setState(() {
                _isActive = value;
                _markUnsavedChanges();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFieldInspector(List<FormFieldDef> fields) {
    // TODO: Show selected field inspector
    return const Center(
      child: Text('Select a field to edit its properties'),
    );
  }

  Widget _buildLogicInspector(List<FormFieldDef> fields) {
    return FormLogicRulesEditor(
      fields: fields,
      onRulesChanged: _updateFieldRules,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_add,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Create Your First Form',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Drag fields from the left panel to start building your form',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFieldsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.drag_indicator,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Fields Yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Drag fields from the left panel to add them to your form',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyInspector() {
    return const Center(
      child: Text('Create a form to see inspector options'),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load form',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.red[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                ref.invalidate(activeFormWithFieldsProvider(widget.meetingId)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // Actions
  Future<void> _addField(FormFieldType type) async {
    try {
      final fieldDef = FormFieldDef(
        id: '', // Will be set by service
        formId: widget.formId ?? 'new-form',
        label: 'New ${type.displayName}',
        type: type,
        required: false,
        orderIndex: 0, // Will be set by service
      );

      await ref.read(addFieldProvider.notifier).addField(
            widget.meetingId,
            widget.formId ?? 'new-form',
            fieldDef,
          );

      _markUnsavedChanges();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added ${type.displayName} field')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add field: $e')),
        );
      }
    }
  }

  Future<void> _saveForm() async {
    try {
      // TODO: Implement form save
      setState(() {
        _hasUnsavedChanges = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save form: $e')),
        );
      }
    }
  }

  Future<void> _publishForm() async {
    try {
      await ref.read(activateFormProvider.notifier).activateForm(
            widget.meetingId,
            widget.formId ?? 'new-form',
            true,
          );

      setState(() {
        _isActive = true;
        _hasUnsavedChanges = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form published successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to publish form: $e')),
        );
      }
    }
  }

  void _markUnsavedChanges() {
    setState(() {
      _hasUnsavedChanges = true;
    });
  }

  bool _canPublish() {
    return widget.formId != null && _hasUnsavedChanges;
  }

  void _editField(FormFieldDef field) {
    // TODO: Open field editor
  }

  void _duplicateField(FormFieldDef field) {
    // TODO: Duplicate field
  }

  void _deleteField(FormFieldDef field) {
    // TODO: Delete field with confirmation
  }

  void _selectField(FormFieldDef field) {
    // TODO: Select field for inspector
  }

  void _reorderFields(List<FormFieldDef> fields, int oldIndex, int newIndex) {
    // TODO: Reorder fields
  }

  void _updateFieldRules(String fieldId, Map<String, dynamic> rules) {
    // TODO: Update field rules
  }
}
