import 'package:cloud_firestore/cloud_firestore.dart';

class PlaytimeAdminNotifier {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Approve a game by changing its status to 'approved'
  static Future<void> approveGame(String gameId) async {
    await _firestore
        .collection('playtime_games')
        .doc(gameId)
        .update({'status': 'approved'});
  }

  /// Reject a game by changing its status to 'rejected'
  static Future<void> rejectGame(String gameId) async {
    await _firestore
        .collection('playtime_games')
        .doc(gameId)
        .update({'status': 'rejected'});
  }

  /// Delete a game from the database
  static Future<void> deleteGame(String gameId) async {
    await _firestore.collection('playtime_games').doc(gameId).delete();
  }
}
