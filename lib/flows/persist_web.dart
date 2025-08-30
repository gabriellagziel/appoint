// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:convert';
import 'flow_engine.dart';

abstract class PersistBackend {
  static Future<void> save(FlowEngine e, {required String key}) async {
    html.window.localStorage[key] = jsonEncode({'i': e.index, 'slots': e.slots});
  }

  static Future<bool> restore(FlowEngine e, {required String key}) async {
    final s = html.window.localStorage[key];
    if (s == null) return false;
    final m = jsonDecode(s) as Map<String, dynamic>;
    final i = (m['i'] as num?)?.toInt() ?? 0;
    final slots = (m['slots'] as Map?)?.cast<String, String>() ?? {};
    e.slots
      ..clear()
      ..addAll(slots);
    while (e.index < i && !e.isLast) e.next();
    return true;
  }

  static Future<void> clear({required String key}) async {
    html.window.localStorage.remove(key);
  }
}
