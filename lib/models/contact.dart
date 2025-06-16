import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';
part 'contact.g.dart';

@freezed
class Contact with _$Contact {
  const factory Contact({
    required String id,
    required String displayName,
    String? phoneNumber,
    String? email,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}

extension ContactComputed on Contact {
  String get displayName => displayName;
  String? get phoneNumber => phoneNumber;
}
