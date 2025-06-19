import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/facebook_auth_service.dart';

final facebookAuthProvider =
    Provider<FacebookAuthService>((ref) => FacebookAuthService());
