import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/meeting_media.dart';
import 'package:appoint/features/meeting_media/services/meeting_media_service.dart';
import 'package:appoint/features/meeting_media/services/media_permissions_service.dart';

// Service providers
final meetingMediaServiceProvider = Provider<MeetingMediaService>((ref) {
  return MeetingMediaService();
});

final mediaPermissionsServiceProvider = Provider<MediaPermissionsService>((ref) {
  return MediaPermissionsService();
});

// Data providers
final meetingMediaProvider = StreamProvider.family<List<MeetingMedia>, String>(
  (ref, meetingId) {
    final service = ref.read(meetingMediaServiceProvider);
    return service.listMedia(meetingId);
  },
);

final meetingMediaStatsProvider = Provider.family<Map<String, dynamic>, List<MeetingMedia>>(
  (ref, mediaList) {
    final service = ref.read(meetingMediaServiceProvider);
    return service.getMediaStats(mediaList);
  },
);

// Upload action provider
class MediaUploadNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> uploadMedia(
    String meetingId,
    String filePath, {
    String? visibility,
    List<String>? allowedRoles,
    String? notes,
  }) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(meetingMediaServiceProvider);
      final file = File(filePath);
      
      await service.uploadMedia(
        meetingId,
        file,
        visibility: visibility,
        allowedRoles: allowedRoles,
        notes: notes,
      );
      
      // Invalidate the media list to refresh
      ref.invalidate(meetingMediaProvider(meetingId));
      
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final mediaUploadProvider = AsyncNotifierProvider<MediaUploadNotifier, void>(
  () => MediaUploadNotifier(),
);

// Delete action provider
class MediaDeleteNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> deleteMedia(String meetingId, String mediaId) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(meetingMediaServiceProvider);
      await service.deleteMedia(meetingId, mediaId);
      
      // Invalidate the media list to refresh
      ref.invalidate(meetingMediaProvider(meetingId));
      
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final mediaDeleteProvider = AsyncNotifierProvider<MediaDeleteNotifier, void>(
  () => MediaDeleteNotifier(),
);

// Update action provider
class MediaUpdateNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> updateMedia(
    String meetingId,
    String mediaId, {
    String? visibility,
    List<String>? allowedRoles,
    String? notes,
  }) async {
    state = const AsyncLoading();
    try {
      final service = ref.read(meetingMediaServiceProvider);
      await service.updateMedia(
        meetingId,
        mediaId,
        visibility: visibility,
        allowedRoles: allowedRoles,
        notes: notes,
      );
      
      // Invalidate the media list to refresh
      ref.invalidate(meetingMediaProvider(meetingId));
      
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final mediaUpdateProvider = AsyncNotifierProvider<MediaUpdateNotifier, void>(
  () => MediaUpdateNotifier(),
);

// Filtered media providers
final filteredMediaProvider = Provider.family<List<MeetingMedia>, ({String meetingId, String? type, String? visibility})>(
  (ref, params) {
    final mediaAsync = ref.watch(meetingMediaProvider(params.meetingId));
    
    return mediaAsync.when(
      data: (mediaList) {
        var filtered = mediaList;
        
        // Filter by type
        if (params.type != null) {
          final service = ref.read(meetingMediaServiceProvider);
          filtered = service.filterByType(filtered, params.type!);
        }
        
        // Filter by visibility
        if (params.visibility != null) {
          final service = ref.read(meetingMediaServiceProvider);
          filtered = service.filterByVisibility(filtered, params.visibility!);
        }
        
        return filtered;
      },
      loading: () => [],
      error: (_, __) => [],
    );
  },
);

// Permission providers
final mediaPermissionsProvider = Provider.family<Map<String, dynamic>, ({String meetingId, String? mediaId})>(
  (ref, params) {
    // TODO: Get user role and group policy from existing providers
    // For now, return default permissions
    return {
      'canUpload': true,
      'canView': true,
      'canDelete': true,
      'canUpdate': true,
      'canChangeVisibility': true,
      'canManagePermissions': true,
    };
  },
);

// Media type filter provider
final mediaTypeFilterProvider = StateProvider<String?>((ref) => null);

// Media visibility filter provider
final mediaVisibilityFilterProvider = StateProvider<String?>((ref) => null);

// Media search provider
final mediaSearchProvider = StateProvider<String>((ref) => '');

// Filtered media with search
final searchableMediaProvider = Provider.family<List<MeetingMedia>, String>(
  (ref, meetingId) {
    final mediaAsync = ref.watch(meetingMediaProvider(meetingId));
    final searchQuery = ref.watch(mediaSearchProvider);
    
    return mediaAsync.when(
      data: (mediaList) {
        if (searchQuery.isEmpty) return mediaList;
        
        return mediaList.where((media) {
          final query = searchQuery.toLowerCase();
          return media.fileName.toLowerCase().contains(query) ||
                 (media.notes?.toLowerCase().contains(query) ?? false);
        }).toList();
      },
      loading: () => [],
      error: (_, __) => [],
    );
  },
);
