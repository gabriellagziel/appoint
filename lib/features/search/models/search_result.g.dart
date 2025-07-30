// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult _$SearchResultFromJson(Map<String, dynamic> json) => SearchResult(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['image_url'] as String,
      metadata: json['metadata'] as Map<String, dynamic>,
      distance: (json['distance'] as num?)?.toDouble(),
      availability: json['availability'] as bool?,
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SearchResultToJson(SearchResult instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'title': instance.title,
    'description': instance.description,
    'type': instance.type,
    'rating': instance.rating,
    'image_url': instance.imageUrl,
    'metadata': instance.metadata,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('distance', instance.distance);
  writeNotNull('availability', instance.availability);
  writeNotNull('price', instance.price);
  return val;
}

SearchFilters _$SearchFiltersFromJson(Map<String, dynamic> json) =>
    SearchFilters(
      location: json['location'] as String?,
      category: json['category'] as String?,
      minRating: (json['min_rating'] as num?)?.toDouble(),
      maxPrice: (json['max_price'] as num?)?.toDouble(),
      availability: json['availability'] as bool?,
      distance: (json['distance'] as num?)?.toDouble(),
      sortBy: json['sort_by'] as String?,
    );

Map<String, dynamic> _$SearchFiltersToJson(SearchFilters instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('location', instance.location);
  writeNotNull('category', instance.category);
  writeNotNull('min_rating', instance.minRating);
  writeNotNull('max_price', instance.maxPrice);
  writeNotNull('availability', instance.availability);
  writeNotNull('distance', instance.distance);
  writeNotNull('sort_by', instance.sortBy);
  return val;
}
