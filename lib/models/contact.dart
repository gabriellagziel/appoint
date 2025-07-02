import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/contact.freezed.dart';
part '../generated/models/contact.g.dart';

@freezed
class Contact with _$Contact {
  const factory Contact({
    required final String id,
    required final String displayName,
    final String? phoneNumber,
    final String? email,
  }) = _Contact;

  factory Contact.fromJson(final Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}
