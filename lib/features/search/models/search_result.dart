import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchResult {
  const SearchResult({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.rating,
    required this.imageUrl,
    required this.metadata,
    this.distance,
    this.availability,
    this.price,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) =>
      _$SearchResultFromJson(json);

  final String id;
  final String title;
  final String description;
  final String type; // 'business', 'service', 'user', 'appointment'
  final double rating;
  final String imageUrl;
  final Map<String, dynamic> metadata;
  final double? distance; // in kilometers
  final bool? availability; // is currently available
  final double? price; // price for service

  Map<String, dynamic> toJson() => _$SearchResultToJson(this);

  @override
  String toString() =>
      'SearchResult(id: $id, title: $title, type: $type, rating: $rating)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchResult && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

@JsonSerializable()
class SearchFilters {
  const SearchFilters({
    this.location,
    this.category,
    this.minRating,
    this.maxPrice,
    this.availability,
    this.distance,
    this.sortBy,
  });

  factory SearchFilters.fromJson(Map<String, dynamic> json) =>
      _$SearchFiltersFromJson(json);

  final String? location;
  final String? category;
  final double? minRating;
  final double? maxPrice;
  final bool? availability;
  final double? distance; // max distance in km
  final String? sortBy; // 'rating', 'price', 'distance', 'relevance'

  Map<String, dynamic> toJson() => _$SearchFiltersToJson(this);

  SearchFilters copyWith({
    String? location,
    String? category,
    double? minRating,
    double? maxPrice,
    bool? availability,
    double? distance,
    String? sortBy,
  }) =>
      SearchFilters(
        location: location ?? this.location,
        category: category ?? this.category,
        minRating: minRating ?? this.minRating,
        maxPrice: maxPrice ?? this.maxPrice,
        availability: availability ?? this.availability,
        distance: distance ?? this.distance,
        sortBy: sortBy ?? this.sortBy,
      );
}
