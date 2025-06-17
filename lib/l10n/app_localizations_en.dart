// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Appoint';

  @override
  String get welcome => 'Welcome';

  @override
  String get bookMeeting => 'Book a Meeting';

  @override
  String get selectStaff => 'Select Staff';

  @override
  String get pickDate => 'Pick Date';

  @override
  String get noSlots => 'No slots available';

  @override
  String get next => 'Next';

  @override
  String get shareOnWhatsApp => 'Share on WhatsApp';

  @override
  String get shareMeetingInvitation => 'Share your meeting invitation:';

  @override
  String get meetingReadyMessage =>
      'The meeting is ready! Would you like to send it to your group?';

  @override
  String get customizeMessage => 'Customize your message...';

  @override
  String get saveGroupForRecognition => 'Save group for future recognition';

  @override
  String get groupNameOptional => 'Group Name (optional)';

  @override
  String get enterGroupName => 'Enter group name for recognition';

  @override
  String get knownGroupDetected => 'Known group detected';

  @override
  String get meetingSharedSuccessfully => 'Meeting shared successfully!';

  @override
  String get bookingConfirmedShare =>
      'Booking confirmed! You can now share the invitation.';

  @override
  String get defaultShareMessage =>
      'Hey! I\'ve scheduled a meeting with you through APP-OINT. Click here to confirm or suggest a different time:';
}
