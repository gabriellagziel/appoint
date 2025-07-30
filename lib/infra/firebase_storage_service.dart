import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class FirebaseStorageService {
  FirebaseStorageService._();
  static final FirebaseStorageService _instance = FirebaseStorageService._();
  static FirebaseStorageService get instance => _instance;

  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload a file to Firebase Storage and return the download URL
  Future<String> uploadFile(File file, String storagePath) async {
    try {
      // Get file extension
      final extension = path.extension(file.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$extension';
      final fullPath = '$storagePath/$fileName';

      // Create storage reference
      final ref = _storage.ref().child(fullPath);

      // Set metadata
      final metadata = SettableMetadata(
        contentType: _getContentType(extension),
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
        },
      );

      // Upload file
      final uploadTask = ref.putFile(file, metadata);

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  /// Upload image for broadcast message
  Future<String> uploadBroadcastImage(File imageFile) async =>
      uploadFile(imageFile, 'broadcast_messages/images');

  /// Upload video for broadcast message
  Future<String> uploadBroadcastVideo(File videoFile) async =>
      uploadFile(videoFile, 'broadcast_messages/videos');

  /// Delete a file from Firebase Storage
  Future<void> deleteFile(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  /// Get content type based on file extension
  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.mp4':
        return 'video/mp4';
      case '.mov':
        return 'video/quicktime';
      case '.avi':
        return 'video/x-msvideo';
      default:
        return 'application/octet-stream';
    }
  }
}
