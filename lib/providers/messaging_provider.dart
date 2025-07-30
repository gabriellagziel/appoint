import 'package:appoint/features/messaging/services/messaging_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the messaging service
final messagingServiceProvider = Provider<MessagingService>((ref) => MessagingService());