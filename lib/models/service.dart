/// Service model for search API service
class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final int duration; // in minutes
  final String category;
  final String providerId;
  final List<String> tags;
  final bool isActive;
  final double rating;
  final int reviewCount;
  
  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.category,
    required this.providerId,
    required this.tags,
    this.isActive = true,
    this.rating = 0.0,
    this.reviewCount = 0,
  });
  
  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] as int,
      category: json['category'] as String,
      providerId: json['providerId'] as String,
      tags: List<String>.from(json['tags'] as List),
      isActive: json['isActive'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'category': category,
      'providerId': providerId,
      'tags': tags,
      'isActive': isActive,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }
}