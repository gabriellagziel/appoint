import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/email_service.dart';

final emailServiceProvider = Provider<EmailService>((ref) => EmailService());
