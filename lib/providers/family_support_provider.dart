import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/models/support_ticket.dart';
import 'package:appoint/services/family_support_service.dart';

final familySupportServiceProvider =
    Provider<FamilySupportService>((final ref) => FamilySupportService());

final supportTicketsProvider = StreamProvider<List<SupportTicket>>((final ref) {
  return ref.watch(familySupportServiceProvider).watchTickets();
});
