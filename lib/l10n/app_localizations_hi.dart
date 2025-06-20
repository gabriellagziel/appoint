// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Appoint';

  @override
  String get welcome => 'स्वागत है';

  @override
  String get home => 'होम';

  @override
  String get menu => 'मेनू';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get login => 'लॉगिन';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get signIn => 'साइन इन';

  @override
  String get bookMeeting => 'मीटिंग बुक करें';

  @override
  String get bookAppointment => 'अपॉइंटमेंट बुक करें';

  @override
  String get bookingRequest => 'बुकिंग अनुरोध';

  @override
  String get confirmBooking => 'बुकिंग की पुष्टि करें';

  @override
  String get chatBooking => 'चैट बुकिंग';

  @override
  String get bookViaChat => 'चैट के माध्यम से बुक करें';

  @override
  String get submitBooking => 'बुकिंग सबमिट करें';

  @override
  String get next => 'अगला';

  @override
  String get selectStaff => 'स्टाफ चुनें';

  @override
  String get pickDate => 'तारीख चुनें';

  @override
  String get staff => 'स्टाफ';

  @override
  String get service => 'सेवा';

  @override
  String get dateTime => 'दिनांक और समय';

  @override
  String duration(String duration) {
    return 'अवधि: $duration मिनट';
  }

  @override
  String get notSelected => 'चयन नहीं किया गया';

  @override
  String get noSlots => 'कोई स्लॉट उपलब्ध नहीं';

  @override
  String get bookingConfirmed => 'बुकिंग की पुष्टि हो गई';

  @override
  String get failedToConfirmBooking => 'बुकिंग की पुष्टि विफल रही';

  @override
  String get noBookingsFound => 'कोई बुकिंग नहीं मिली';

  @override
  String errorLoadingBookings(String error) {
    return 'बुकिंग लोड करने में त्रुटि: $error';
  }

  @override
  String get shareOnWhatsApp => 'व्हाट्सएप पर साझा करें';

  @override
  String get shareMeetingInvitation => 'अपनी मीटिंग निमंत्रण साझा करें:';

  @override
  String get meetingReadyMessage =>
      'मीटिंग तैयार है! क्या आप इसे अपने समूह को भेजना चाहते हैं?';

  @override
  String get customizeMessage => 'अपना संदेश अनुकूलित करें...';

  @override
  String get saveGroupForRecognition => 'भविष्य की पहचान के लिए समूह सहेजें';

  @override
  String get groupNameOptional => 'समूह का नाम (वैकल्पिक)';

  @override
  String get enterGroupName => 'पहचान के लिए समूह का नाम दर्ज करें';

  @override
  String get knownGroupDetected => 'ज्ञात समूह पाया गया';

  @override
  String get meetingSharedSuccessfully => 'मीटिंग सफलतापूर्वक साझा की गई!';

  @override
  String get bookingConfirmedShare =>
      'बुकिंग की पुष्टि हो गई! अब आप निमंत्रण साझा कर सकते हैं।';

  @override
  String get defaultShareMessage =>
      'हाय! मैंने APP-OINT के माध्यम से आपके साथ एक मीटिंग शेड्यूल की है। पुष्टि करने या अन्य समय सुझाने के लिए यहां क्लिक करें:';

  @override
  String get dashboard => 'डैशबोर्ड';

  @override
  String get businessDashboard => 'व्यापार डैशबोर्ड';

  @override
  String get myProfile => 'मेरी प्रोफ़ाइल';

  @override
  String get noProfileFound => 'कोई प्रोफ़ाइल नहीं मिली';

  @override
  String get errorLoadingProfile => 'प्रोफ़ाइल लोड करने में त्रुटि';

  @override
  String get myInvites => 'मेरे निमंत्रण';

  @override
  String get inviteDetail => 'निमंत्रण विवरण';

  @override
  String get inviteContact => 'संपर्क को आमंत्रित करें';

  @override
  String get noInvites => 'कोई निमंत्रण नहीं';

  @override
  String get errorLoadingInvites => 'निमंत्रण लोड करने में त्रुटि';

  @override
  String get accept => 'स्वीकार करें';

  @override
  String get decline => 'अस्वीकार करें';

  @override
  String get sendInvite => 'निमंत्रण भेजें';

  @override
  String get name => 'नाम';

  @override
  String get phoneNumber => 'फ़ोन नंबर';

  @override
  String get emailOptional => 'ईमेल (वैकल्पिक)';

  @override
  String get requiresInstallFallback => 'स्थापना की आवश्यकता है';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get notificationSettings => 'अधिसूचना सेटिंग्स';

  @override
  String get enableNotifications => 'सूचनाएं सक्षम करें';

  @override
  String get errorFetchingToken => 'टोकन प्राप्त करने में त्रुटि';

  @override
  String fcmToken(String token) {
    return 'FCM टोकन: $token';
  }

  @override
  String get familyDashboard => 'पारिवारिक डैशबोर्ड';

  @override
  String get pleaseLoginForFamilyFeatures =>
      'पारिवारिक सुविधाओं के लिए कृपया लॉगिन करें';

  @override
  String get familyMembers => 'परिवार के सदस्य';

  @override
  String get invite => 'आमंत्रित करें';

  @override
  String get pendingInvites => 'लंबित निमंत्रण';

  @override
  String get connectedChildren => 'जुड़े हुए बच्चे';

  @override
  String get noFamilyMembersYet =>
      'अभी तक कोई परिवार सदस्य नहीं है। शुरू करने के लिए किसी को आमंत्रित करें!';

  @override
  String errorLoadingFamilyLinks(String error) {
    return 'पारिवारिक लिंक लोड करने में त्रुटि: $error';
  }

  @override
  String get inviteChild => 'बच्चे को आमंत्रित करें';

  @override
  String get managePermissions => 'अनुमतियाँ प्रबंधित करें';

  @override
  String get removeChild => 'बच्चे को हटाएं';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get childEmail => 'बच्चे का ईमेल';

  @override
  String get childEmailOrPhone => 'बच्चे का ईमेल या फ़ोन';

  @override
  String get enterChildEmail => 'बच्चे का ईमेल दर्ज करें';

  @override
  String get otpCode => 'ओटीपी कोड';

  @override
  String get enterOtp => 'ओटीपी दर्ज करें';

  @override
  String get verify => 'सत्यापित करें';

  @override
  String get otpResentSuccessfully => 'ओटीपी सफलतापूर्वक पुनः भेजा गया!';

  @override
  String failedToResendOtp(String error) {
    return 'ओटीपी पुनः भेजने में विफल: $error';
  }

  @override
  String get childLinkedSuccessfully => 'बच्चा सफलतापूर्वक लिंक हो गया!';

  @override
  String get invitationSentSuccessfully => 'निमंत्रण सफलतापूर्वक भेजा गया!';

  @override
  String failedToSendInvitation(String error) {
    return 'निमंत्रण भेजने में विफल: $error';
  }

  @override
  String get pleaseEnterValidEmail => 'कृपया मान्य ईमेल दर्ज करें';

  @override
  String get pleaseEnterValidEmailOrPhone =>
      'कृपया मान्य ईमेल या फ़ोन दर्ज करें';

  @override
  String get invalidCode => 'अमान्य कोड, कृपया पुनः प्रयास करें';

  @override
  String get cancelInvite => 'निमंत्रण रद्द करें';

  @override
  String get cancelInviteConfirmation =>
      'क्या आप वाकई इस निमंत्रण को रद्द करना चाहते हैं?';

  @override
  String get no => 'नहीं';

  @override
  String get yesCancel => 'हाँ, रद्द करें';

  @override
  String get inviteCancelledSuccessfully =>
      'निमंत्रण सफलतापूर्वक रद्द किया गया!';

  @override
  String failedToCancelInvite(String error) {
    return 'निमंत्रण रद्द करने में विफल: $error';
  }

  @override
  String get revokeAccess => 'पहुंच रद्द करें';

  @override
  String get revokeAccessConfirmation =>
      'क्या आप वाकई इस बच्चे की पहुंच रद्द करना चाहते हैं? यह क्रिया पूर्ववत नहीं की जा सकती।';

  @override
  String get revoke => 'रद्द करें';

  @override
  String get accessRevokedSuccessfully => 'पहुंच सफलतापूर्वक रद्द की गई!';

  @override
  String failedToRevokeAccess(String error) {
    return 'पहुंच रद्द करने में विफल: $error';
  }

  @override
  String get grantConsent => 'सहमति दें';

  @override
  String get revokeConsent => 'सहमति रद्द करें';

  @override
  String get consentGrantedSuccessfully => 'सहमति सफलतापूर्वक दी गई!';

  @override
  String get consentRevokedSuccessfully => 'सहमति सफलतापूर्वक रद्द की गई!';

  @override
  String failedToUpdateConsent(String error) {
    return 'सहमति अपडेट करने में विफल: $error';
  }

  @override
  String get checkingPermissions => 'अनुमतियाँ जांची जा रही हैं...';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get close => 'बंद करें';

  @override
  String get save => 'सहेजें';

  @override
  String get sendNow => 'अभी भेजें';

  @override
  String get details => 'विवरण';

  @override
  String get noBroadcastMessages => 'अभी तक कोई प्रसारण संदेश नहीं हैं';

  @override
  String errorCheckingPermissions(String error) {
    return 'अनुमतियाँ जांचने में त्रुटि: $error';
  }

  @override
  String get mediaOptional => 'मीडिया (वैकल्पिक)';

  @override
  String get pickImage => 'छवि चुनें';

  @override
  String get pickVideo => 'वीडियो चुनें';

  @override
  String get pollOptions => 'मतदान विकल्प:';

  @override
  String get targetingFilters => 'लक्षित फ़िल्टर';

  @override
  String get scheduling => 'अनुसूची';

  @override
  String get scheduleForLater => 'बाद के लिए शेड्यूल करें';

  @override
  String errorEstimatingRecipients(String error) {
    return 'प्राप्तकर्ताओं का अनुमान लगाने में त्रुटि: $error';
  }

  @override
  String errorPickingImage(String error) {
    return 'छवि चुनने में त्रुटि: $error';
  }

  @override
  String errorPickingVideo(String error) {
    return 'वीडियो चुनने में त्रुटि: $error';
  }

  @override
  String get noPermissionForBroadcast =>
      'आपके पास प्रसारण संदेश बनाने की अनुमति नहीं है।';

  @override
  String get messageSavedSuccessfully => 'संदेश सफलतापूर्वक सहेजा गया';

  @override
  String errorSavingMessage(String error) {
    return 'संदेश सहेजने में त्रुटि: $error';
  }

  @override
  String get messageSentSuccessfully => 'संदेश सफलतापूर्वक भेजा गया';

  @override
  String errorSendingMessage(String error) {
    return 'संदेश भेजने में त्रुटि: $error';
  }

  @override
  String content(String content) {
    return 'सामग्री: $content';
  }

  @override
  String type(String type) {
    return 'प्रकार: $type';
  }

  @override
  String link(String link) {
    return 'लिंक: $link';
  }

  @override
  String status(String status) {
    return 'स्थिति: $status';
  }

  @override
  String recipients(String count) {
    return 'प्राप्तकर्ता: $count';
  }

  @override
  String opened(String count) {
    return 'खोला गया: $count';
  }

  @override
  String clicked(String count) {
    return 'क्लिक किया गया: $count';
  }

  @override
  String created(String date) {
    return 'बनाया गया: $date';
  }

  @override
  String scheduled(String date) {
    return 'अनुसूचित: $date';
  }

  @override
  String get organizations => 'संगठन';

  @override
  String get noOrganizations => 'कोई संगठन नहीं';

  @override
  String get errorLoadingOrganizations => 'संगठन लोड करने में त्रुटि';

  @override
  String members(String count) {
    return '$count सदस्य';
  }

  @override
  String get users => 'उपयोगकर्ता';

  @override
  String get noUsers => 'कोई उपयोगकर्ता नहीं';

  @override
  String get errorLoadingUsers => 'उपयोगकर्ता लोड करने में त्रुटि';

  @override
  String get changeRole => 'भूमिका बदलें';

  @override
  String get totalAppointments => 'कुल अपॉइंटमेंट';

  @override
  String get completedAppointments => 'पूर्ण अपॉइंटमेंट';

  @override
  String get revenue => 'राजस्व';

  @override
  String get errorLoadingStats => 'आंकड़े लोड करने में त्रुटि';

  @override
  String appointment(String id) {
    return 'अपॉइंटमेंट: $id';
  }

  @override
  String from(String name) {
    return 'से: $name';
  }

  @override
  String phone(String number) {
    return 'फोन: $number';
  }

  @override
  String noRouteDefined(String route) {
    return '$route के लिए कोई रूट परिभाषित नहीं है';
  }

  @override
  String get meetingDetails => 'मीटिंग विवरण';

  @override
  String meetingId(String id) {
    return 'मीटिंग आईडी: $id';
  }

  @override
  String creator(String id) {
    return 'निर्माता: $id';
  }

  @override
  String context(String id) {
    return 'संदर्भ: $id';
  }

  @override
  String group(String id) {
    return 'समूह: $id';
  }

  @override
  String get requestPrivateSession => 'निजी सत्र का अनुरोध करें';

  @override
  String get privacyRequestSent =>
      'आपकी गोपनीयता का अनुरोध आपके माता-पिता को भेजा गया है!';

  @override
  String failedToSendPrivacyRequest(String error) {
    return 'गोपनीयता अनुरोध भेजने में विफल: $error';
  }

  @override
  String errorLoadingPrivacyRequests(String error) {
    return 'गोपनीयता अनुरोध लोड करने में त्रुटि: $error';
  }

  @override
  String requestType(String type) {
    return '$type अनुरोध';
  }

  @override
  String statusColon(String status) {
    return 'स्थिति: $status';
  }

  @override
  String failedToActionPrivacyRequest(String action, String error) {
    return 'गोपनीयता अनुरोध $action करने में विफल: $error';
  }

  @override
  String get yes => 'हाँ';

  @override
  String get send => 'भेजें';

  @override
  String get permissions => 'अनुमतियाँ';

  @override
  String permissionsFor(String childId) {
    return 'अनुमतियाँ - $childId';
  }

  @override
  String errorLoadingPermissions(String error) {
    return 'अनुमतियाँ लोड करने में त्रुटि: $error';
  }

  @override
  String get none => 'कोई नहीं';

  @override
  String get readOnly => 'केवल पढ़ने के लिए';

  @override
  String get readWrite => 'पढ़ें और लिखें';

  @override
  String permissionUpdated(String category, String newValue) {
    return 'अनुमति $category को $newValue में अपडेट किया गया';
  }

  @override
  String failedToUpdatePermission(String error) {
    return 'अनुमति अपडेट करने में विफल: $error';
  }

  @override
  String invited(String date) {
    return 'आमंत्रित किया गया: $date';
  }

  @override
  String get adminBroadcast => 'व्यवस्थापक प्रसारण';

  @override
  String get composeBroadcastMessage => 'प्रसारण संदेश लिखें';

  @override
  String get adminScreenTBD => 'व्यवस्थापक स्क्रीन - विकासाधीन';

  @override
  String get staffScreenTBD => 'स्टाफ स्क्रीन - विकासाधीन';

  @override
  String get clientScreenTBD => 'क्लाइंट स्क्रीन - विकासाधीन';

  @override
  String get ambassadorTitle => 'राजदूत';

  @override
  String get ambassadorOnboardingTitle => 'राजदूत बनें';

  @override
  String get ambassadorOnboardingSubtitle =>
      'अपनी भाषा और क्षेत्र में हमारे समुदाय को बढ़ाने में मदद करें।';

  @override
  String get ambassadorOnboardingButton => 'अभी शुरू करें';

  @override
  String get ambassadorDashboardTitle => 'राजदूत डैशबोर्ड';

  @override
  String get ambassadorDashboardSubtitle =>
      'आपके आंकड़ों और गतिविधियों का अवलोकन';

  @override
  String get ambassadorDashboardChartLabel =>
      'इस सप्ताह आमंत्रित किए गए उपयोगकर्ता';

  @override
  String get REDACTED_TOKEN => 'शेष राजदूत स्थान';

  @override
  String get REDACTED_TOKEN => 'देश और भाषा';

  @override
  String get ambassadorQuotaFull => 'आपके क्षेत्र में राजदूत कोटा भरा हुआ है।';

  @override
  String get ambassadorQuotaAvailable => 'राजदूत स्थान उपलब्ध हैं!';

  @override
  String get ambassadorStatusAssigned => 'आप एक सक्रिय राजदूत हैं।';

  @override
  String get ambassadorStatusNotEligible =>
      'आप राजदूत स्थिति के लिए पात्र नहीं हैं।';

  @override
  String get ambassadorStatusWaiting => 'स्थान उपलब्धता की प्रतीक्षा में...';

  @override
  String get ambassadorStatusRevoked => 'आपकी राजदूत स्थिति रद्द कर दी गई है।';

  @override
  String get ambassadorNoticeAdultOnly =>
      'केवल वयस्क खाते ही राजदूत बन सकते हैं।';

  @override
  String get ambassadorNoticeQuotaReached =>
      'आपके देश और भाषा के लिए राजदूत कोटा पूरा हो गया है।';

  @override
  String get ambassadorNoticeAutoAssign =>
      'राजदूतत्व स्वचालित रूप से योग्य उपयोगकर्ताओं को प्रदान किया जाता है।';
}
