import 'package:appoint/models/support_ticket.dart';
import 'package:appoint/services/family_support_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final familySupportServiceProvider =
    Provider<FamilySupportService>((ref) => FamilySupportService());

final supportTicketsProvider = StreamProvider<List<SupportTicket>>(
    (ref) => ref.watch(familySupportServiceProvider).watchTickets());
