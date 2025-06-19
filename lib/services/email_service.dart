import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  late final SmtpServer _server;

  EmailService() {
    final host = dotenv.env['SMTP_HOST'] ?? '';
    final username = dotenv.env['SMTP_USERNAME'] ?? '';
    final password = dotenv.env['SMTP_PASSWORD'] ?? '';
    final port = int.tryParse(dotenv.env['SMTP_PORT'] ?? '587') ?? 587;
    _server = SmtpServer(host,
        username: username, password: password, port: port, ignoreBadCertificate: true);
  }

  Future<void> sendEmail({
    required String to,
    required String subject,
    required String body,
  }) async {
    final message = Message()
      ..from = Address(dotenv.env['SMTP_USERNAME'] ?? '')
      ..recipients.add(to)
      ..subject = subject
      ..text = body;

    await send(message, _server);
  }
}
