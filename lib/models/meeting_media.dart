import 'package:cloud_firestore/cloud_firestore.dart';

class MeetingMedia {
  final String id;
  final String meetingId;
  final String groupId;
  final String uploaderId;
  final String fileName;
  final String mimeType;
  final int sizeBytes;
  final String storagePath;
  final String? url;
  final DateTime uploadedAt;
  final String visibility; // "group" | "public"
  final List<String> allowedRoles; // ["owner", "admin", "member"]
  final String? checksum;
  final String? notes;

  const MeetingMedia({
    required this.id,
    required this.meetingId,
    required this.groupId,
    required this.uploaderId,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    required this.storagePath,
    this.url,
    required this.uploadedAt,
    required this.visibility,
    required this.allowedRoles,
    this.checksum,
    this.notes,
  });

  factory MeetingMedia.fromMap(String id, Map<String, dynamic> map) {
    return MeetingMedia(
      id: id,
      meetingId: map['meetingId'] ?? '',
      groupId: map['groupId'] ?? '',
      uploaderId: map['uploaderId'] ?? '',
      fileName: map['fileName'] ?? '',
      mimeType: map['mimeType'] ?? '',
      sizeBytes: map['sizeBytes'] ?? 0,
      storagePath: map['storagePath'] ?? '',
      url: map['url'],
      uploadedAt: (map['uploadedAt'] as Timestamp).toDate(),
      visibility: map['visibility'] ?? 'group',
      allowedRoles: List<String>.from(map['allowedRoles'] ?? ['member']),
      checksum: map['checksum'],
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'meetingId': meetingId,
      'groupId': groupId,
      'uploaderId': uploaderId,
      'fileName': fileName,
      'mimeType': mimeType,
      'sizeBytes': sizeBytes,
      'storagePath': storagePath,
      'url': url,
      'uploadedAt': Timestamp.fromDate(uploadedAt),
      'visibility': visibility,
      'allowedRoles': allowedRoles,
      'checksum': checksum,
      'notes': notes,
    };
  }

  MeetingMedia copyWith({
    String? id,
    String? meetingId,
    String? groupId,
    String? uploaderId,
    String? fileName,
    String? mimeType,
    int? sizeBytes,
    String? storagePath,
    String? url,
    DateTime? uploadedAt,
    String? visibility,
    List<String>? allowedRoles,
    String? checksum,
    String? notes,
  }) {
    return MeetingMedia(
      id: id ?? this.id,
      meetingId: meetingId ?? this.meetingId,
      groupId: groupId ?? this.groupId,
      uploaderId: uploaderId ?? this.uploaderId,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      storagePath: storagePath ?? this.storagePath,
      url: url ?? this.url,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      visibility: visibility ?? this.visibility,
      allowedRoles: allowedRoles ?? this.allowedRoles,
      checksum: checksum ?? this.checksum,
      notes: notes ?? this.notes,
    );
  }

  bool get isImage => mimeType.startsWith('image/');
  bool get isVideo => mimeType.startsWith('video/');
  bool get isAudio => mimeType.startsWith('audio/');
  bool get isDocument => mimeType.startsWith('application/') || mimeType.startsWith('text/');
  bool get isPublic => visibility == 'public';

  String get fileSize {
    if (sizeBytes < 1024) return '${sizeBytes}B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(1)}KB';
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  String get fileExtension {
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingMedia &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          meetingId == other.meetingId;

  @override
  int get hashCode => id.hashCode ^ meetingId.hashCode;

  @override
  String toString() {
    return 'MeetingMedia(id: $id, fileName: $fileName, mimeType: $mimeType, sizeBytes: $sizeBytes)';
  }
}
