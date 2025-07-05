import 'package:json_annotation/json_annotation.dart';

part '../generated/models/provider.g.dart';

@JsonSerializable()
class BusinessProvider {
  final String id;
  final String name;
  final String? role;
  final String businessProfileId;
  final DateTime createdAt;
  final DateTime updatedAt;

  BusinessProvider({
    required this.id,
    required this.name,
    this.role,
    required this.businessProfileId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusinessProvider.fromJson(final Map<String, dynamic> json) =>
      _$BusinessProviderFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessProviderToJson(this);
}
