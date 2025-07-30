import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service responsible for enforcing the Google-Maps free-tier limitations.
///
/// * A free user may view the map **only once per appointment**
/// * They may view maps for **up to 5 appointments** in total
/// * Premium (or otherwise whitelisted) users have unlimited access
class MapAccessService {
  MapAccessService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  /// Determines whether the current user can view the Google Map for the given
  /// [appointmentId].
  ///
  /// The method also **records** the view *atomically* (using a Firestore
  /// transaction) when the user is allowed, guaranteeing that the limits are
  /// enforced server-side as well.
  ///
  /// Returns `true` if the map should be shown, or `false` if it must be
  /// blocked and the upgrade message displayed.
  Future<bool> canViewAndRecord(String appointmentId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      // Not signed-in. Treat as blocked to be safe.
      return false;
    }

    final userRef = _firestore.collection('users').doc(uid);
    final mapViewRef = userRef.collection('mapViews').doc(appointmentId);

    return _firestore.runTransaction<bool>((tx) async {
      // Fetch current user data (before) and mapping document.
      final userSnap = await tx.get(userRef);
      Map<String, dynamic>? user = userSnap.data();

      // If user doc does not exist we initialise the necessary data so that
      // limits can still be enforced.
      user ??= <String, dynamic>{'mapViewCount': 0};

      final bool isPremium = (user['premium'] as bool?) ?? false;
      final bool isAdminFreeAccess = (user['isAdminFreeAccess'] as bool?) ?? false;
      if (isPremium || isAdminFreeAccess) {
        // Premium / admin users always have access, we do **not** record the
        // view because it is irrelevant for them.
        return true;
      }

      final int currentCount = (user['mapViewCount'] as int?) ?? 0;
      if (currentCount >= 5) {
        // User exhausted total quota.
        return false;
      }

      final mapViewSnap = await tx.get(mapViewRef);
      if (mapViewSnap.exists) {
        // Already viewed once for this appointment → block.
        return false;
      }

      // ---- Allowed -------------------------------------------------------
      // Record that the appointment has been viewed and increment the counter.
      tx.set(mapViewRef, {
        'viewed': true,
        'timestamp': FieldValue.serverTimestamp(),
      });
      tx.update(userRef, {
        'mapViewCount': FieldValue.increment(1),
      });
      return true;
    });
  }

  /// Retrieves the **current** usage status without recording a new view.
  Future<MapUsageStatus> getUsageStatus(String appointmentId) async {
    const limit = 5;
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return MapUsageStatus(
        isPremium: false,
        currentCount: limit,
        limit: limit,
        alreadyViewed: false,
      );
    }

    final userSnap = await _firestore.collection('users').doc(uid).get();
    final data = userSnap.data() ?? <String, dynamic>{};
    final isPremium = (data['premium'] as bool?) ?? false;
    final isAdminFreeAccess = (data['isAdminFreeAccess'] as bool?) ?? false;

    if (isPremium || isAdminFreeAccess) {
      return MapUsageStatus(
        isPremium: true,
        currentCount: 0,
        limit: limit,
        alreadyViewed: false,
      );
    }

    final currentCount = (data['mapViewCount'] as int?) ?? 0;

    final viewedDoc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('mapViews')
        .doc(appointmentId)
        .get();

    return MapUsageStatus(
      isPremium: false,
      currentCount: currentCount,
      limit: limit,
      alreadyViewed: viewedDoc.exists,
    );
  }
}

/// Lightweight value-object containing current usage information for the
/// _signed-in_ user.
class MapUsageStatus {
  MapUsageStatus({
    required this.isPremium,
    required this.currentCount,
    required this.limit,
    required this.alreadyViewed,
  });

  final bool isPremium;
  final int currentCount;
  final int limit;
  final bool alreadyViewed;

  int get remaining => (limit - currentCount).clamp(0, limit);
}