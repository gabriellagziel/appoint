// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hausa (`ha`).
class AppLocalizationsHa extends AppLocalizations {
  AppLocalizationsHa([String locale = 'ha']) : super(locale);

  @override
  String get appTitle => 'Appoint';

  @override
  String get welcome => 'Barka da zuwa';

  @override
  String get home => 'Farko';

  @override
  String get menu => 'Menu';

  @override
  String get profile => 'Bayani';

  @override
  String get signOut => 'Fice';

  @override
  String get login => 'Shiga';

  @override
  String get email => 'Imel';

  @override
  String get password => 'Kalmar wucewa';

  @override
  String get signIn => 'Shiga ciki';

  @override
  String get bookMeeting => 'Tanadi Taro';

  @override
  String get bookAppointment => 'Tanadi Haduwa';

  @override
  String get bookingRequest => 'Buƙatar tanadi';

  @override
  String get confirmBooking => 'Tabbatar da tanadi';

  @override
  String get chatBooking => 'Tanadi ta hira';

  @override
  String get bookViaChat => 'Tanadi ta hira';

  @override
  String get submitBooking => 'Miƙa tanadi';

  @override
  String get next => 'Gaba';

  @override
  String get selectStaff => 'Zaɓi ma\'aikata';

  @override
  String get pickDate => 'Zaɓi Kwanan wata';

  @override
  String get staff => 'Ma\'aikata';

  @override
  String get service => 'Sabis';

  @override
  String get dateTime => 'Kwanan wata & Lokaci';

  @override
  String duration(String duration) {
    return 'Tsawon lokaci: $duration minti';
  }

  @override
  String get notSelected => 'Ba a zaɓi ba';

  @override
  String get noSlots => 'Babu wurare';

  @override
  String get bookingConfirmed => 'An tabbatar da tanadi';

  @override
  String get failedToConfirmBooking => 'An kasa tabbatar da tanadi';

  @override
  String get noBookingsFound => 'Ba a sami tanadi ba';

  @override
  String errorLoadingBookings(String error) {
    return 'Kuskure wajen ɗora tanadi: $error';
  }

  @override
  String get shareOnWhatsApp => 'Raba a WhatsApp';

  @override
  String get shareMeetingInvitation => 'Raba gayyatar taro:';

  @override
  String get meetingReadyMessage =>
      'An shirya taro! Kuna son a tura shi zuwa rukunin ku?';

  @override
  String get customizeMessage => 'Keɓance saƙonka...';

  @override
  String get saveGroupForRecognition => 'Ajiye rukuni don gane shi gaba';

  @override
  String get groupNameOptional => 'Sunan rukuni (zaɓi)';

  @override
  String get enterGroupName => 'Shigar da sunan rukuni don gane shi';

  @override
  String get knownGroupDetected => 'An sami sanannen rukuni';

  @override
  String get meetingSharedSuccessfully => 'An raba taron cikin nasara!';

  @override
  String get bookingConfirmedShare =>
      'An tabbatar da tanadi! Yanzu za ka iya raba gayyata.';

  @override
  String get defaultShareMessage =>
      'Sannu! Mun shirya taro tare da kai ta APP‑OINT. Danna nan don tabbatarwa ko ba da shawarar wata lokaci:';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get businessDashboard => 'Dashboard na kasuwanci';

  @override
  String get myProfile => 'Bayana';

  @override
  String get noProfileFound => 'Ba a sami bayani ba';

  @override
  String get errorLoadingProfile => 'Kuskure wajen ɗora bayani';

  @override
  String get myInvites => 'Gayyatar da na samu';

  @override
  String get inviteDetail => 'Cikakken gayyata';

  @override
  String get inviteContact => 'Tuntuɓi gayyata';

  @override
  String get noInvites => 'Babu gayyata';

  @override
  String get errorLoadingInvites => 'Kuskure wajen ɗora gayyata';

  @override
  String get accept => 'Amince';

  @override
  String get decline => 'Kiɗe';

  @override
  String get sendInvite => 'Aika gayyata';

  @override
  String get name => 'Suna';

  @override
  String get phoneNumber => 'Lambar waya';

  @override
  String get emailOptional => 'Imel (zaɓi)';

  @override
  String get requiresInstallFallback => 'Yana buƙatar shigarwa';

  @override
  String get notifications => 'Sanarwa';

  @override
  String get notificationSettings => 'Saitunan sanarwa';

  @override
  String get enableNotifications => 'Kunna sanarwa';

  @override
  String get errorFetchingToken => 'Kuskure wajen samin token';

  @override
  String fcmToken(String token) {
    return 'FCM Token: $token';
  }

  @override
  String get familyDashboard => 'Dashboard na iyali';

  @override
  String get pleaseLoginForFamilyFeatures =>
      'Don Allah shiga don amfani da fasalolin iyali';

  @override
  String get familyMembers => '\'Yan uwa';

  @override
  String get invite => 'Gayyata';

  @override
  String get pendingInvites => 'Gayyata a tsaye';

  @override
  String get connectedChildren => 'Ɗalibai haɗe';

  @override
  String get noFamilyMembersYet =>
      'Babu membobin iyali tukuna. Aika gayyata don farawa!';

  @override
  String errorLoadingFamilyLinks(String error) {
    return 'Kuskure wajen ɗora alaƙar iyali: $error';
  }

  @override
  String get inviteChild => 'Gayyaci yaro';

  @override
  String get managePermissions => 'Sarrafa izini';

  @override
  String get removeChild => 'Cire yaro';

  @override
  String get loading => 'Ana ɗora...';

  @override
  String get childEmail => 'Imel ɗan yaro';

  @override
  String get childEmailOrPhone => 'Imel ko waya ɗan yaro';

  @override
  String get enterChildEmail => 'Shigar da imel ɗan yaro';

  @override
  String get otpCode => 'Lambar OTP';

  @override
  String get enterOtp => 'Shigar da OTP';

  @override
  String get verify => 'Tabbatar';

  @override
  String get otpResentSuccessfully => 'An sake aika OTP cikin nasara!';

  @override
  String failedToResendOtp(String error) {
    return 'An kasa sake aika OTP: $error';
  }

  @override
  String get childLinkedSuccessfully => 'An haɗa yaro cikin nasara!';

  @override
  String get invitationSentSuccessfully => 'An aika gayyata cikin nasara!';

  @override
  String failedToSendInvitation(String error) {
    return 'An kasa aikawa gayyata: $error';
  }

  @override
  String get pleaseEnterValidEmail => 'Da fatan a shigar da ingantaccen imel';

  @override
  String get pleaseEnterValidEmailOrPhone =>
      'Da fatan a shigar da ingantaccen imel ko waya';

  @override
  String get invalidCode => 'Lambar ba ta da inganci, sake gwadawa';

  @override
  String get cancelInvite => 'Soke gayyata';

  @override
  String get cancelInviteConfirmation =>
      'Kuna da tabbacin kuna son soke wannan gayyata?';

  @override
  String get no => 'A\'a';

  @override
  String get yesCancel => 'Ee, a\'aika';

  @override
  String get inviteCancelledSuccessfully => 'An soke gayyata cikin nasara!';

  @override
  String failedToCancelInvite(String error) {
    return 'An kasa soke gayyata: $error';
  }

  @override
  String get revokeAccess => 'Cire izini';

  @override
  String get revokeAccessConfirmation =>
      'Kuna da tabbacin cire izinin wannan yaron? Wannan aikin ba za a iya maida shi ba.';

  @override
  String get revoke => 'Cire';

  @override
  String get accessRevokedSuccessfully => 'An cire izini cikin nasara!';

  @override
  String failedToRevokeAccess(String error) {
    return 'An kasa cire izini: $error';
  }

  @override
  String get grantConsent => 'Ba da yarda';

  @override
  String get revokeConsent => 'Cire yarda';

  @override
  String get consentGrantedSuccessfully => 'An ba da yarda cikin nasara!';

  @override
  String get consentRevokedSuccessfully => 'An cire yarda cikin nasara!';

  @override
  String failedToUpdateConsent(String error) {
    return 'An kasa sabunta yarda: $error';
  }

  @override
  String get checkingPermissions => 'Ana duba izini...';

  @override
  String get cancel => 'Sokewa';

  @override
  String get close => 'Rufe';

  @override
  String get save => 'Ajiye';

  @override
  String get sendNow => 'Aika yanzu';

  @override
  String get details => 'Cikakkun bayanai';

  @override
  String get noBroadcastMessages => 'Babu saƙonnin faɗaɗa tukuna';

  @override
  String errorCheckingPermissions(String error) {
    return 'Kuskure wajen duba izini: $error';
  }

  @override
  String get mediaOptional => 'Kafofi (zaɓi)';

  @override
  String get pickImage => 'Zaɓi hoto';

  @override
  String get pickVideo => 'Zaɓi bidiyo';

  @override
  String get pollOptions => 'Zaɓuɓɓuka:';

  @override
  String get targetingFilters => 'Matattarar manufa';

  @override
  String get scheduling => 'Jadawalin lokaci';

  @override
  String get scheduleForLater => 'Saita zuwa gaba';

  @override
  String errorEstimatingRecipients(String error) {
    return 'Kuskure wajen hasashen masu karɓa: $error';
  }

  @override
  String errorPickingImage(String error) {
    return 'Kuskure wajen zaɓar hoto: $error';
  }

  @override
  String errorPickingVideo(String error) {
    return 'Kuskure wajen zaɓar bidiyo: $error';
  }

  @override
  String get noPermissionForBroadcast =>
      'Ba ku da izini don ƙirƙirar saƙonnin faɗaɗa.';

  @override
  String get messageSavedSuccessfully => 'Saƙon an ajiye cikin nasara';

  @override
  String errorSavingMessage(String error) {
    return 'Kuskure wajen ajiye saƙo: $error';
  }

  @override
  String get messageSentSuccessfully => 'Saƙon an aika cikin nasara';

  @override
  String errorSendingMessage(String error) {
    return 'Kuskure wajen aika saƙo: $error';
  }

  @override
  String content(String content) {
    return 'Abun ciki: $content';
  }

  @override
  String type(String type) {
    return 'Nau\'i: $type';
  }

  @override
  String link(String link) {
    return 'Haɗi: $link';
  }

  @override
  String status(String status) {
    return 'Matsayi: $status';
  }

  @override
  String recipients(String count) {
    return 'Masu karɓa: $count';
  }

  @override
  String opened(String count) {
    return 'An buɗe: $count';
  }

  @override
  String clicked(String count) {
    return 'An danna: $count';
  }

  @override
  String created(String date) {
    return 'An ƙirƙira: $date';
  }

  @override
  String scheduled(String date) {
    return 'An tsara: $date';
  }

  @override
  String get organizations => 'Ƙungiyoyi';

  @override
  String get noOrganizations => 'Babu ƙungiyoyi';

  @override
  String get errorLoadingOrganizations => 'Kuskure wajen ɗora ƙungiyoyi';

  @override
  String members(String count) {
    return 'mambobi: $count';
  }

  @override
  String get users => 'Masu amfani';

  @override
  String get noUsers => 'Babu masu amfani';

  @override
  String get errorLoadingUsers => 'Kuskure wajen ɗora masu amfani';

  @override
  String get changeRole => 'Canza matsayi';

  @override
  String get totalAppointments => 'Jimlar haduwa';

  @override
  String get completedAppointments => 'An kammala haduwa';

  @override
  String get revenue => 'Kudaden shiga';

  @override
  String get errorLoadingStats => 'Kuskure wajen ɗora ƙididdiga';

  @override
  String appointment(String id) {
    return 'Haduwa: $id';
  }

  @override
  String from(String name) {
    return 'Daga: $name';
  }

  @override
  String phone(String number) {
    return 'Waya: $number';
  }

  @override
  String noRouteDefined(String route) {
    return 'Ba a ƙayyade hanya ba don $route';
  }

  @override
  String get meetingDetails => 'Cikakken bayani game da taro';

  @override
  String meetingId(String id) {
    return 'ID na taro: $id';
  }

  @override
  String creator(String id) {
    return 'Mai ƙirƙira: $id';
  }

  @override
  String context(String id) {
    return 'Mahallin: $id';
  }

  @override
  String group(String id) {
    return 'Rukuni: $id';
  }

  @override
  String get requestPrivateSession => 'Buƙaci zaman sirri';

  @override
  String get privacyRequestSent => 'An aika buƙatar sirri zuwa iyaye!';

  @override
  String failedToSendPrivacyRequest(String error) {
    return 'An kasa aika buƙatar sirri: $error';
  }

  @override
  String errorLoadingPrivacyRequests(String error) {
    return 'Kuskure wajen ɗora buƙatun sirri: $error';
  }

  @override
  String requestType(String type) {
    return 'Buƙatar $type';
  }

  @override
  String statusColon(String status) {
    return 'Matsayi: $status';
  }

  @override
  String failedToActionPrivacyRequest(String action, String error) {
    return 'An kasa $action buƙatar sirri: $error';
  }

  @override
  String get yes => 'Ee';

  @override
  String get send => 'Aika';

  @override
  String get permissions => 'Izini';

  @override
  String permissionsFor(String childId) {
    return 'Izini – $childId';
  }

  @override
  String errorLoadingPermissions(String error) {
    return 'Kuskure wajen ɗora izini: $error';
  }

  @override
  String get none => 'Babu';

  @override
  String get readOnly => 'Karatu kawai';

  @override
  String get readWrite => 'Karatu & rubutu';

  @override
  String permissionUpdated(String category, String newValue) {
    return 'An sabunta izini $category zuwa $newValue';
  }

  @override
  String failedToUpdatePermission(String error) {
    return 'An kasa sabunta izini: $error';
  }

  @override
  String invited(String date) {
    return 'An gayyace: $date';
  }

  @override
  String get adminBroadcast => 'Faɗaɗa mai kulawa';

  @override
  String get composeBroadcastMessage => 'Rubuta saƙon faɗaɗa';

  @override
  String get adminScreenTBD => 'Fuskar mai kulawa – A ci gaba';

  @override
  String get staffScreenTBD => 'Fuskar ma\'aikata – A ci gaba';

  @override
  String get clientScreenTBD => 'Fuskar abokin ciniki – A ci gaba';

  @override
  String get ambassadorTitle => 'Wakili';

  @override
  String get ambassadorOnboardingTitle => 'Zama Wakili';

  @override
  String get ambassadorOnboardingSubtitle =>
      'Taimaka mana mu bunkasa al\'ummar mu a cikin harshenka da yankinka.';

  @override
  String get ambassadorOnboardingButton => 'Fara Yanzu';

  @override
  String get ambassadorDashboardTitle => 'Dashboard na Wakili';

  @override
  String get ambassadorDashboardSubtitle =>
      'Kididdigar ka da bayanin ayyukan ka';

  @override
  String get ambassadorDashboardChartLabel =>
      'Masu Amfani da aka Gayyata a Wannan Makon';

  @override
  String get REDACTED_TOKEN => 'Ragowar Rukunin Wakili';

  @override
  String get REDACTED_TOKEN => 'Ƙasa da Harshe';

  @override
  String get ambassadorQuotaFull => 'Quota na wakili ya cika a yankinka.';

  @override
  String get ambassadorQuotaAvailable => 'Rukunin wakili suna samuwa!';

  @override
  String get ambassadorStatusAssigned => 'Kai wakili ne mai aiki.';

  @override
  String get ambassadorStatusNotEligible =>
      'Ba ka cancanci matsayin wakili ba.';

  @override
  String get ambassadorStatusWaiting => 'Ana jiran samun rukunin...';

  @override
  String get ambassadorStatusRevoked => 'Matsayin ka na wakili an soke shi.';

  @override
  String get ambassadorNoticeAdultOnly =>
      'Asusun manya kawai ne za su iya zama wakilai.';

  @override
  String get ambassadorNoticeQuotaReached =>
      'Quota na wakili na ƙasarka da harshenka ya kai ga iyaka.';

  @override
  String get ambassadorNoticeAutoAssign =>
      'Wakilci ana ba da shi ta atomatik ga masu amfani masu cancanta.';
}
