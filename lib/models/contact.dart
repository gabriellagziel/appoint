import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  final String id;
  final String displayName;
  final String phone;
  final String? photoUrl;

  Contact({
    required this.id,
    required this.displayName,
    required this.phone,
    this.photoUrl,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => _$ContactFromJson(json);

  Map<String, dynamic> toJson() => _$ContactToJson(this);
}
