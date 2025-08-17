import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controller/create_meeting_flow_controller.dart';
import 'models/create_meeting_state.dart';

final REDACTED_TOKEN =
    StateNotifierProvider<CreateMeetingFlowController, CreateMeetingState>(
  (ref) => CreateMeetingFlowController(),
);
