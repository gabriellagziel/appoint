import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/playtime_controller.dart';

final playtimeControllerProvider = StateNotifierProvider<PlaytimeController, PlaytimeState>(
  (ref) => PlaytimeController(),
);
