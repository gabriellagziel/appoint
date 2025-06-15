import 'package:freezed_annotation/freezed_annotation.dart';

part 'tmp_test.freezed.dart';
part 'tmp_test.g.dart';

@freezed
class Tmp with _$Tmp {
  factory Tmp({
    required String id,
    @JsonKey(fromJson: _fromJson, toJson: _toJson) required DateTime time,
  }) = _Tmp;

  factory Tmp.fromJson(Map<String, dynamic> json) => _$TmpFromJson(json);
}

DateTime _fromJson(String date) => DateTime.parse(date);
String _toJson(DateTime date) => date.toIso8601String();
