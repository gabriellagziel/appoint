import 'dart:io';

import 'package:appoint/features/messaging/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MessagingService {
  MessagingService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  /// Get real-time stream of messages for a chat
  Stream<List<Message>> getMessages(String chatId) => _firestore
      .collection('chats')
      .doc(chatId)
      .collection('messages')
      .orderBy('timestamp', descending: true)
      .limit(50)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => Message.fromJson({...doc.data(), 'id': doc.id}))
            .toList(),
      );

  /// Send a message
  Future<void> sendMessage(Message message) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    // Add message to chat
    await _firestore
        .collection('chats')
        .doc(message.chatId)
        .collection('messages')
        .add(message.toJson());

    // Update chat's last message
    await _firestore.collection('chats').doc(message.chatId).update({
      'lastMessage': message.toJson(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // Send push notification to other participants
    await _sendPushNotification(message);
  }

  /// Mark message as read
  Future<void> markAsRead(String messageId, String chatId) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({'isRead': true});
  }

  /// Get user's chats
  Stream<List<Chat>> getUserChats() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: user.uid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Chat.fromJson({...doc.data(), 'id': doc.id}))
              .toList(),
        );
  }

  /// Create a new chat
  Future<String> createChat({
    required List<String> participants,
    required ChatType type,
    String? name,
    String? avatar,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    // Ensure current user is in participants
    if (!participants.contains(user.uid)) {
      participants.add(user.uid);
    }

    final chat = Chat(
      id: '',
      participants: participants,
      type: type,
      lastMessage: null,
      updatedAt: DateTime.now(),
      name: name,
      avatar: avatar,
    );

    final docRef = await _firestore.collection('chats').add(chat.toJson());
    return docRef.id;
  }

  /// Upload file attachment
  Future<Attachment> uploadAttachment(File file, String chatId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
    final ref = _storage.ref().child('chats/$chatId/attachments/$fileName');

    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    final attachment = Attachment(
      id: '',
      type: _getAttachmentType(file.path),
      url: downloadUrl,
      name: file.path.split('/').last,
      size: await file.length(),
      mimeType: _getMimeType(file.path),
    );

    return attachment;
  }

  /// Delete message
  Future<void> deleteMessage(String messageId, String chatId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    // Check if user is the sender
    final messageDoc = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .get();

    if (!messageDoc.exists) throw Exception('Message not found');

    final message = Message.fromJson({...messageDoc.data()!, 'id': messageId});
    if (message.senderId != user.uid) throw Exception('Not authorized');

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  /// Archive chat
  Future<void> archiveChat(String chatId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _firestore.collection('chats').doc(chatId).update({
      'isArchived': true,
    });
  }

  /// Mute chat
  Future<void> muteChat(String chatId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    await _firestore.collection('chats').doc(chatId).update({
      'isMuted': true,
    });
  }

  /// Get unread count for a chat
  Stream<int> getUnreadCount(String chatId) {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(0);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('isRead', isEqualTo: false)
        .where('senderId', isNotEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Send system message (for business notifications, etc.)
  Future<void> sendSystemMessage({
    required String chatId,
    required String content,
    Map<String, dynamic>? metadata,
  }) async {
    final systemMessage = Message(
      id: '',
      senderId: 'system',
      chatId: chatId,
      content: content,
      type: MessageType.system,
      timestamp: DateTime.now(),
      metadata: metadata,
    );

    await sendMessage(systemMessage);
  }

  /// Send push notification to chat participants
  Future<void> _sendPushNotification(Message message) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Get chat participants
    final chatDoc =
        await _firestore.collection('chats').doc(message.chatId).get();
    if (!chatDoc.exists) return;

    final chat = Chat.fromJson({...chatDoc.data()!, 'id': message.chatId});
    final otherParticipants =
        chat.participants.where((id) => id != user.uid).toList();

    // Send push notifications to other participants
    for (final participantId in otherParticipants) {
      await _sendPushToUser(participantId, message);
    }
  }

  /// Send push notification to specific user
  Future<void> _sendPushToUser(String userId, Message message) async {
    // Get user's FCM token
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) return;

    final userData = userDoc.data()!;
    final fcmToken = userData['fcmToken'] as String?;
    if (fcmToken == null) return;

    // Send FCM notification
    await _firestore.collection('notifications').add({
      'userId': userId,
      'fcmToken': fcmToken,
      'title': 'New Message',
      'body': message.content,
      'data': {
        'type': 'message',
        'chatId': message.chatId,
        'messageId': message.id,
      },
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Get attachment type from file path
  AttachmentType _getAttachmentType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();

    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return AttachmentType.image;
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'wmv':
        return AttachmentType.video;
      case 'mp3':
      case 'wav':
      case 'aac':
        return AttachmentType.audio;
      case 'pdf':
      case 'doc':
      case 'docx':
      case 'txt':
        return AttachmentType.document;
      default:
        return AttachmentType.document;
    }
  }

  /// Get MIME type from file path
  String? _getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();

    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'mp4':
        return 'video/mp4';
      case 'mp3':
        return 'audio/mpeg';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'txt':
        return 'text/plain';
      default:
        return null;
    }
  }
}
