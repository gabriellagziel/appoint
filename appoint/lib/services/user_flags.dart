import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserFlags {
  final bool isPremium;
  final bool isMinor;
  const UserFlags({required this.isPremium, required this.isMinor});

  static Future<UserFlags> load() async {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser?.uid;
    if (uid == null) return const UserFlags(isPremium: false, isMinor: false);
    try {
      final snap =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = snap.data() ?? <String, dynamic>{};
      final isPremium = data['isPremium'] == true;
      final dynamic birthday = data['birthday'];
      bool isMinor = false;
      if (birthday is String) {
        final dt = DateTime.tryParse(birthday);
        if (dt != null) {
          final now = DateTime.now();
          final years = now.year -
              dt.year -
              ((now.month < dt.month ||
                      (now.month == dt.month && now.day < dt.day))
                  ? 1
                  : 0);
          isMinor = years < 18;
        }
      }
      return UserFlags(isPremium: isPremium, isMinor: isMinor);
    } catch (_) {
      return const UserFlags(isPremium: false, isMinor: false);
    }
  }
}






