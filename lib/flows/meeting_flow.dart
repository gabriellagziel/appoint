import 'flow_engine.dart';

FlowEngine createMeetingFlow({
  required String tWho,
  required String tWhat,
  required String tWhen,
  required String tWhere,
  required String tConfirm,
}) {
  return FlowEngine([
    FlowStep(
        key: 'who',
        prompt: tWho,
        validator: (v) => v.isEmpty ? 'Required' : null),
    FlowStep(
        key: 'what',
        prompt: tWhat,
        validator: (v) => v.isEmpty ? 'Required' : null),
    FlowStep(
        key: 'when',
        prompt: tWhen,
        validator: (v) => v.isEmpty ? 'Required' : null),
    FlowStep(
        key: 'where',
        prompt: tWhere,
        validator: (v) => v.isEmpty ? 'Required' : null),
    FlowStep(key: 'confirm', prompt: tConfirm),
  ]);
}
