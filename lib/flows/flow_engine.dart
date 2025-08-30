import 'package:flutter/foundation.dart';

typedef Validator = String? Function(String value);

class FlowStep {
  final String key; // who/what/when/where/confirm
  final String prompt;
  final Validator? validator;

  const FlowStep({required this.key, required this.prompt, this.validator});
}

class FlowEngine extends ChangeNotifier {
  final List<FlowStep> steps;
  final Map<String, String> slots = {};
  int _index = 0;

  FlowEngine(this.steps);

  int get index => _index;
  FlowStep get current => steps[_index];
  bool get isFirst => _index == 0;
  bool get isLast => _index == steps.length - 1;

  void setSlot(String key, String value) {
    slots[key] = value;
    notifyListeners();
  }

  bool next([String? input]) {
    if (input != null) setSlot(current.key, input);
    if (!isLast) {
      _index++;
      notifyListeners();
      return true;
    }
    return false;
  }

  bool back() {
    if (!isFirst) {
      _index--;
      notifyListeners();
      return true;
    }
    return false;
  }

  void reset() {
    _index = 0;
    slots.clear();
    notifyListeners();
  }
}
