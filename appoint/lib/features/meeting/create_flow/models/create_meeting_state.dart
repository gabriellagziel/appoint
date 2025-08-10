import 'package:flutter/foundation.dart';

enum MeetingType { oneOnOne, group, event, openCall, business, playtime, personal }

enum MeetingStep {
  info,
  participants,
  time,
  location,
  virtualUrl,
  extras,
  review,
}

@immutable
class CreateMeetingState {
  final MeetingType? type;
  final List<String> participantIds;
  final DateTime? start;
  final DateTime? end;
  final String? locationAddress;
  final double? lat;
  final double? lng;
  final String? virtualUrl;
  final String title;
  final String description;
  final Set<MeetingStep> completed;
  final int currentIndex;

  const CreateMeetingState({
    this.type,
    this.participantIds = const [],
    this.start,
    this.end,
    this.locationAddress,
    this.lat,
    this.lng,
    this.virtualUrl,
    this.title = '',
    this.description = '',
    this.completed = const {},
    this.currentIndex = 0,
  });

  CreateMeetingState copyWith({
    MeetingType? type,
    List<String>? participantIds,
    DateTime? start,
    DateTime? end,
    String? locationAddress,
    double? lat,
    double? lng,
    String? virtualUrl,
    String? title,
    String? description,
    Set<MeetingStep>? completed,
    int? currentIndex,
  }) => CreateMeetingState(
        type: type ?? this.type,
        participantIds: participantIds ?? this.participantIds,
        start: start ?? this.start,
        end: end ?? this.end,
        locationAddress: locationAddress ?? this.locationAddress,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        virtualUrl: virtualUrl ?? this.virtualUrl,
        title: title ?? this.title,
        description: description ?? this.description,
        completed: completed ?? this.completed,
        currentIndex: currentIndex ?? this.currentIndex,
      );
}


