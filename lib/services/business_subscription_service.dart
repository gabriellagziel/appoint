import 'package:appoint/features/studio_business/models/business_subscription.dart';
import 'package:appoint/features/studio_business/models/invoice.dart';
import 'package:appoint/features/studio_business/models/promo_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BusinessSubscriptionService {

  BusinessSubscriptionService({
    final FirebaseFirestore? firestore,
    final FirebaseAuth? auth,
    final FirebaseFunctions? functions,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _functions = functions ?? FirebaseFunctions.instance;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;

  // Getter methods to ensure we have valid instances
  FirebaseFirestore get firestore => _firestore;
  FirebaseAuth get auth => _auth;
  FirebaseFunctions get functions => _functions;

  // Get current business API configuration
  Future<BusinessSubscription?> getCurrentSubscription() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore
          .collection('b2bApiKeys')
          .where('businessId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'active')
          .limit(1)
          .get();

      if (doc.docs.isEmpty) return null;

      final data = doc.docs.first.data();
      data['id'] = doc.docs.first.id;
      
      // Convert B2B API data to BusinessSubscription format for compatibility
      return BusinessSubscription(
        id: data['id'],
        businessId: user.uid,
        customerId: user.uid,
        plan: SubscriptionPlan.pro, // B2B clients get full API access
        status: SubscriptionStatus.active,
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        currentPeriodEnd: DateTime.now().add(const Duration(days: 30)),
      );
    } catch (e) {
      return null;
    }
  }

  // Get API key usage and billing information
  Future<Map<String, dynamic>> getApiUsage() async {
    final user = _auth.currentUser;
    if (user == null) return {};

    try {
      final doc = await _firestore
          .collection('b2bApiKeys')
          .where('businessId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (doc.docs.isEmpty) return {};

      final data = doc.docs.first.data();
      return {
        'quotaRemaining': data['quotaRemaining'] ?? 1000,
        'mapUsageCount': data['mapUsageCount'] ?? 0,
        'lastUsedAt': data['lastUsedAt'],
        'status': data['status'] ?? 'active',
      };
    } catch (e) {
      return {};
    }
  }

  // Generate API key for business
  Future<String> generateApiKey() async {
    try {
      final callable = _functions.httpsCallable('generateBusinessApiKey');
      final result = await callable.call({});
      return result.data['apiKey'] as String;
    } catch (e) {
      throw Exception('Failed to generate API key: $e');
    }
  }

  // Suspend API key for non-payment
  Future<void> suspendApiKey() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      await _firestore
          .collection('b2bApiKeys')
          .where('businessId', isEqualTo: user.uid)
          .get()
          .then((snapshot) {
        for (final doc in snapshot.docs) {
          doc.reference.update({
            'status': 'suspended',
            'suspendedAt': DateTime.now().toIso8601String(),
          });
        }
      });
    } catch (e) {
      throw Exception('Failed to suspend API key: $e');
    }
  }

  // Reactivate API key after payment
  Future<void> reactivateApiKey() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    try {
      await _firestore
          .collection('b2bApiKeys')
          .where('businessId', isEqualTo: user.uid)
          .get()
          .then((snapshot) {
        for (final doc in snapshot.docs) {
          doc.reference.update({
            'status': 'active',
            'reactivatedAt': DateTime.now().toIso8601String(),
          });
        }
      });
    } catch (e) {
      throw Exception('Failed to reactivate API key: $e');
    }
  }

  // Get subscription invoices (now for API usage billing)
  Future<List<Invoice>> getInvoices({int limit = 10}) async {
    final user = _auth.currentUser;
    if (user == null) return [];

    try {
      final snap = await _firestore
          .collection('invoices')
          .where('businessId', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snap.docs
          .map((doc) => Invoice.fromJson(doc.data()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Stream API key changes for real-time updates
  Stream<BusinessSubscription?> watchSubscription() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection('b2bApiKeys')
        .where('businessId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      final data = doc.data();
      
      // Convert to BusinessSubscription format for compatibility
      return BusinessSubscription(
        id: doc.id,
        businessId: user.uid,
        customerId: user.uid,
        plan: SubscriptionPlan.pro,
        status: data['status'] == 'active' 
            ? SubscriptionStatus.active 
            : SubscriptionStatus.cancelled,
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        currentPeriodEnd: DateTime.now().add(const Duration(days: 30)),
      );
    });
  }

  // Check if user has active API access
  Future<bool> hasActiveSubscription() async {
    final apiUsage = await getApiUsage();
    return apiUsage['status'] == 'active';
  }

  // Get API access limits and features
  Future<Map<String, dynamic>> getSubscriptionLimits() async {
    final apiUsage = await getApiUsage();
    final isActive = apiUsage['status'] == 'active';

    return {
      'apiQuotaRemaining': apiUsage['quotaRemaining'] ?? 0,
      'mapUsageCount': apiUsage['mapUsageCount'] ?? 0,
      'hasApiAccess': isActive,
      'hasMapAccess': isActive,
      'hasAnalytics': isActive,
      'hasWebhooks': isActive,
    };
  }

  // Generate monthly invoice for map usage
  Future<void> generateMonthlyInvoice() async {
    try {
      final callable = _functions.httpsCallable('generateMonthlyInvoice');
      await callable.call({});
    } catch (e) {
      throw Exception('Failed to generate monthly invoice: $e');
    }
  }

  // Mark invoice as paid (admin function)
  Future<void> markInvoiceAsPaid(String invoiceId) async {
    try {
      await _firestore
          .collection('invoices')
          .doc(invoiceId)
          .update({
        'status': 'paid',
        'paidAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to mark invoice as paid: $e');
    }
  }
}
