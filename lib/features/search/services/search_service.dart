import 'package:appoint/features/search/models/search_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchService {
  SearchService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  /// Search across all entities (businesses, services, users)
  Future<List<SearchResult>> search(String query, SearchFilters filters) async {
    if (query.trim().isEmpty) return [];

    final results = <SearchResult>[];
    
    // Search businesses
    final businessResults = await _searchBusinesses(query, filters);
    results.addAll(businessResults);

    // Search services
    final serviceResults = await _searchServices(query, filters);
    results.addAll(serviceResults);

    // Search users (if permitted)
    final userResults = await _searchUsers(query, filters);
    results.addAll(userResults);

    // Apply sorting
    return _sortResults(results, filters.sortBy);
  }

  /// Get search suggestions based on partial query
  Future<List<String>> getSearchSuggestions(String partial) async {
    if (partial.trim().isEmpty) return [];

    final suggestions = <String>{};
    
    // Get business name suggestions
    final businessSnapshot = await _firestore
        .collection('business_profiles')
        .where('name', isGreaterThanOrEqualTo: partial)
        .where('name', isLessThan: partial + '\uf8ff')
        .limit(5)
        .get();

    for (final doc in businessSnapshot.docs) {
      suggestions.add(doc.data()['name'] as String);
    }

    // Get service name suggestions
    final serviceSnapshot = await _firestore
        .collection('services')
        .where('name', isGreaterThanOrEqualTo: partial)
        .where('name', isLessThan: partial + '\uf8ff')
        .limit(5)
        .get();

    for (final doc in serviceSnapshot.docs) {
      suggestions.add(doc.data()['name'] as String);
    }

    return suggestions.toList()..sort();
  }

  /// Save search query to user's search history
  Future<void> saveSearchHistory(String query) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('search_history')
        .add({
      'query': query,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  /// Get user's search history
  Future<List<String>> getSearchHistory() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('search_history')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();

    return snapshot.docs
        .map((doc) => doc.data()['query'] as String)
        .toList();
  }

  /// Clear user's search history
  Future<void> clearSearchHistory() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('search_history')
        .get();

    final batch = _firestore.batch();
    for (final doc in snapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  /// Search businesses
  Future<List<SearchResult>> _searchBusinesses(String query, SearchFilters filters) async {
    Query businessQuery = _firestore.collection('business_profiles');

    // Apply text search
    businessQuery = businessQuery
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + '\uf8ff');

    // Apply category filter
    if (filters.category != null) {
      businessQuery = businessQuery.where('category', isEqualTo: filters.category);
    }

    // Apply rating filter
    if (filters.minRating != null) {
      businessQuery = businessQuery.where('rating', isGreaterThanOrEqualTo: filters.minRating);
    }

    final snapshot = await businessQuery.limit(20).get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return SearchResult(
        id: doc.id,
        title: data['name'] as String? ?? '',
        description: data['description'] as String? ?? '',
        type: 'business',
        rating: ((data['rating'] as double?) ?? 0.0).toDouble(),
        imageUrl: data['imageUrl'] as String? ?? '',
        metadata: data,
        distance: (data['distance'] as double?)?.toDouble(),
        availability: data['isAvailable'] as bool? ?? true,
        price: (data['averagePrice'] as double?)?.toDouble(),
      );
    }).toList();
  }

  /// Search services
  Future<List<SearchResult>> _searchServices(String query, SearchFilters filters) async {
    Query serviceQuery = _firestore.collection('services');

    // Apply text search
    serviceQuery = serviceQuery
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + '\uf8ff');

    // Apply category filter
    if (filters.category != null) {
      serviceQuery = serviceQuery.where('category', isEqualTo: filters.category);
    }

    // Apply price filter
    if (filters.maxPrice != null) {
      serviceQuery = serviceQuery.where('price', isLessThanOrEqualTo: filters.maxPrice);
    }

    final snapshot = await serviceQuery.limit(20).get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return SearchResult(
        id: doc.id,
        title: data['name'] as String? ?? '',
        description: data['description'] as String? ?? '',
        type: 'service',
        rating: ((data['rating'] as double?) ?? 0.0).toDouble(),
        imageUrl: data['imageUrl'] as String? ?? '',
        metadata: data,
        availability: data['isAvailable'] as bool? ?? true,
        price: (data['price'] as double?)?.toDouble(),
      );
    }).toList();
  }

  /// Search users (limited to public profiles)
  Future<List<SearchResult>> _searchUsers(String query, SearchFilters filters) async {
    Query userQuery = _firestore.collection('users');

    // Apply text search
    userQuery = userQuery
        .where('displayName', isGreaterThanOrEqualTo: query)
        .where('displayName', isLessThan: query + '\uf8ff')
        .where('isPublic', isEqualTo: true);

    final snapshot = await userQuery.limit(10).get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return SearchResult(
        id: doc.id,
        title: data['displayName'] as String? ?? '',
        description: data['bio'] as String? ?? '',
        type: 'user',
        rating: 0.0, // Users don't have ratings
        imageUrl: data['photoURL'] ?? '',
        metadata: data,
      );
    }).toList();
  }

  /// Sort results based on sort criteria
  List<SearchResult> _sortResults(List<SearchResult> results, String? sortBy) {
    switch (sortBy) {
      case 'rating':
        results.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'price':
        results.sort((a, b) {
          final aPrice = a.price ?? double.infinity;
          final bPrice = b.price ?? double.infinity;
          return aPrice.compareTo(bPrice);
        });
        break;
      case 'distance':
        results.sort((a, b) {
          final aDistance = a.distance ?? double.infinity;
          final bDistance = b.distance ?? double.infinity;
          return aDistance.compareTo(bDistance);
        });
        break;
      case 'relevance':
      default:
        // Keep original order (Firestore relevance)
        break;
    }
    return results;
  }
} 