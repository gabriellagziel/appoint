import 'package:appoint/services/permission_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final permissionServiceProvider =
    Provider<PermissionService>((_) => PermissionService());
