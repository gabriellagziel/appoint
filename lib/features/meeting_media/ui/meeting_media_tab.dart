import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/meeting_media.dart';
import 'package:appoint/features/meeting_media/providers/meeting_media_providers.dart';
import 'package:appoint/features/meeting_media/ui/widgets/media_upload_button.dart';
import 'package:appoint/features/meeting_media/ui/widgets/media_tile.dart';

class MeetingMediaTab extends ConsumerWidget {
  final String meetingId;

  const MeetingMediaTab({super.key, required this.meetingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaAsync = ref.watch(meetingMediaProvider(meetingId));
    final searchQuery = ref.watch(mediaSearchProvider);
    final typeFilter = ref.watch(mediaTypeFilterProvider);
    final visibilityFilter = ref.watch(mediaVisibilityFilterProvider);

    return Scaffold(
      body: Column(
        children: [
          // Header with search and filters
          _buildHeader(context, ref),
          
          // Media content
          Expanded(
            child: mediaAsync.when(
              data: (mediaList) {
                if (mediaList.isEmpty) {
                  return _buildEmptyState(context);
                }

                // Apply filters
                var filteredMedia = mediaList;
                if (typeFilter != null) {
                  final service = ref.read(meetingMediaServiceProvider);
                  filteredMedia = service.filterByType(filteredMedia, typeFilter);
                }
                if (visibilityFilter != null) {
                  final service = ref.read(meetingMediaServiceProvider);
                  filteredMedia = service.filterByVisibility(filteredMedia, visibilityFilter);
                }
                if (searchQuery.isNotEmpty) {
                  filteredMedia = filteredMedia.where((media) {
                    final query = searchQuery.toLowerCase();
                    return media.fileName.toLowerCase().contains(query) ||
                           (media.notes?.toLowerCase().contains(query) ?? false);
                  }).toList();
                }

                if (filteredMedia.isEmpty) {
                  return _buildNoResultsState(context);
                }

                return _buildMediaGrid(context, ref, filteredMedia);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorState(context, ref, error),
            ),
          ),
        ],
      ),
      floatingActionButton: MediaUploadButton(meetingId: meetingId),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Column(
        children: [
          // Search bar
          TextField(
            onChanged: (value) => ref.read(mediaSearchProvider.notifier).state = value,
            decoration: InputDecoration(
              hintText: 'Search media files...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => ref.read(mediaSearchProvider.notifier).state = '',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Filter chips
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        context,
                        ref,
                        'All',
                        null,
                        mediaTypeFilterProvider,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        context,
                        ref,
                        'Images',
                        'images',
                        mediaTypeFilterProvider,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        context,
                        ref,
                        'Documents',
                        'documents',
                        mediaTypeFilterProvider,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        context,
                        ref,
                        'Videos',
                        'videos',
                        mediaTypeFilterProvider,
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        context,
                        ref,
                        'Audio',
                        'audio',
                        mediaTypeFilterProvider,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildVisibilityFilter(context, ref),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    WidgetRef ref,
    String label,
    String? value,
    StateProvider<String?> provider,
  ) {
    final currentValue = ref.watch(provider);
    final isSelected = currentValue == value;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        ref.read(provider.notifier).state = selected ? value : null;
      },
      selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  Widget _buildVisibilityFilter(BuildContext context, WidgetRef ref) {
    final currentVisibility = ref.watch(mediaVisibilityFilterProvider);
    
    return PopupMenuButton<String>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.visibility),
            const SizedBox(width: 4),
            Text(currentVisibility == null ? 'All' : 
                 currentVisibility == 'public' ? 'Public' : 'Group'),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: null,
          child: Text('All'),
        ),
        const PopupMenuItem(
          value: 'public',
          child: Text('Public'),
        ),
        const PopupMenuItem(
          value: 'group',
          child: Text('Group'),
        ),
      ],
      onSelected: (value) {
        ref.read(mediaVisibilityFilterProvider.notifier).state = value;
      },
    );
  }

  Widget _buildMediaGrid(BuildContext context, WidgetRef ref, List<MeetingMedia> mediaList) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: mediaList.length,
      itemBuilder: (context, index) {
        final media = mediaList[index];
        return MediaTile(
          media: media,
          meetingId: meetingId,
          onDelete: () => _deleteMedia(context, ref, media),
          onUpdate: (updates) => _updateMedia(context, ref, media, updates),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No media files yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload files to share with meeting participants',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(BuildContext context) {
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
            'No files match your search',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
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
            'Failed to load media',
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
            onPressed: () => ref.invalidate(meetingMediaProvider(meetingId)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteMedia(BuildContext context, WidgetRef ref, MeetingMedia media) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Media'),
        content: Text('Are you sure you want to delete "${media.fileName}"?'),
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
        await ref.read(mediaDeleteProvider.notifier).deleteMedia(meetingId, media.id);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${media.fileName} deleted successfully')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete media: $e')),
          );
        }
      }
    }
  }

  Future<void> _updateMedia(
    BuildContext context,
    WidgetRef ref,
    MeetingMedia media,
    Map<String, dynamic> updates,
  ) async {
    try {
      await ref.read(mediaUpdateProvider.notifier).updateMedia(
        meetingId,
        media.id,
        visibility: updates['visibility'],
        allowedRoles: updates['allowedRoles'],
        notes: updates['notes'],
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Media updated successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update media: $e')),
        );
      }
    }
  }
}
