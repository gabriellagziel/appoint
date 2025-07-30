import 'package:json_annotation/json_annotation.dart';

part 'organization.g.dart';

@JsonSerializable()
class Organization {
  Organization({
    required this.id,
    required this.name,
    required this.memberIds,
  });

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);
  final String id;
  final String name;
  final List<String> memberIds;

  Map<String, dynamic> toJson() => _$OrganizationToJson(this);
}
