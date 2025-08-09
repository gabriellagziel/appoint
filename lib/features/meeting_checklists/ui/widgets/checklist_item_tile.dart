import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/meeting_checklist.dart';

class ChecklistItemTile extends ConsumerStatefulWidget {
  final ChecklistItem item;
  final String meetingId;
  final String listId;
  final Function(bool) onToggle;
  final Function(String) onEdit;
  final Function(String?) onAssign;
  final Function(DateTime?) onDueChange;
  final Function(ChecklistItemPriority) onPriority;
  final VoidCallback onDelete;

  const ChecklistItemTile({
    super.key,
    required this.item,
    required this.meetingId,
    required this.listId,
    required this.onToggle,
    required this.onEdit,
    required this.onAssign,
    required this.onDueChange,
    required this.onPriority,
    required this.onDelete,
  });

  @override
  ConsumerState<ChecklistItemTile> createState() => _ChecklistItemTileState();
}

class _ChecklistItemTileState extends ConsumerState<ChecklistItemTile> {
  bool isEditing = false;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.item.text);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: _buildCheckbox(),
        title: _buildTitle(),
        subtitle: _buildSubtitle(),
        trailing: _buildTrailing(),
        onTap: () => _toggleEdit(),
      ),
    );
  }

  Widget _buildCheckbox() {
    return Checkbox(
      value: widget.item.isDone,
      onChanged: (value) {
        if (value != null) {
          widget.onToggle(value);
        }
      },
      activeColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildTitle() {
    if (isEditing) {
      return TextField(
        controller: _textController,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: TextStyle(
          decoration: widget.item.isDone ? TextDecoration.lineThrough : null,
          color: widget.item.isDone ? Colors.grey : null,
        ),
        onSubmitted: (text) {
          if (text.isNotEmpty && text != widget.item.text) {
            widget.onEdit(text);
          }
          setState(() {
            isEditing = false;
          });
        },
        onEditingComplete: () {
          final text = _textController.text;
          if (text.isNotEmpty && text != widget.item.text) {
            widget.onEdit(text);
          }
          setState(() {
            isEditing = false;
          });
        },
        autofocus: true,
      );
    }

    return Text(
      widget.item.text,
      style: TextStyle(
        decoration: widget.item.isDone ? TextDecoration.lineThrough : null,
        color: widget.item.isDone ? Colors.grey : null,
      ),
    );
  }

  Widget _buildSubtitle() {
    final widgets = <Widget>[];

    // Priority chip
    widgets.add(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: widget.item.priorityColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          widget.item.priorityDisplayName,
          style: TextStyle(
            color: widget.item.priorityColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    // Due date
    if (widget.item.dueAt != null) {
      widgets.add(const SizedBox(width: 8));
      widgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.schedule,
              size: 12,
              color: widget.item.isOverdue ? Colors.red : Colors.grey[600],
            ),
            const SizedBox(width: 2),
            Text(
              _formatDate(widget.item.dueAt!),
              style: TextStyle(
                fontSize: 10,
                color: widget.item.isOverdue ? Colors.red : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // Assignee
    if (widget.item.assigneeId != null) {
      widgets.add(const SizedBox(width: 8));
      widgets.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person,
              size: 12,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 2),
            Text(
              'Assigned', // TODO: Get user name from assigneeId
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: widgets,
    );
  }

  Widget _buildTrailing() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Priority dropdown
        PopupMenuButton<ChecklistItemPriority>(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.flag,
              size: 16,
              color: widget.item.priorityColor,
            ),
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: ChecklistItemPriority.low,
              child: Text('Low Priority'),
            ),
            const PopupMenuItem(
              value: ChecklistItemPriority.medium,
              child: Text('Medium Priority'),
            ),
            const PopupMenuItem(
              value: ChecklistItemPriority.high,
              child: Text('High Priority'),
            ),
          ],
          onSelected: (priority) {
            widget.onPriority(priority);
          },
        ),

        // More options
        PopupMenuButton<String>(
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.more_vert, size: 16),
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'assign',
              child: Text('Assign'),
            ),
            const PopupMenuItem(
              value: 'due',
              child: Text('Set Due Date'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'edit':
                setState(() {
                  isEditing = true;
                });
                break;
              case 'assign':
                _showAssignDialog(context);
                break;
              case 'due':
                _showDueDateDialog(context);
                break;
              case 'delete':
                widget.onDelete();
                break;
            }
          },
        ),
      ],
    );
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> _showAssignDialog(BuildContext context) async {
    // TODO: Get actual group members
    final members = [
      {'id': 'user1', 'name': 'John Doe'},
      {'id': 'user2', 'name': 'Jane Smith'},
      {'id': 'user3', 'name': 'Bob Johnson'},
    ];

    final selectedMember = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign Item'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: members.length + 1, // +1 for "Unassigned"
            itemBuilder: (context, index) {
              if (index == 0) {
                return ListTile(
                  leading: const Icon(Icons.person_off),
                  title: const Text('Unassigned'),
                  onTap: () => Navigator.of(context).pop(null),
                );
              }

              final member = members[index - 1];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(member['name']!),
                onTap: () => Navigator.of(context).pop(member),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (selectedMember != null) {
      widget.onAssign(selectedMember['id']);
    }
  }

  Future<void> _showDueDateDialog(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: widget.item.dueAt ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final dueDate = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        widget.onDueChange(dueDate);
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 0) {
      return 'In $difference days';
    } else {
      return '${difference.abs()} days ago';
    }
  }
}
