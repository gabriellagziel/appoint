/// Business model representing a business in the App-Oint system
/// 
/// Contains business information including ID, name, description, contact details, and services
class Business {
  /// Unique business identifier
  final String id;
  
  /// Business name
  final String name;
  
  /// Business description
  final String description;
  
  /// Business address
  final String address;
  
  /// Business phone number
  final String phone;
  
  /// Business email address
  final String email;
  
  /// List of services offered by the business
  final List<String> services;

  const Business({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.email,
    required this.services,
  });

  /// Create Business from JSON
  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      services: (json['services'] as List).cast<String>(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
      'services': services,
    };
  }

  @override
  String toString() {
    return 'Business(id: $id, name: $name, description: $description, address: $address, phone: $phone, email: $email, services: $services)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Business &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.address == address &&
        other.phone == phone &&
        other.email == email &&
        other.services == services;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, description, address, phone, email, services);
  }
} 