import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/meeting_checklist.dart';
import 'package:appoint/features/meeting_checklists/providers/meeting_checklist_providers.dart';
import 'package:appoint/features/meeting_checklists/ui/widgets/checklist_item_tile.dart';
import 'package:appoint/features/meeting_checklists/ui/widgets/checklist_toolbar.dart';

class MeetingChecklistsTab extends ConsumerStatefulWidget {
  final String meetingId;
  final String groupId;
  final String userRole;

  const MeetingChecklistsTab({
    super.key,
    required this.meetingId,
    required this.groupId,
    required this.userRole,
  });

  @override
  ConsumerState<MeetingChecklistsTab> createState() =>
      _MeetingChecklistsTabState();
}

class _MeetingChecklistsTabState extends ConsumerState<MeetingChecklistsTab> {
  String? selectedChecklistId;
  final TextEditingController _newChecklistController = TextEditingController();

  @override
  void dispose() {
    _newChecklistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checklistsAsync = ref.watch(checklistsProvider(widget.meetingId));
    final searchQuery = ref.watch(checklistSearchProvider);
    final filter = ref.watch(checklistFilterProvider);

    return Scaffold(
      body: Row(
        children: [
          // Left panel - Checklists list
          SizedBox(
            width: 300,
            child: _buildChecklistsPanel(context, checklistsAsync),
          ),

          // Right panel - Items
          Expanded(
            child: selectedChecklistId != null
                ? _buildItemsPanel(context)
                : _buildNoSelectionState(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateChecklistDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildChecklistsPanel(BuildContext context,
      AsyncValue<List<MeetingChecklist>> checklistsAsync) {
    return Container(
      decoration: BoxDecoration(
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
              color: Theme.of(context).cardColor,
              border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.checklist),
                const SizedBox(width: 8),
                Text(
                  'Checklists',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _showCreateChecklistDialog(context),
                  icon: const Icon(Icons.add),
                  tooltip: 'New Checklist',
                ),
              ],
            ),
          ),

          // Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) =>
                  ref.read(checklistSearchProvider.notifier).state = value,
              decoration: InputDecoration(
                hintText: 'Search checklists...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          // Checklists list
          Expanded(
            child: checklistsAsync.when(
              data: (checklists) {
                if (checklists.isEmpty) {
                  return _buildEmptyChecklistsState(context);
                }

                // Apply search filter
                var filteredChecklists = checklists;
                if (searchQuery.isNotEmpty) {
                  filteredChecklists = checklists.where((checklist) {
                    return checklist.title
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase());
                  }).toList();
                }

                if (filteredChecklists.isEmpty) {
                  return _buildNoSearchResultsState(context);
                }

                return ListView.builder(
                  itemCount: filteredChecklists.length,
                  itemBuilder: (context, index) {
                    final checklist = filteredChecklists[index];
                    final isSelected = selectedChecklistId == checklist.id;

                    return _buildChecklistTile(context, checklist, isSelected);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorState(context, ref, error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistTile(
      BuildContext context, MeetingChecklist checklist, bool isSelected) {
    return ListTile(
      selected: isSelected,
      leading: const Icon(Icons.checklist),
      title: Text(
        checklist.title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        'Created ${_formatDate(checklist.createdAt)}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: PopupMenuButton<String>(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'rename',
            child: Text('Rename'),
          ),
          const PopupMenuItem(
            value: 'archive',
            child: Text('Archive'),
          ),
        ],
        onSelected: (value) {
          switch (value) {
            case 'rename':
              _showRenameChecklistDialog(context, checklist);
              break;
            case 'archive':
              _archiveChecklist(context, checklist);
              break;
          }
        },
      ),
      onTap: () {
        setState(() {
          selectedChecklistId = checklist.id;
        });
      },
    );
  }

  Widget _buildItemsPanel(BuildContext context) {
    if (selectedChecklistId == null) return const SizedBox.shrink();

    final itemsAsync = ref.watch(checklistItemsProvider((
      meetingId: widget.meetingId,
      listId: selectedChecklistId!,
    )));

    return Column(
      children: [
        // Header with checklist info
        _buildItemsHeader(context),

        // Toolbar
        ChecklistToolbar(
          meetingId: widget.meetingId,
          listId: selectedChecklistId!,
        ),

        // Items list
        Expanded(
          child: itemsAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return _buildEmptyItemsState(context);
              }

              return ReorderableListView.builder(
                itemCount: items.length,
                onReorder: (oldIndex, newIndex) {
                  _reorderItems(items, oldIndex, newIndex);
                },
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ChecklistItemTile(
                    key: ValueKey(item.id),
                    item: item,
                    meetingId: widget.meetingId,
                    listId: selectedChecklistId!,
                    onToggle: (isDone) => _toggleItem(item, isDone),
                    onEdit: (text) => _editItem(item, text),
                    onAssign: (assigneeId) => _assignItem(item, assigneeId),
                    onDueChange: (dueAt) => _updateItemDue(item, dueAt),
                    onPriority: (priority) =>
                        _updateItemPriority(item, priority),
                    onDelete: () => _deleteItem(item),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorState(context, ref, error),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsHeader(BuildContext context) {
    final checklistAsync = ref.watch(checklistsProvider(widget.meetingId));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: checklistAsync.when(
        data: (checklists) {
          final selectedChecklist = checklists.firstWhere(
            (c) => c.id == selectedChecklistId,
            orElse: () => throw Exception('Checklist not found'),
          );

          return Row(
            children: [
              const Icon(Icons.checklist),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedChecklist.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Created ${_formatDate(selectedChecklist.createdAt)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showAddItemDialog(context),
                icon: const Icon(Icons.add),
                tooltip: 'Add Item',
              ),
            ],
          );
        },
        loading: () => const CircularProgressIndicator(),
        error: (_, __) => const Text('Error loading checklist'),
      ),
    );
  }

  Widget _buildNoSelectionState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checklist_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Select a checklist',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a checklist from the left panel to view and manage its items',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChecklistsState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.checklist_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No checklists yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first checklist to organize tasks for this meeting',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showCreateChecklistDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Create Checklist'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResultsState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No checklists match your search',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search terms',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyItemsState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No items yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to this checklist to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showAddItemDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Item'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, Object error) {
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
            'Failed to load checklists',
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
                ref.invalidate(checklistsProvider(widget.meetingId)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // Dialog methods
  Future<void> _showCreateChecklistDialog(BuildContext context) async {
    _newChecklistController.clear();

    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Checklist'),
        content: TextField(
          controller: _newChecklistController,
          decoration: const InputDecoration(
            hintText: 'Enter checklist title...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.of(context).pop(_newChecklistController.text),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (title != null && title.isNotEmpty) {
      try {
        await ref.read(createChecklistProvider.notifier).createChecklist(
              widget.meetingId,
              title,
            );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Checklist created successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create checklist: $e')),
          );
        }
      }
    }
  }

  Future<void> _showRenameChecklistDialog(
      BuildContext context, MeetingChecklist checklist) async {
    _newChecklistController.text = checklist.title;

    final newTitle = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Checklist'),
        content: TextField(
          controller: _newChecklistController,
          decoration: const InputDecoration(
            hintText: 'Enter new title...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.of(context).pop(_newChecklistController.text),
            child: const Text('Rename'),
          ),
        ],
      ),
    );

    if (newTitle != null &&
        newTitle.isNotEmpty &&
        newTitle != checklist.title) {
      try {
        await ref
            .read(updateChecklistTitleProvider.notifier)
            .updateChecklistTitle(
              widget.meetingId,
              checklist.id,
              newTitle,
            );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Checklist renamed successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to rename checklist: $e')),
          );
        }
      }
    }
  }

  Future<void> _showAddItemDialog(BuildContext context) async {
    final text = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Item'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Enter item text...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop('New Item'),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (text != null && text.isNotEmpty) {
      try {
        await ref.read(createItemProvider.notifier).createItem(
          widget.meetingId,
          selectedChecklistId!,
          {'text': text},
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item added successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add item: $e')),
          );
        }
      }
    }
  }

  // Action methods
  Future<void> _archiveChecklist(
      BuildContext context, MeetingChecklist checklist) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive Checklist'),
        content: Text('Are you sure you want to archive "${checklist.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Archive'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(archiveChecklistProvider.notifier).archiveChecklist(
              widget.meetingId,
              checklist.id,
            );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${checklist.title} archived successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to archive checklist: $e')),
          );
        }
      }
    }
  }

  Future<void> _toggleItem(ChecklistItem item, bool isDone) async {
    try {
      await ref.read(toggleItemDoneProvider.notifier).toggleItemDone(
            widget.meetingId,
            selectedChecklistId!,
            item.id,
            isDone,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update item: $e')),
        );
      }
    }
  }

  Future<void> _editItem(ChecklistItem item, String text) async {
    try {
      await ref.read(updateItemProvider.notifier).updateItem(
        widget.meetingId,
        selectedChecklistId!,
        item.id,
        {'text': text},
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update item: $e')),
        );
      }
    }
  }

  Future<void> _assignItem(ChecklistItem item, String? assigneeId) async {
    try {
      await ref.read(updateItemProvider.notifier).updateItem(
        widget.meetingId,
        selectedChecklistId!,
        item.id,
        {'assigneeId': assigneeId},
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to assign item: $e')),
        );
      }
    }
  }

  Future<void> _updateItemDue(ChecklistItem item, DateTime? dueAt) async {
    try {
      await ref.read(updateItemProvider.notifier).updateItem(
        widget.meetingId,
        selectedChecklistId!,
        item.id,
        {'dueAt': dueAt},
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update due date: $e')),
        );
      }
    }
  }

  Future<void> _updateItemPriority(
      ChecklistItem item, ChecklistItemPriority priority) async {
    try {
      await ref.read(updateItemProvider.notifier).updateItem(
        widget.meetingId,
        selectedChecklistId!,
        item.id,
        {'priority': priority.name},
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update priority: $e')),
        );
      }
    }
  }

  Future<void> _deleteItem(ChecklistItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.text}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(deleteItemProvider.notifier).deleteItem(
              widget.meetingId,
              selectedChecklistId!,
              item.id,
            );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete item: $e')),
          );
        }
      }
    }
  }

  Future<void> _reorderItems(
      List<ChecklistItem> items, int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    final orderedIds = items.map((item) => item.id).toList();

    try {
      await ref.read(reorderItemsProvider.notifier).reorderItems(
            widget.meetingId,
            selectedChecklistId!,
            orderedIds,
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to reorder items: $e')),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
