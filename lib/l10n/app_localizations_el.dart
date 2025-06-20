// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'Appoint';

  @override
  String get welcome => 'Καλώς ήρθατε';

  @override
  String get home => 'Αρχική';

  @override
  String get menu => 'Μενού';

  @override
  String get profile => 'Προφίλ';

  @override
  String get signOut => 'Αποσύνδεση';

  @override
  String get login => 'Σύνδεση';

  @override
  String get email => 'Ηλεκτρονικό ταχυδρομείο';

  @override
  String get password => 'Κωδικός πρόσβασης';

  @override
  String get signIn => 'Είσοδος';

  @override
  String get bookMeeting => 'Κλείσιμο συνάντησης';

  @override
  String get bookAppointment => 'Κλείσιμο ραντεβού';

  @override
  String get bookingRequest => 'Αίτημα κράτησης';

  @override
  String get confirmBooking => 'Επιβεβαίωση κράτησης';

  @override
  String get chatBooking => 'Κράτηση μέσω συνομιλίας';

  @override
  String get bookViaChat => 'Κλείσιμο μέσω συνομιλίας';

  @override
  String get submitBooking => 'Υποβολή κράτησης';

  @override
  String get next => 'Επόμενο';

  @override
  String get selectStaff => 'Επιλογή προσωπικού';

  @override
  String get pickDate => 'Επιλέξτε ημερομηνία';

  @override
  String get staff => 'Προσωπικό';

  @override
  String get service => 'Υπηρεσία';

  @override
  String get dateTime => 'Ημερομηνία και ώρα';

  @override
  String duration(String duration) {
    return 'Διάρκεια: $duration λεπτά';
  }

  @override
  String get notSelected => 'Δεν έχει επιλεγεί';

  @override
  String get noSlots => 'Δεν υπάρχουν διαθέσιμα ραντεβού';

  @override
  String get bookingConfirmed => 'Η κράτηση επιβεβαιώθηκε';

  @override
  String get failedToConfirmBooking => 'Αποτυχία επιβεβαίωσης κράτησης';

  @override
  String get noBookingsFound => 'Δεν βρέθηκαν κρατήσεις';

  @override
  String errorLoadingBookings(String error) {
    return 'Σφάλμα φόρτωσης κρατήσεων: $error';
  }

  @override
  String get shareOnWhatsApp => 'Κοινοποίηση στο WhatsApp';

  @override
  String get shareMeetingInvitation => 'Κοινοποιήστε την πρόσκληση συνάντησης:';

  @override
  String get meetingReadyMessage =>
      'Η συνάντηση είναι έτοιμη! Θέλετε να την στείλετε στην ομάδα σας;';

  @override
  String get customizeMessage => 'Προσαρμόστε το μήνυμά σας...';

  @override
  String get saveGroupForRecognition =>
      'Αποθήκευση ομάδας για αναγνώριση στο μέλλον';

  @override
  String get groupNameOptional => 'Όνομα ομάδας (προαιρετικό)';

  @override
  String get enterGroupName => 'Εισάγετε όνομα ομάδας για αναγνώριση';

  @override
  String get knownGroupDetected => 'Ανιχνεύθηκε γνωστή ομάδα';

  @override
  String get meetingSharedSuccessfully => 'Η συνάντηση κοινοποιήθηκε επιτυχώς!';

  @override
  String get bookingConfirmedShare =>
      'Η κράτηση επιβεβαιώθηκε! Μπορείτε τώρα να κοινοποιήσετε την πρόσκληση.';

  @override
  String get defaultShareMessage =>
      'Γεια! Προγραμματίσαμε μια συνάντηση μέσω APP‑OINT. Κάντε κλικ εδώ για επιβεβαίωση ή πρόταση άλλης ώρας:';

  @override
  String get dashboard => 'Πίνακας ελέγχου';

  @override
  String get businessDashboard => 'Επιχειρηματικός πίνακας';

  @override
  String get myProfile => 'Το προφίλ μου';

  @override
  String get noProfileFound => 'Δεν βρέθηκε προφίλ';

  @override
  String get errorLoadingProfile => 'Σφάλμα φόρτωσης προφίλ';

  @override
  String get myInvites => 'Οι προσκλήσεις μου';

  @override
  String get inviteDetail => 'Λεπτομέρειες πρόσκλησης';

  @override
  String get inviteContact => 'Επαφή πρόσκλησης';

  @override
  String get noInvites => 'Δεν υπάρχουν προσκλήσεις';

  @override
  String get errorLoadingInvites => 'Σφάλμα φόρτωσης προσκλήσεων';

  @override
  String get accept => 'Αποδοχή';

  @override
  String get decline => 'Απόρριψη';

  @override
  String get sendInvite => 'Αποστολή πρόσκλησης';

  @override
  String get name => 'Όνομα';

  @override
  String get phoneNumber => 'Τηλέφωνο';

  @override
  String get emailOptional => 'Ηλεκτρονικό ταχυδρομείο (προαιρετικό)';

  @override
  String get requiresInstallFallback => 'Απαιτεί εγκατάσταση';

  @override
  String get notifications => 'Ειδοποιήσεις';

  @override
  String get notificationSettings => 'Ρυθμίσεις ειδοποιήσεων';

  @override
  String get enableNotifications => 'Ενεργοποίηση ειδοποιήσεων';

  @override
  String get errorFetchingToken => 'Σφάλμα λήψης κλειδιού';

  @override
  String fcmToken(String token) {
    return 'FCM Token: $token';
  }

  @override
  String get familyDashboard => 'Οικογενειακός πίνακας';

  @override
  String get pleaseLoginForFamilyFeatures =>
      'Συνδεθείτε για πρόσβαση σε οικογενειακές λειτουργίες';

  @override
  String get familyMembers => 'Μέλη οικογένειας';

  @override
  String get invite => 'Πρόσκληση';

  @override
  String get pendingInvites => 'Εκκρεμείς προσκλήσεις';

  @override
  String get connectedChildren => 'Συνδεδεμένα παιδιά';

  @override
  String get noFamilyMembersYet =>
      'Δεν υπάρχουν ακόμα μέλη οικογένειας. Στείλτε μια πρόσκληση για να ξεκινήσετε!';

  @override
  String errorLoadingFamilyLinks(String error) {
    return 'Σφάλμα φόρτωσης οικογενειακών συνδέσεων: $error';
  }

  @override
  String get inviteChild => 'Πρόσκληση παιδιού';

  @override
  String get managePermissions => 'Διαχείριση δικαιωμάτων';

  @override
  String get removeChild => 'Αφαίρεση παιδιού';

  @override
  String get loading => 'Φόρτωση...';

  @override
  String get childEmail => 'Email παιδιού';

  @override
  String get childEmailOrPhone => 'Email ή τηλέφωνο παιδιού';

  @override
  String get enterChildEmail => 'Εισάγετε email παιδιού';

  @override
  String get otpCode => 'Κωδικός OTP';

  @override
  String get enterOtp => 'Εισάγετε OTP';

  @override
  String get verify => 'Επαλήθευση';

  @override
  String get otpResentSuccessfully =>
      'Ο κωδικός OTP στάλθηκε ξανά με επιτυχία!';

  @override
  String failedToResendOtp(String error) {
    return 'Αποτυχία επανυποβολής OTP: $error';
  }

  @override
  String get childLinkedSuccessfully => 'Το παιδί συνδέθηκε με επιτυχία!';

  @override
  String get invitationSentSuccessfully => 'Η πρόσκληση στάλθηκε επιτυχώς!';

  @override
  String failedToSendInvitation(String error) {
    return 'Αποτυχία αποστολής πρόσκλησης: $error';
  }

  @override
  String get pleaseEnterValidEmail => 'Παρακαλώ εισάγετε έγκυρο email';

  @override
  String get pleaseEnterValidEmailOrPhone =>
      'Παρακαλώ εισάγετε έγκυρο email ή τηλέφωνο';

  @override
  String get invalidCode => 'Μη έγκυρος κωδικός, δοκιμάστε ξανά';

  @override
  String get cancelInvite => 'Ακύρωση πρόσκλησης';

  @override
  String get cancelInviteConfirmation =>
      'Είστε σίγουρος ότι θέλετε να ακυρώσετε αυτή την πρόσκληση;';

  @override
  String get no => 'Όχι';

  @override
  String get yesCancel => 'Ναι, ακύρωση';

  @override
  String get inviteCancelledSuccessfully => 'Η πρόσκληση ακυρώθηκε επιτυχώς!';

  @override
  String failedToCancelInvite(String error) {
    return 'Αποτυχία ακύρωσης πρόσκλησης: $error';
  }

  @override
  String get revokeAccess => 'Ανάκληση πρόσβασης';

  @override
  String get revokeAccessConfirmation =>
      'Είστε σίγουρος ότι θέλετε να ανακαλέσετε την πρόσβαση για αυτό το παιδί; Αυτή η ενέργεια δεν αναιρείται.';

  @override
  String get revoke => 'Ανακαλέστε';

  @override
  String get accessRevokedSuccessfully => 'Η πρόσβαση ανακλήθηκε επιτυχώς!';

  @override
  String failedToRevokeAccess(String error) {
    return 'Αποτυχία ανάκλησης πρόσβασης: $error';
  }

  @override
  String get grantConsent => 'Παροχή συγκατάθεσης';

  @override
  String get revokeConsent => 'Ανάκληση συγκατάθεσης';

  @override
  String get consentGrantedSuccessfully => 'Η συγκατάθεση δόθηκε επιτυχώς!';

  @override
  String get consentRevokedSuccessfully => 'Η συγκατάθεση ανακλήθηκε επιτυχώς!';

  @override
  String failedToUpdateConsent(String error) {
    return 'Αποτυχία ενημέρωσης συγκατάθεσης: $error';
  }

  @override
  String get checkingPermissions => 'Έλεγχος δικαιωμάτων...';

  @override
  String get cancel => 'Ακύρωση';

  @override
  String get close => 'Κλείσιμο';

  @override
  String get save => 'Αποθήκευση';

  @override
  String get sendNow => 'Αποστολή τώρα';

  @override
  String get details => 'Λεπτομέρειες';

  @override
  String get noBroadcastMessages => 'Δεν υπάρχουν ακόμα μηνύματα broadcast';

  @override
  String errorCheckingPermissions(String error) {
    return 'Σφάλμα ελέγχου δικαιωμάτων: $error';
  }

  @override
  String get mediaOptional => 'Μέσα (προαιρετικά)';

  @override
  String get pickImage => 'Επιλογή εικόνας';

  @override
  String get pickVideo => 'Επιλογή βίντεο';

  @override
  String get pollOptions => 'Επιλογές ψηφοφορίας:';

  @override
  String get targetingFilters => 'Φίλτρα στόχευσης';

  @override
  String get scheduling => 'Προγραμματισμός';

  @override
  String get scheduleForLater => 'Προγραμματισμός για αργότερα';

  @override
  String errorEstimatingRecipients(String error) {
    return 'Σφάλμα εκτίμησης παραληπτών: $error';
  }

  @override
  String errorPickingImage(String error) {
    return 'Σφάλμα επιλογής εικόνας: $error';
  }

  @override
  String errorPickingVideo(String error) {
    return 'Σφάλμα επιλογής βίντεο: $error';
  }

  @override
  String get noPermissionForBroadcast =>
      'Δεν έχετε άδεια για δημιουργία μηνυμάτων broadcast.';

  @override
  String get messageSavedSuccessfully => 'Το μήνυμα αποθηκεύτηκε με επιτυχία';

  @override
  String errorSavingMessage(String error) {
    return 'Σφάλμα αποθήκευσης μηνύματος: $error';
  }

  @override
  String get messageSentSuccessfully => 'Το μήνυμα στάλθηκε με επιτυχία';

  @override
  String errorSendingMessage(String error) {
    return 'Σφάλμα αποστολής μηνύματος: $error';
  }

  @override
  String content(String content) {
    return 'Περιεχόμενο: $content';
  }

  @override
  String type(String type) {
    return 'Τύπος: $type';
  }

  @override
  String link(String link) {
    return 'Σύνδεσμος: $link';
  }

  @override
  String status(String status) {
    return 'Κατάσταση: $status';
  }

  @override
  String recipients(String count) {
    return 'Παραλήπτες: $count';
  }

  @override
  String opened(String count) {
    return 'Ανοίχθηκε: $count';
  }

  @override
  String clicked(String count) {
    return 'Κλικ: $count';
  }

  @override
  String created(String date) {
    return 'Δημιουργήθηκε: $date';
  }

  @override
  String scheduled(String date) {
    return 'Προγραμματίστηκε: $date';
  }

  @override
  String get organizations => 'Οργανισμοί';

  @override
  String get noOrganizations => 'Δεν υπάρχουν οργανισμοί';

  @override
  String get errorLoadingOrganizations => 'Σφάλμα φόρτωσης οργανισμών';

  @override
  String members(String count) {
    return '$count μέλη';
  }

  @override
  String get users => 'Χρήστες';

  @override
  String get noUsers => 'Δεν υπάρχουν χρήστες';

  @override
  String get errorLoadingUsers => 'Σφάλμα φόρτωσης χρηστών';

  @override
  String get changeRole => 'Αλλαγή ρόλου';

  @override
  String get totalAppointments => 'Συνολικά ραντεβού';

  @override
  String get completedAppointments => 'Ολοκληρωμένα ραντεβού';

  @override
  String get revenue => 'Έσοδα';

  @override
  String get errorLoadingStats => 'Σφάλμα φόρτωσης στατιστικών';

  @override
  String appointment(String id) {
    return 'Ραντεβού: $id';
  }

  @override
  String from(String name) {
    return 'Από: $name';
  }

  @override
  String phone(String number) {
    return 'Τηλέφωνο: $number';
  }

  @override
  String noRouteDefined(String route) {
    return 'Δεν έχει οριστεί διαδρομή για $route';
  }

  @override
  String get meetingDetails => 'Λεπτομέρειες συνάντησης';

  @override
  String meetingId(String id) {
    return 'Αναγνωριστικό συνάντησης: $id';
  }

  @override
  String creator(String id) {
    return 'Δημιουργός: $id';
  }

  @override
  String context(String id) {
    return 'Συμφραζόμενα: $id';
  }

  @override
  String group(String id) {
    return 'Ομάδα: $id';
  }

  @override
  String get requestPrivateSession => 'Αίτηση για ιδιωτική συνεδρία';

  @override
  String get privacyRequestSent =>
      'Αίτηση ιδιωτικότητας στάλθηκε στους γονείς!';

  @override
  String failedToSendPrivacyRequest(String error) {
    return 'Αποτυχία αποστολής αίτησης ιδιωτικότητας: $error';
  }

  @override
  String errorLoadingPrivacyRequests(String error) {
    return 'Σφάλμα φόρτωσης αιτημάτων ιδιωτικότητας: $error';
  }

  @override
  String requestType(String type) {
    return 'Αίτημα $type';
  }

  @override
  String statusColon(String status) {
    return 'Κατάσταση: $status';
  }

  @override
  String failedToActionPrivacyRequest(String action, String error) {
    return 'Αποτυχία $action αιτήματος ιδιωτικότητας: $error';
  }

  @override
  String get yes => 'Ναι';

  @override
  String get send => 'Αποστολή';

  @override
  String get permissions => 'Δικαιώματα';

  @override
  String permissionsFor(String childId) {
    return 'Δικαιώματα – $childId';
  }

  @override
  String errorLoadingPermissions(String error) {
    return 'Σφάλμα φόρτωσης δικαιωμάτων: $error';
  }

  @override
  String get none => 'Κανένα';

  @override
  String get readOnly => 'Μόνο ανάγνωση';

  @override
  String get readWrite => 'Ανάγνωση και εγγραφή';

  @override
  String permissionUpdated(String category, String newValue) {
    return 'Το δικαίωμα $category ενημερώθηκε σε $newValue';
  }

  @override
  String failedToUpdatePermission(String error) {
    return 'Αποτυχία ενημέρωσης δικαιώματος: $error';
  }

  @override
  String invited(String date) {
    return 'Προσκληθεί: $date';
  }

  @override
  String get adminBroadcast => 'Broadcast διαχειριστή';

  @override
  String get composeBroadcastMessage => 'Σύνθεση μηνύματος broadcast';

  @override
  String get adminScreenTBD => 'Οθόνη διαχειριστή – Σε εξέλιξη';

  @override
  String get staffScreenTBD => 'Οθόνη προσωπικού – Σε εξέλιξη';

  @override
  String get clientScreenTBD => 'Οθόνη πελάτη – Σε εξέλιξη';

  @override
  String get ambassadorTitle => 'Πρέσβης';

  @override
  String get ambassadorOnboardingTitle => 'Γίνετε Πρέσβης';

  @override
  String get ambassadorOnboardingSubtitle =>
      'Βοηθήστε να αναπτύξουμε την κοινότητά μας στη γλώσσα και την περιοχή σας.';

  @override
  String get ambassadorOnboardingButton => 'Ξεκινήστε Τώρα';

  @override
  String get ambassadorDashboardTitle => 'Πίνακας Ελέγχου Πρέσβη';

  @override
  String get ambassadorDashboardSubtitle =>
      'Επισκόπηση των στατιστικών και δραστηριοτήτων σας';

  @override
  String get ambassadorDashboardChartLabel =>
      'Προσκληθέντες Χρήστες Αυτή την Εβδομάδα';

  @override
  String get ambassadorDashboardRemainingSlots =>
      'Εναπομείναντες Θέσεις Πρέσβη';

  @override
  String get ambassadorDashboardCountryLanguage => 'Χώρα και Γλώσσα';

  @override
  String get ambassadorQuotaFull =>
      'Η ποσόστωση πρέσβη είναι πλήρης στην περιοχή σας.';

  @override
  String get ambassadorQuotaAvailable => 'Θέσεις πρέσβη διαθέσιμες!';

  @override
  String get ambassadorStatusAssigned => 'Είστε ενεργός πρέσβης.';

  @override
  String get ambassadorStatusNotEligible =>
      'Δεν είστε επιλέξιμος για το καθεστώς πρέσβη.';

  @override
  String get ambassadorStatusWaiting => 'Αναμονή για διαθεσιμότητα θέσης...';

  @override
  String get ambassadorStatusRevoked =>
      'Το καθεστώς πρέσβη σας έχει ανακληθεί.';

  @override
  String get ambassadorNoticeAdultOnly =>
      'Μόνο λογαριασμοί ενηλίκων μπορούν να γίνουν πρέσβεις.';

  @override
  String get ambassadorNoticeQuotaReached =>
      'Η ποσόστωση πρέσβη για τη χώρα και γλώσσα σας έχει εξαντληθεί.';

  @override
  String get ambassadorNoticeAutoAssign =>
      'Η πρεσβεία χορηγείται αυτόματα σε επιλέξιμους χρήστες.';
}
