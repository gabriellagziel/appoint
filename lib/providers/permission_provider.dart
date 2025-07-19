import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/services/permission_service.dart';

final permissionServiceProvider = Provider<PermissionService>((_) => PermissionService());