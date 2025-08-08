import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/meeting_checklist.dart';
import 'package:appoint/features/meeting_checklists/services/checklist_service.dart';

// Service provider
final checklistServiceProvider = Provider<ChecklistService>((ref) {
  return ChecklistService();
});

// Data providers
final checklistsProvider = StreamProvider.family<List<MeetingChecklist>, String>(
  (ref, meetingId) {
    final service = ref.read(checklistServiceProvider);
    return service.listChecklists(meetingId);
  },
);

final checklistItemsProvider = StreamProvider.family<List<ChecklistItem>, ({String meetingId, String listId})>(
  (ref, params) {
    final service = ref.read(checklistServiceProvider);
    return service.listItems(params.meetingId, params.listId);
  },
);

final checklistStatsProvider = Provider.family<Map<String, dynamic>, List<ChecklistItem>>(
  (ref, items) {
    final service = ref.read(checklistServiceProvider);
    return service.getChecklistStats(items);
  },
);

// Create checklist action provider
class CreateChecklistNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createChecklist(String meetingId, String title) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(checklistServiceProvider);
      await service.createChecklist(meetingId, title);
      
      // Invalidate the checklists list to refresh
      ref.invalidate(checklistsProvider(meetingId));
      
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final createChecklistProvider = AsyncNotifierProvider<CreateChecklistNotifier, void>(
  () => CreateChecklistNotifier(),
);

// Archive checklist action provider
class ArchiveChecklistNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> archiveChecklist(String meetingId, String listId) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(checklistServiceProvider);
      await service.archiveChecklist(meetingId, listId);
      
      // Invalidate the checklists list to refresh
      ref.invalidate(checklistsProvider(meetingId));
      
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final archiveChecklistProvider = AsyncNotifierProvider<ArchiveChecklistNotifier, void>(
  () => ArchiveChecklistNotifier(),
);

// Update checklist title action provider
class UpdateChecklistTitleNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> updateChecklistTitle(String meetingId, String listId, String title) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(checklistServiceProvider);
      await service.updateChecklistTitle(meetingId, listId, title);
      
      // Invalidate the checklists list to refresh
      ref.invalidate(checklistsProvider(meetingId));
      
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final updateChecklistTitleProvider = AsyncNotifierProvider<UpdateChecklistTitleNotifier, void>(
  () => UpdateChecklistTitleNotifier(),
);

// Create item action provider
class CreateItemNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createItem(
    String meetingId,
    String listId,
    Map<String, dynamic> payload,
  ) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(checklistServiceProvider);
      await service.createItem(meetingId, listId, payload);
      
      // Invalidate the items list to refresh
      ref.invalidate(checklistItemsProvider((meetingId: meetingId, listId: listId)));
      
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final createItemProvider = AsyncNotifierProvider<CreateItemNotifier, void>(
  () => CreateItemNotifier(),
);

// Update item action provider
class UpdateItemNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> updateItem(
    String meetingId,
    String listId,
    String itemId,
    Map<String, dynamic> patch,
  ) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(checklistServiceProvider);
      await service.updateItem(meetingId, listId, itemId, patch);
      
      // Invalidate the items list to refresh
      ref.invalidate(checklistItemsProvider((meetingId: meetingId, listId: listId)));
      
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final updateItemProvider = AsyncNotifierProvider<UpdateItemNotifier, void>(
  () => UpdateItemNotifier(),
);

// Toggle item done status action provider
class ToggleItemDoneNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> toggleItemDone(
    String meetingId,
    String listId,
    String itemId,
    bool isDone,
  ) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(checklistServiceProvider);
      await service.toggleDone(meetingId, listId, itemId, isDone);
      
      // Invalidate the items list to refresh
      ref.invalidate(checklistItemsProvider((meetingId: meetingId, listId: listId)));
      
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final toggleItemDoneProvider = AsyncNotifierProvider<ToggleItemDoneNotifier, void>(
  () => ToggleItemDoneNotifier(),
);

// Delete item action provider
class DeleteItemNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> deleteItem(String meetingId, String listId, String itemId) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(checklistServiceProvider);
      await service.deleteItem(meetingId, listId, itemId);
      
      // Invalidate the items list to refresh
      ref.invalidate(checklistItemsProvider((meetingId: meetingId, listId: listId)));
      
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final deleteItemProvider = AsyncNotifierProvider<DeleteItemNotifier, void>(
  () => DeleteItemNotifier(),
);

// Reorder items action provider
class ReorderItemsNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> reorderItems(
    String meetingId,
    String listId,
    List<String> orderedIds,
  ) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(checklistServiceProvider);
      await service.reorderItems(meetingId, listId, orderedIds);
      
      // Invalidate the items list to refresh
      ref.invalidate(checklistItemsProvider((meetingId: meetingId, listId: listId)));
      
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final reorderItemsProvider = AsyncNotifierProvider<ReorderItemsNotifier, void>(
  () => ReorderItemsNotifier(),
);

// Filtered items providers
final itemsByAssigneeProvider = Provider.family<List<ChecklistItem>, ({List<ChecklistItem> items, String assigneeId})>(
  (ref, params) {
    final service = ref.read(checklistServiceProvider);
    return service.getItemsByAssignee(params.items, params.assigneeId);
  },
);

final itemsByPriorityProvider = Provider.family<List<ChecklistItem>, ({List<ChecklistItem> items, ChecklistItemPriority priority})>(
  (ref, params) {
    final service = ref.read(checklistServiceProvider);
    return service.getItemsByPriority(params.items, params.priority);
  },
);

final overdueItemsProvider = Provider.family<List<ChecklistItem>, List<ChecklistItem>>(
  (ref, items) {
    final service = ref.read(checklistServiceProvider);
    return service.getOverdueItems(items);
  },
);

final dueSoonItemsProvider = Provider.family<List<ChecklistItem>, List<ChecklistItem>>(
  (ref, items) {
    final service = ref.read(checklistServiceProvider);
    return service.getDueSoonItems(items);
  },
);

// UI state providers
final selectedChecklistProvider = StateProvider<String?>((ref) => null);

final checklistFilterProvider = StateProvider<String>((ref) => 'all'); // all, done, pending, overdue

final checklistSearchProvider = StateProvider<String>((ref) => '');

// Filtered items with search
final searchableItemsProvider = Provider.family<List<ChecklistItem>, ({String meetingId, String listId})>(
  (ref, params) {
    final itemsAsync = ref.watch(checklistItemsProvider((meetingId: params.meetingId, listId: params.listId)));
    final searchQuery = ref.watch(checklistSearchProvider);
    final filter = ref.watch(checklistFilterProvider);
    
    return itemsAsync.when(
      data: (items) {
        var filtered = items;
        
        // Apply search filter
        if (searchQuery.isNotEmpty) {
          filtered = filtered.where((item) {
            final query = searchQuery.toLowerCase();
            return item.text.toLowerCase().contains(query);
          }).toList();
        }
        
        // Apply status filter
        switch (filter) {
          case 'done':
            filtered = filtered.where((item) => item.isDone).toList();
            break;
          case 'pending':
            filtered = filtered.where((item) => !item.isDone).toList();
            break;
          case 'overdue':
            filtered = filtered.where((item) => item.isOverdue).toList();
            break;
          default:
            // 'all' - no additional filtering
            break;
        }
        
        return filtered;
      },
      loading: () => [],
      error: (_, __) => [],
    );
  },
);
