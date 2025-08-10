import '../models/create_meeting_state.dart';

List<MeetingStep> stepsFor(MeetingType type, {bool playtimeVirtual = false}) {
  switch (type) {
    case MeetingType.openCall:
      return [
        MeetingStep.info,
        MeetingStep.time,
        MeetingStep.virtualUrl,
        MeetingStep.review,
      ];
    case MeetingType.event:
      return [
        MeetingStep.info,
        MeetingStep.participants,
        MeetingStep.time,
        MeetingStep.location,
        MeetingStep.extras,
        MeetingStep.review,
      ];
    case MeetingType.playtime:
      return playtimeVirtual
          ? [
              MeetingStep.info,
              MeetingStep.participants,
              MeetingStep.time,
              MeetingStep.virtualUrl,
              MeetingStep.extras,
              MeetingStep.review,
            ]
          : [
              MeetingStep.info,
              MeetingStep.participants,
              MeetingStep.time,
              MeetingStep.location,
              MeetingStep.extras,
              MeetingStep.review,
            ];
    case MeetingType.business:
    case MeetingType.group:
    case MeetingType.oneOnOne:
    case MeetingType.personal:
      return [
        MeetingStep.info,
        MeetingStep.participants,
        MeetingStep.time,
        MeetingStep.location,
        MeetingStep.review,
      ];
  }
}


