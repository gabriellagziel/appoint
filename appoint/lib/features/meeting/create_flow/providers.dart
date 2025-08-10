import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controller/create_meeting_flow_controller.dart';
import 'models/create_meeting_state.dart';

final createMeetingFlowControllerProvider =
    StateNotifierProvider<CreateMeetingFlowController, CreateMeetingState>(
  (ref) => CreateMeetingFlowController(),
);


