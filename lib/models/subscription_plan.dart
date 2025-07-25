/// Subscription plan model for payment API service
class SubscriptionPlan {
  final String id;
  final String name;
  final double price;
  final String interval; // 'monthly', 'yearly'
  final List<String> features;
  final bool isPopular;
  
  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.interval,
    required this.features,
    this.isPopular = false,
  });
  
  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      interval: json['interval'] as String,
      features: List<String>.from(json['features'] as List),
      isPopular: json['isPopular'] as bool? ?? false,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'interval': interval,
      'features': features,
      'isPopular': isPopular,
    };
  }
}