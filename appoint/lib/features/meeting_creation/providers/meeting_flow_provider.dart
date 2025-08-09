import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/meeting_flow_controller.dart';

final meetingFlowControllerProvider = StateNotifierProvider<MeetingFlowController, MeetingFlowState>(
  (ref) => MeetingFlowController(),
);
