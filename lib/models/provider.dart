import 'package:json_annotation/json_annotation.dart';

part 'provider.g.dart';

@JsonSerializable()
class BusinessProvider {
  BusinessProvider({
    required this.id,
    required this.name,
    required this.businessProfileId,
    required this.createdAt,
    required this.updatedAt,
    this.role,
  });

  factory BusinessProvider.fromJson(Map<String, dynamic> json) =>
      _$BusinessProviderFromJson(json);
  final String id;
  final String name;
  final String? role;
  final String businessProfileId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => _$BusinessProviderToJson(this);
}
