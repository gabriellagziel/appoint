import 'package:flutter/material.dart';
import 'package:appoint/features/event_forms/models/form_field_def.dart';

class FormFieldTile extends StatelessWidget {
  final FormFieldDef field;
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;
  final VoidCallback onSelect;

  const FormFieldTile({
    super.key,
    required this.field,
    required this.onEdit,
    required this.onDuplicate,
    required this.onDelete,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onSelect,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Drag handle
              Icon(
                Icons.drag_indicator,
                color: Colors.grey[400],
                size: 20,
              ),
              const SizedBox(width: 12),

              // Field icon
              Icon(
                field.icon,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),

              // Field info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          field.label,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        if (field.required) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Required',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      field.displayName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    if (field.helpText?.isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Text(
                        field.helpText!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[500],
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, size: 18),
                    tooltip: 'Edit field',
                  ),
                  IconButton(
                    onPressed: onDuplicate,
                    icon: const Icon(Icons.copy, size: 18),
                    tooltip: 'Duplicate field',
                  ),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, size: 18),
                    tooltip: 'Delete field',
                    color: Colors.red[600],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
