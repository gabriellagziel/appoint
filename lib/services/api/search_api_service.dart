import 'package:appoint/models/service.dart';
import 'package:appoint/models/business.dart';
import 'package:appoint/models/professional.dart';
import 'package:appoint/services/api/api_client.dart';

class SearchApiService {
  static final SearchApiService _instance = SearchApiService._();
  static SearchApiService get instance => _instance;
  
  SearchApiService._();

  // Search services with advanced filters
  Future<SearchResults> searchServices({
    required String query,
    String? category,
    String? location,
    double? latitude,
    double? longitude,
    double? radius,
    String? sortBy,
    String? sortOrder,
    int? minRating,
    double? maxPrice,
    double? minPrice,
    List<String>? tags,
    bool? availableNow,
    DateTime? availableDate,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'q': query,
        if (category != null) 'category': category,
        if (location != null) 'location': location,
        if (latitude != null) 'lat': latitude,
        if (longitude != null) 'lng': longitude,
        if (radius != null) 'radius': radius,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
        if (minRating != null) 'minRating': minRating,
        if (maxPrice != null) 'maxPrice': maxPrice,
        if (minPrice != null) 'minPrice': minPrice,
        if (tags != null) 'tags': tags.join(','),
        if (availableNow != null) 'availableNow': availableNow,
        if (availableDate != null) 'availableDate': availableDate.toIso8601String(),
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      };

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/search/services',
        queryParameters: queryParams,
      );

      return SearchResults.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Search businesses
  Future<SearchResults> searchBusinesses({
    required String query,
    String? category,
    String? location,
    double? latitude,
    double? longitude,
    double? radius,
    String? sortBy,
    String? sortOrder,
    int? minRating,
    List<String>? services,
    bool? verified,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'q': query,
        if (category != null) 'category': category,
        if (location != null) 'location': location,
        if (latitude != null) 'lat': latitude,
        if (longitude != null) 'lng': longitude,
        if (radius != null) 'radius': radius,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
        if (minRating != null) 'minRating': minRating,
        if (services != null) 'services': services.join(','),
        if (verified != null) 'verified': verified,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      };

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/search/businesses',
        queryParameters: queryParams,
      );

      return SearchResults.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Search professionals
  Future<SearchResults> searchProfessionals({
    required String query,
    String? profession,
    String? location,
    double? latitude,
    double? longitude,
    double? radius,
    String? sortBy,
    String? sortOrder,
    int? minRating,
    List<String>? specializations,
    bool? verified,
    bool? availableNow,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'q': query,
        if (profession != null) 'profession': profession,
        if (location != null) 'location': location,
        if (latitude != null) 'lat': latitude,
        if (longitude != null) 'lng': longitude,
        if (radius != null) 'radius': radius,
        if (sortBy != null) 'sortBy': sortBy,
        if (sortOrder != null) 'sortOrder': sortOrder,
        if (minRating != null) 'minRating': minRating,
        if (specializations != null) 'specializations': specializations.join(','),
        if (verified != null) 'verified': verified,
        if (availableNow != null) 'availableNow': availableNow,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
      };

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/search/professionals',
        queryParameters: queryParams,
      );

      return SearchResults.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get search suggestions
  Future<List<String>> getSearchSuggestions(String query) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/search/suggestions',
        queryParameters: {'q': query},
      );

      final suggestions = response['suggestions'] as List;
      return suggestions.cast<String>();
    } catch (e) {
      rethrow;
    }
  }

  // Get popular searches
  Future<List<String>> getPopularSearches() async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/search/popular',
      );

      final searches = response['searches'] as List;
      return searches.cast<String>();
    } catch (e) {
      rethrow;
    }
  }

  // Get search categories
  Future<List<SearchCategory>> getSearchCategories() async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/search/categories',
      );

      final categories = response['categories'] as List;
      return categories.map((cat) => SearchCategory.fromJson(cat)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get nearby services
  Future<List<Service>> getNearbyServices({
    required double latitude,
    required double longitude,
    double? radius,
    String? category,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'lat': latitude,
        'lng': longitude,
        if (radius != null) 'radius': radius,
        if (category != null) 'category': category,
        if (limit != null) 'limit': limit,
      };

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/search/nearby/services',
        queryParameters: queryParams,
      );

      final services = response['services'] as List;
      return services.map((service) => Service.fromJson(service)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get trending searches
  Future<List<TrendingSearch>> getTrendingSearches() async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/search/trending',
      );

      final trends = response['trends'] as List;
      return trends.map((trend) => TrendingSearch.fromJson(trend)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Save search history
  Future<void> saveSearchHistory(String query) async {
    try {
      await ApiClient.instance.post<Map<String, dynamic>>(
        '/search/history',
        data: {'query': query},
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get search history
  Future<List<String>> getSearchHistory() async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/search/history',
      );

      final history = response['history'] as List;
      return history.cast<String>();
    } catch (e) {
      rethrow;
    }
  }

  // Clear search history
  Future<void> clearSearchHistory() async {
    try {
      await ApiClient.instance.delete<Map<String, dynamic>>(
        '/search/history',
      );
    } catch (e) {
      rethrow;
    }
  }
}

class SearchResults {
  const SearchResults({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.hasMore,
    this.filters,
    this.suggestions,
  });

  final List<dynamic> items;
  final int total;
  final int page;
  final int limit;
  final bool hasMore;
  final Map<String, dynamic>? filters;
  final List<String>? suggestions;

  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
      items: json['items'] as List,
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
      hasMore: json['hasMore'] as bool,
      filters: json['filters'] as Map<String, dynamic>?,
      suggestions: json['suggestions']?.cast<String>(),
    );
  }
}

class SearchCategory {
  const SearchCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.subcategories,
  });

  final String id;
  final String name;
  final String icon;
  final List<SearchCategory>? subcategories;

  factory SearchCategory.fromJson(Map<String, dynamic> json) {
    return SearchCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      subcategories: json['subcategories'] != null
          ? (json['subcategories'] as List)
              .map((cat) => SearchCategory.fromJson(cat))
              .toList()
          : null,
    );
  }
}

class TrendingSearch {
  const TrendingSearch({
    required this.query,
    required this.count,
    required this.trend,
  });

  final String query;
  final int count;
  final String trend; // 'up', 'down', 'stable'

  factory TrendingSearch.fromJson(Map<String, dynamic> json) {
    return TrendingSearch(
      query: json['query'] as String,
      count: json['count'] as int,
      trend: json['trend'] as String,
    );
  }
} 