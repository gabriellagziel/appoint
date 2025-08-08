import 'package:appoint/models/meeting_media.dart';
import 'package:appoint/models/group_role.dart';
import 'package:appoint/models/group_policy.dart';

class MediaPermissionsService {
  /// Check if user can upload media
  bool canUpload(GroupRole userRole, GroupPolicy policy) {
    // Basic check - members can upload if policy allows
    if (userRole == GroupRole.member) {
      return true; // Default to allowing members to upload
    }
    
    // Admins and owners can always upload
    if (userRole == GroupRole.admin || userRole == GroupRole.owner) {
      return true;
    }
    
    return false;
  }

  /// Check if user can view media
  bool canView(MeetingMedia media, GroupRole userRole, bool isGroupMember) {
    // Public media can be viewed by anyone
    if (media.isPublic) {
      return true;
    }
    
    // Group members can view group media
    if (isGroupMember) {
      // Check if user's role is in allowed roles
      if (media.allowedRoles.contains(userRole.name)) {
        return true;
      }
    }
    
    return false;
  }

  /// Check if user can delete media
  bool canDelete(MeetingMedia media, GroupRole userRole) {
    // Owner can delete any media
    if (userRole == GroupRole.owner) {
      return true;
    }
    
    // Admin can delete any media
    if (userRole == GroupRole.admin) {
      return true;
    }
    
    // User can delete their own media
    if (media.uploaderId == _getCurrentUserId()) {
      return true;
    }
    
    return false;
  }

  /// Check if user can update media metadata
  bool canUpdate(MeetingMedia media, GroupRole userRole) {
    // Owner can update any media
    if (userRole == GroupRole.owner) {
      return true;
    }
    
    // Admin can update any media
    if (userRole == GroupRole.admin) {
      return true;
    }
    
    // User can update their own media
    if (media.uploaderId == _getCurrentUserId()) {
      return true;
    }
    
    return false;
  }

  /// Check if user can change media visibility
  bool canChangeVisibility(MeetingMedia media, GroupRole userRole) {
    // Only owners and admins can change visibility
    return userRole == GroupRole.owner || userRole == GroupRole.admin;
  }

  /// Check if user can manage media permissions
  bool canManagePermissions(GroupRole userRole) {
    // Only owners and admins can manage permissions
    return userRole == GroupRole.owner || userRole == GroupRole.admin;
  }

  /// Get allowed roles for media based on user's role
  List<String> getAllowedRolesForUser(GroupRole userRole) {
    switch (userRole) {
      case GroupRole.owner:
        return ['owner', 'admin', 'member'];
      case GroupRole.admin:
        return ['admin', 'member'];
      case GroupRole.member:
        return ['member'];
    }
  }

  /// Check if media is accessible to public
  bool isPubliclyAccessible(MeetingMedia media) {
    return media.isPublic;
  }

  /// Check if media requires group membership
  bool requiresGroupMembership(MeetingMedia media) {
    return !media.isPublic;
  }

  /// Get permission error message
  String getPermissionErrorMessage(String action, GroupRole userRole) {
    switch (action) {
      case 'upload':
        return 'You do not have permission to upload media to this meeting.';
      case 'view':
        return 'You do not have permission to view this media.';
      case 'delete':
        return 'You do not have permission to delete this media.';
      case 'update':
        return 'You do not have permission to update this media.';
      case 'change_visibility':
        return 'Only admins and owners can change media visibility.';
      case 'manage_permissions':
        return 'Only admins and owners can manage media permissions.';
      default:
        return 'You do not have permission to perform this action.';
    }
  }

  /// Get role-based permission summary
  Map<String, bool> getRolePermissions(GroupRole userRole) {
    switch (userRole) {
      case GroupRole.owner:
        return {
          'canUpload': true,
          'canViewAll': true,
          'canDeleteAll': true,
          'canUpdateAll': true,
          'canChangeVisibility': true,
          'canManagePermissions': true,
        };
      case GroupRole.admin:
        return {
          'canUpload': true,
          'canViewAll': true,
          'canDeleteAll': true,
          'canUpdateAll': true,
          'canChangeVisibility': true,
          'canManagePermissions': true,
        };
      case GroupRole.member:
        return {
          'canUpload': true,
          'canViewOwn': true,
          'canDeleteOwn': true,
          'canUpdateOwn': true,
          'canChangeVisibility': false,
          'canManagePermissions': false,
        };
    }
  }

  /// Check if user can access media based on group membership
  bool canAccessMedia(MeetingMedia media, bool isGroupMember, GroupRole userRole) {
    // Public media is accessible to everyone
    if (media.isPublic) {
      return true;
    }
    
    // Group media requires membership
    if (!isGroupMember) {
      return false;
    }
    
    // Check role-based access
    return media.allowedRoles.contains(userRole.name);
  }

  /// Validate media upload permissions
  Map<String, dynamic> validateUploadPermissions(GroupRole userRole, GroupPolicy policy) {
    final canUpload = this.canUpload(userRole, policy);
    final allowedRoles = getAllowedRolesForUser(userRole);
    
    return {
      'canUpload': canUpload,
      'allowedRoles': allowedRoles,
      'errorMessage': canUpload ? null : getPermissionErrorMessage('upload', userRole),
    };
  }

  /// Validate media access permissions
  Map<String, dynamic> validateAccessPermissions(
    MeetingMedia media,
    GroupRole userRole,
    bool isGroupMember,
  ) {
    final canView = this.canView(media, userRole, isGroupMember);
    final canDelete = this.canDelete(media, userRole);
    final canUpdate = this.canUpdate(media, userRole);
    final canChangeVisibility = this.canChangeVisibility(media, userRole);
    
    return {
      'canView': canView,
      'canDelete': canDelete,
      'canUpdate': canUpdate,
      'canChangeVisibility': canChangeVisibility,
      'errorMessage': canView ? null : getPermissionErrorMessage('view', userRole),
    };
  }

  // Helper method to get current user ID
  String _getCurrentUserId() {
    // TODO: Get current user ID from auth service
    return 'current-user-id';
  }
}
