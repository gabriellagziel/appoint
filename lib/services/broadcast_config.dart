import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration service for broadcast messaging
class BroadcastConfig {
  static final BroadcastConfig _instance = BroadcastConfig._();
  static BroadcastConfig get instance => _instance;
  
  BroadcastConfig._();

  /// Firebase Server Key for FCM
  /// In production, this should be stored securely (Firebase Functions, Backend)
  /// For development, you can set this in your .env file
  String get fcmServerKey {
    final key = dotenv.env['FCM_SERVER_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception(
        'FCM_SERVER_KEY not found in environment variables. '
        'Please add FCM_SERVER_KEY=your_key_here to your .env file'
      );
    }
    return key;
  }

  /// Default batch size for sending messages
  int get defaultBatchSize => 100;

  /// Delay between batches (in seconds)
  int get batchDelaySeconds => 1;

  /// Maximum retry attempts for failed sends
  int get maxRetryAttempts => 3;

  /// Scheduler interval for processing scheduled messages
  Duration get schedulerInterval => const Duration(minutes: 1);

  /// FCM endpoint URL
  String get fcmEndpoint => 'https://fcm.googleapis.com/fcm/send';

  /// Analytics collection name
  String get analyticsCollection => 'broadcast_analytics';

  /// Broadcast messages collection name
  String get broadcastCollection => 'admin_broadcasts';

  /// Users collection name
  String get usersCollection => 'users';

  /// Maximum file size for image uploads (in bytes)
  int get maxImageSizeBytes => 5 * 1024 * 1024; // 5MB

  /// Maximum file size for video uploads (in bytes)
  int get maxVideoSizeBytes => 50 * 1024 * 1024; // 50MB

  /// Supported image formats
  List<String> get supportedImageFormats => ['.jpg', '.jpeg', '.png', '.gif'];

  /// Supported video formats
  List<String> get supportedVideoFormats => ['.mp4', '.mov', '.avi'];

  /// Validate file size
  bool isFileSizeValid(int fileSize, bool isVideo) {
    if (isVideo) {
      return fileSize <= maxVideoSizeBytes;
    } else {
      return fileSize <= maxImageSizeBytes;
    }
  }

  /// Validate file format
  bool isFileFormatSupported(String extension, bool isVideo) {
    if (isVideo) {
      return supportedVideoFormats.contains(extension.toLowerCase());
    } else {
      return supportedImageFormats.contains(extension.toLowerCase());
    }
  }
}