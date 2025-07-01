import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/support_ticket.dart';
import '../services/family_support_service.dart';

final familySupportServiceProvider =
    Provider<FamilySupportService>((ref) => FamilySupportService());

final supportTicketsProvider = StreamProvider<List<SupportTicket>>((ref) {
  return ref.watch(familySupportServiceProvider).watchTickets();
});
