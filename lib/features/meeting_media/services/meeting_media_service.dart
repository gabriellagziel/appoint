import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:crypto/crypto.dart';
import 'package:appoint/models/meeting_media.dart';

class MeetingMediaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  /// Upload media file to meeting
  Future<MeetingMedia> uploadMedia(
    String meetingId,
    File file, {
    String? visibility,
    List<String>? allowedRoles,
    String? notes,
  }) async {
    try {
      // Generate unique ID and storage path
      final mediaId = _uuid.v4();
      final fileName = file.path.split('/').last;
      final fileExtension = fileName.split('.').last;
      final storagePath = 'meetings/$meetingId/media/$mediaId.$fileExtension';

      // Get file metadata
      final fileSize = await file.length();
      final mimeType = _getMimeType(fileExtension);
      final checksum = await _calculateChecksum(file);

      // Upload to Firebase Storage
      final storageRef = _storage.ref().child(storagePath);
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Get meeting info for groupId
      final meetingDoc = await _firestore.collection('meetings').doc(meetingId).get();
      if (!meetingDoc.exists) {
        throw Exception('Meeting not found');
      }
      final groupId = meetingDoc.data()!['groupId'] as String;

      // Create media document
      final media = MeetingMedia(
        id: mediaId,
        meetingId: meetingId,
        groupId: groupId,
        uploaderId: _getCurrentUserId(),
        fileName: fileName,
        mimeType: mimeType,
        sizeBytes: fileSize,
        storagePath: storagePath,
        url: downloadUrl,
        uploadedAt: DateTime.now(),
        visibility: visibility ?? 'group',
        allowedRoles: allowedRoles ?? ['member'],
        checksum: checksum,
        notes: notes,
      );

      // Save to Firestore
      await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('media')
          .doc(mediaId)
          .set(media.toMap());

      return media;
    } catch (e) {
      throw Exception('Failed to upload media: $e');
    }
  }

  /// List all media for a meeting
  Stream<List<MeetingMedia>> listMedia(String meetingId) {
    return _firestore
        .collection('meetings')
        .doc(meetingId)
        .collection('media')
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MeetingMedia.fromMap(doc.id, doc.data()))
            .toList());
  }

  /// Get specific media by ID
  Future<MeetingMedia?> getMedia(String meetingId, String mediaId) async {
    try {
      final doc = await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('media')
          .doc(mediaId)
          .get();

      if (!doc.exists) return null;
      return MeetingMedia.fromMap(doc.id, doc.data()!);
    } catch (e) {
      throw Exception('Failed to get media: $e');
    }
  }

  /// Delete media file
  Future<void> deleteMedia(String meetingId, String mediaId) async {
    try {
      // Get media info first
      final media = await getMedia(meetingId, mediaId);
      if (media == null) {
        throw Exception('Media not found');
      }

      // Delete from Storage
      final storageRef = _storage.ref().child(media.storagePath);
      await storageRef.delete();

      // Delete from Firestore
      await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('media')
          .doc(mediaId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete media: $e');
    }
  }

  /// Update media metadata
  Future<void> updateMedia(
    String meetingId,
    String mediaId, {
    String? visibility,
    List<String>? allowedRoles,
    String? notes,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (visibility != null) updates['visibility'] = visibility;
      if (allowedRoles != null) updates['allowedRoles'] = allowedRoles;
      if (notes != null) updates['notes'] = notes;

      await _firestore
          .collection('meetings')
          .doc(meetingId)
          .collection('media')
          .doc(mediaId)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update media: $e');
    }
  }

  /// Download media file
  Future<Uint8List> downloadMedia(String meetingId, String mediaId) async {
    try {
      final media = await getMedia(meetingId, mediaId);
      if (media == null) {
        throw Exception('Media not found');
      }

      final storageRef = _storage.ref().child(media.storagePath);
      return await storageRef.getData() ?? Uint8List(0);
    } catch (e) {
      throw Exception('Failed to download media: $e');
    }
  }

  /// Get download URL for media
  Future<String> getDownloadUrl(String meetingId, String mediaId) async {
    try {
      final media = await getMedia(meetingId, mediaId);
      if (media == null) {
        throw Exception('Media not found');
      }

      final storageRef = _storage.ref().child(media.storagePath);
      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to get download URL: $e');
    }
  }

  /// Filter media by type
  List<MeetingMedia> filterByType(List<MeetingMedia> media, String type) {
    switch (type.toLowerCase()) {
      case 'images':
        return media.where((m) => m.isImage).toList();
      case 'videos':
        return media.where((m) => m.isVideo).toList();
      case 'documents':
        return media.where((m) => m.isDocument).toList();
      case 'audio':
        return media.where((m) => m.isAudio).toList();
      default:
        return media;
    }
  }

  /// Filter media by visibility
  List<MeetingMedia> filterByVisibility(List<MeetingMedia> media, String visibility) {
    return media.where((m) => m.visibility == visibility).toList();
  }

  /// Get total size of media in meeting
  int getTotalSize(List<MeetingMedia> media) {
    return media.fold(0, (sum, m) => sum + m.sizeBytes);
  }

  /// Get media statistics
  Map<String, dynamic> getMediaStats(List<MeetingMedia> media) {
    final totalFiles = media.length;
    final totalSize = getTotalSize(media);
    final imageCount = media.where((m) => m.isImage).length;
    final videoCount = media.where((m) => m.isVideo).length;
    final documentCount = media.where((m) => m.isDocument).length;
    final audioCount = media.where((m) => m.isAudio).length;
    final publicCount = media.where((m) => m.isPublic).length;

    return {
      'totalFiles': totalFiles,
      'totalSize': totalSize,
      'imageCount': imageCount,
      'videoCount': videoCount,
      'documentCount': documentCount,
      'audioCount': audioCount,
      'publicCount': publicCount,
    };
  }

  // Helper methods
  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'mp4':
        return 'video/mp4';
      case 'mov':
        return 'video/quicktime';
      case 'avi':
        return 'video/x-msvideo';
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'txt':
        return 'text/plain';
      case 'rtf':
        return 'application/rtf';
      default:
        return 'application/octet-stream';
    }
  }

  Future<String> _calculateChecksum(File file) async {
    final bytes = await file.readAsBytes();
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String _getCurrentUserId() {
    // TODO: Get current user ID from auth service
    return 'current-user-id';
  }
}
