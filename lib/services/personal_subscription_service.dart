import 'package:appoint/models/personal_subscription.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PersonalSubscriptionService {
  PersonalSubscriptionService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  // Get current user's personal subscription
  Future<PersonalSubscription?> getCurrentSubscription() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore
          .collection('personal_subscriptions')
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (doc.docs.isEmpty) {
        // Create initial subscription for new user
        return await _createInitialSubscription(user.uid);
      }

      final data = doc.docs.first.data();
      data['id'] = doc.docs.first.id;
      return PersonalSubscription.fromJson(data);
    } catch (e) {
      print('Error fetching personal subscription: $e');
      return null;
    }
  }

  // Create initial subscription for new user
  Future<PersonalSubscription> _createInitialSubscription(String userId) async {
    final now = DateTime.now();
    final subscriptionData = {
      'userId': userId,
      'freeMeetingsUsed': 0,
      'status': PersonalSubscriptionStatus.free.name,
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
      'weeklyMeetingsUsed': 0,
      'lastWeekReset': _getWeekStart().toIso8601String(),
      'isMinor': false,
    };

    final docRef = await _firestore
        .collection('personal_subscriptions')
        .add(subscriptionData);

    subscriptionData['id'] = docRef.id;
    return PersonalSubscription.fromJson(subscriptionData);
  }

  // Check if user can access maps
  Future<bool> canAccessMaps() async {
    final subscription = await getCurrentSubscription();
    if (subscription == null) return false;

    // Check if user status allows map access
    if (!subscription.status.hasMapAccess) return false;

    // For premium users, check weekly limit
    if (subscription.status == PersonalSubscriptionStatus.premium) {
      final weeklyUsage = await _getWeeklyMeetings(subscription);
      if (weeklyUsage >= PersonalSubscriptionConstants.maxWeeklyMeetingsForPremium) {
        return false;
      }
    }

    return true;
  }

  // Record a new meeting and update counters
  Future<void> recordMeeting() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final subscription = await getCurrentSubscription();
    if (subscription == null) return;

    final now = DateTime.now();
    final weekStart = _getWeekStart();
    
    // Reset weekly counter if needed
    final shouldResetWeek = subscription.lastWeekReset == null ||
        subscription.lastWeekReset!.isBefore(weekStart);
    
    int newWeeklyUsed = shouldResetWeek ? 1 : subscription.weeklyMeetingsUsed + 1;
    int newFreeUsed = subscription.freeMeetingsUsed;
    PersonalSubscriptionStatus newStatus = subscription.status;

    // Update free meetings counter if still in free tier
    if (subscription.status == PersonalSubscriptionStatus.free) {
      newFreeUsed += 1;
      
      // Transition to ad-supported after 5 meetings
      if (newFreeUsed >= PersonalSubscriptionConstants.maxFreeMeetings) {
        newStatus = PersonalSubscriptionStatus.adSupported;
      }
    }

    // Update subscription
    await _firestore
        .collection('personal_subscriptions')
        .doc(subscription.id)
        .update({
      'freeMeetingsUsed': newFreeUsed,
      'status': newStatus.name,
      'weeklyMeetingsUsed': newWeeklyUsed,
      'lastWeekReset': shouldResetWeek ? weekStart.toIso8601String() : subscription.lastWeekReset?.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    });
  }

  // Get remaining free meetings
  Future<int> getRemainingFreeMeetings() async {
    final subscription = await getCurrentSubscription();
    if (subscription == null) return PersonalSubscriptionConstants.maxFreeMeetings;

    if (subscription.status != PersonalSubscriptionStatus.free) {
      return 0; // No more free meetings after transition
    }

    return (PersonalSubscriptionConstants.maxFreeMeetings - subscription.freeMeetingsUsed)
        .clamp(0, PersonalSubscriptionConstants.maxFreeMeetings);
  }

  // Get weekly meeting usage for premium users
  Future<int> getWeeklyMeetings([PersonalSubscription? subscription]) async {
    subscription ??= await getCurrentSubscription();
    if (subscription == null) return 0;

    return await _getWeeklyMeetings(subscription);
  }

  Future<int> _getWeeklyMeetings(PersonalSubscription subscription) async {
    final weekStart = _getWeekStart();
    
    // If last reset was before this week, return 0
    if (subscription.lastWeekReset == null ||
        subscription.lastWeekReset!.isBefore(weekStart)) {
      return 0;
    }
    
    return subscription.weeklyMeetingsUsed;
  }

  // Get remaining weekly meetings for premium users
  Future<int> getRemainingWeeklyMeetings() async {
    final subscription = await getCurrentSubscription();
    if (subscription == null) return 0;

    if (subscription.status != PersonalSubscriptionStatus.premium) {
      return 0; // Not applicable for non-premium users
    }

    final weeklyUsed = await _getWeeklyMeetings(subscription);
    return (PersonalSubscriptionConstants.maxWeeklyMeetingsForPremium - weeklyUsed)
        .clamp(0, PersonalSubscriptionConstants.maxWeeklyMeetingsForPremium);
  }

  // Check if user should see business upgrade suggestion
  Future<bool> shouldSuggestBusinessUpgrade() async {
    final subscription = await getCurrentSubscription();
    if (subscription == null) return false;

    if (subscription.status != PersonalSubscriptionStatus.premium) {
      return false;
    }

    final weeklyUsed = await _getWeeklyMeetings(subscription);
    return weeklyUsed >= PersonalSubscriptionConstants.maxWeeklyMeetingsForPremium;
  }

  // Upgrade to premium subscription (to be implemented with in-app purchases)
  Future<bool> upgradeToPremium() async {
    // TODO: Implement in-app purchase integration
    // For now, just update the status
    final user = _auth.currentUser;
    if (user == null) return false;

    final subscription = await getCurrentSubscription();
    if (subscription == null) return false;

    final now = DateTime.now();
    final subscriptionEnd = DateTime(now.year, now.month + 1, now.day); // 1 month from now

    await _firestore
        .collection('personal_subscriptions')
        .doc(subscription.id)
        .update({
      'status': PersonalSubscriptionStatus.premium.name,
      'subscriptionEnd': subscriptionEnd.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    });

    return true;
  }

  // Mark user as minor with guardian
  Future<void> setMinorStatus(String guardianUserId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final subscription = await getCurrentSubscription();
    if (subscription == null) return;

    await _firestore
        .collection('personal_subscriptions')
        .doc(subscription.id)
        .update({
      'isMinor': true,
      'guardianUserId': guardianUserId,
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  // Check if current user is joining a business meeting (for map access billing)
  Future<bool> isJoiningBusinessMeeting(String meetingId) async {
    try {
      final meetingDoc = await _firestore
          .collection('meetings')
          .doc(meetingId)
          .get();

      if (!meetingDoc.exists) return false;

      final meetingData = meetingDoc.data() as Map<String, dynamic>;
      final businessId = meetingData['businessId'] as String?;
      
      return businessId != null && businessId.isNotEmpty;
    } catch (e) {
      print('Error checking if business meeting: $e');
      return false;
    }
  }

  // Stream subscription changes for real-time updates
  Stream<PersonalSubscription?> watchSubscription() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection('personal_subscriptions')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      final data = doc.data();
      data['id'] = doc.id;
      return PersonalSubscription.fromJson(data);
    });
  }

  // Get subscription status for UI display
  Future<Map<String, dynamic>> getSubscriptionStatus() async {
    final subscription = await getCurrentSubscription();
    if (subscription == null) {
      return {
        'status': PersonalSubscriptionStatus.free,
        'freeMeetingsRemaining': PersonalSubscriptionConstants.maxFreeMeetings,
        'weeklyMeetingsRemaining': 0,
        'hasMapAccess': true,
        'showAds': false,
        'shouldUpgrade': false,
      };
    }

    final freeMeetingsRemaining = await getRemainingFreeMeetings();
    final weeklyMeetingsRemaining = await getRemainingWeeklyMeetings();
    final shouldUpgrade = await shouldSuggestBusinessUpgrade();

    return {
      'status': subscription.status,
      'freeMeetingsRemaining': freeMeetingsRemaining,
      'weeklyMeetingsRemaining': weeklyMeetingsRemaining,
      'hasMapAccess': subscription.status.hasMapAccess && await canAccessMaps(),
      'showAds': subscription.status.showAds,
      'shouldUpgrade': shouldUpgrade,
      'isMinor': subscription.isMinor,
    };
  }

  // Helper to get start of current week (Monday)
  DateTime _getWeekStart() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  }
}