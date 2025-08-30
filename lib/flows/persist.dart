import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'flow_engine.dart';

// Conditional import for web
import 'dart:html' if (dart.library.io) 'dart:io' as html;

class FlowPersist {
  static Future<void> save(FlowEngine engine, {String key = 'flow_state'}) async {
    final payload = jsonEncode({
      'i': engine.index,
      'slots': engine.slots,
    });
    if (kIsWeb) {
      // web localStorage
      // ignore: avoid_web_libraries_in_flutter
      html.window.localStorage[key] = payload;
    } else {
      // minimal file-less fallback: keep in memory static (works for app sessions)
      _Mem.store[key] = payload;
    }
  }

  static Future<bool> restore(FlowEngine engine, {String key = 'flow_state'}) async {
    String? payload;
    if (kIsWeb) {
      // ignore: avoid_web_libraries_in_flutter
      payload = html.window.localStorage[key];
    } else {
      payload = _Mem.store[key];
    }
    if (payload == null) return false;
    final m = jsonDecode(payload) as Map<String, dynamic>;
    final i = (m['i'] as num?)?.toInt() ?? 0;
    final slots = (m['slots'] as Map?)?.cast<String, String>() ?? {};
    engine.slots.clear();
    engine.slots.addAll(slots);
    while (engine.index < i && !engine.isLast) {
      engine.next(null);
    }
    return true;
  }

  static Future<void> clear({String key = 'flow_state'}) async {
    if (kIsWeb) {
      // ignore: avoid_web_libraries_in_flutter
      html.window.localStorage.remove(key);
    } else {
      _Mem.store.remove(key);
    }
  }
}

class _Mem { static final Map<String,String> store = {}; }
