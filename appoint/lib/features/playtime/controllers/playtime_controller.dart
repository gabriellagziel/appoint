import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/playtime_model.dart';

class PlaytimeController extends StateNotifier<PlaytimeConfig?> {
  PlaytimeController() : super(null);

  void setPlaytimeType(PlaytimeType type) {
    if (state == null) {
      state = PlaytimeConfig(type: type);
    } else {
      state = state!.copyWith(type: type);
    }
  }

  void setPlatform(PlaytimePlatform platform) {
    if (state != null) {
      state = state!.copyWith(platform: platform);
    }
  }

  void setRoomCode(String roomCode) {
    if (state != null) {
      state = state!.copyWith(roomCode: roomCode);
    }
  }

  void setServerCode(String serverCode) {
    if (state != null) {
      state = state!.copyWith(serverCode: serverCode);
    }
  }

  void setGame(String game) {
    if (state != null) {
      state = state!.copyWith(game: game);
    }
  }

  void setLocation(String location) {
    if (state != null) {
      state = state!.copyWith(location: location);
    }
  }

  void setMaxPlayers(int maxPlayers) {
    if (state != null) {
      state = state!.copyWith(maxPlayers: maxPlayers);
    }
  }

  void setCompetitive(bool isCompetitive) {
    if (state != null) {
      state = state!.copyWith(isCompetitive: isCompetitive);
    }
  }

  void setFamilyFriendly(bool isFamilyFriendly) {
    if (state != null) {
      state = state!.copyWith(isFamilyFriendly: isFamilyFriendly);
    }
  }

  void selectGame(PopularGame game) {
    if (state != null) {
      state = state!.copyWith(
        game: game.name,
        platform: game.platform,
        isCompetitive: game.isCompetitive,
        isFamilyFriendly: game.isFamilyFriendly,
      );
    }
  }

  void reset() {
    state = null;
  }

  bool get isValid => state?.isValid ?? false;
  String? get validationError => state?.validationError;
  bool get requiresLocation => state?.requiresLocation ?? false;
  bool get requiresPlatform => state?.requiresPlatform ?? false;
  bool get requiresRoomCode => state?.requiresRoomCode ?? false;
  bool get requiresServerCode => state?.requiresServerCode ?? false;

  PlaytimeConfig? get config => state;
}

final playtimeControllerProvider =
    StateNotifierProvider<PlaytimeController, PlaytimeConfig?>((ref) {
  return PlaytimeController();
});

final playtimeValidationProvider = Provider<bool>((ref) {
  final controller = ref.watch(playtimeControllerProvider.notifier);
  return controller.isValid;
});

final playtimeValidationErrorProvider = Provider<String?>((ref) {
  final controller = ref.watch(playtimeControllerProvider.notifier);
  return controller.validationError;
});



