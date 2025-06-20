// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'Appoint';

  @override
  String get welcome => 'স্বাগতম';

  @override
  String get home => 'বাড়ি';

  @override
  String get menu => 'মেনু';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get signOut => 'সাইন আউট';

  @override
  String get login => 'লগইন';

  @override
  String get email => 'ইমেইল';

  @override
  String get password => 'পাসওয়ার্ড';

  @override
  String get signIn => 'সাইন ইন';

  @override
  String get bookMeeting => 'মিটিং বুক করুন';

  @override
  String get bookAppointment => 'অ্যাপয়েন্টমেন্ট বুক করুন';

  @override
  String get bookingRequest => 'বুকিং অনুরোধ';

  @override
  String get confirmBooking => 'বুকিং নিশ্চিত করুন';

  @override
  String get chatBooking => 'চ্যাট বুকিং';

  @override
  String get bookViaChat => 'চ্যাটের মাধ্যমে বুক করুন';

  @override
  String get submitBooking => 'বুকিং জমা দিন';

  @override
  String get next => 'পরবর্তী';

  @override
  String get selectStaff => 'স্টাফ নির্বাচন করুন';

  @override
  String get pickDate => 'তারিখ বেছে নিন';

  @override
  String get staff => 'স্টাফ';

  @override
  String get service => 'সেবা';

  @override
  String get dateTime => 'তারিখ ও সময়';

  @override
  String duration(String duration) {
    return 'স্থিতিকাল: $duration মিনিট';
  }

  @override
  String get notSelected => 'নির্বাচিত নয়';

  @override
  String get noSlots => 'কোনো স্লট উপলব্ধ নেই';

  @override
  String get bookingConfirmed => 'বুকিং নিশ্চিত হয়েছে';

  @override
  String get failedToConfirmBooking => 'বুকিং নিশ্চিত করতে ব্যর্থ হয়েছে';

  @override
  String get noBookingsFound => 'কোনো বুকিং পাওয়া যায়নি';

  @override
  String errorLoadingBookings(String error) {
    return 'বুকিং লোড করতে ত্রুটি: $error';
  }

  @override
  String get shareOnWhatsApp => 'হোয়াটসঅ্যাপে শেয়ার করুন';

  @override
  String get shareMeetingInvitation => 'আপনার মিটিং আমন্ত্রণ শেয়ার করুন:';

  @override
  String get meetingReadyMessage =>
      'মিটিং প্রস্তুত! আপনি কি এটি আপনার গ্রুপে পাঠাতে চান?';

  @override
  String get customizeMessage => 'আপনার বার্তা কাস্টমাইজ করুন...';

  @override
  String get saveGroupForRecognition => 'পরিচয়ের জন্য গ্রুপ সংরক্ষণ করুন';

  @override
  String get groupNameOptional => 'গ্রুপের নাম (ঐচ্ছিক)';

  @override
  String get enterGroupName => 'পরিচয়ের জন্য গ্রুপের নাম লিখুন';

  @override
  String get knownGroupDetected => 'পরিচিত গ্রুপ সনাক্ত হয়েছে';

  @override
  String get meetingSharedSuccessfully => 'মিটিং সফলভাবে শেয়ার করা হয়েছে!';

  @override
  String get bookingConfirmedShare =>
      'বুকিং নিশ্চিত হয়েছে! এখন আপনি আমন্ত্রণ শেয়ার করতে পারেন।';

  @override
  String get defaultShareMessage =>
      'হাই! আমি APP-OINT এর মাধ্যমে আপনার সাথে একটি মিটিং নির্ধারণ করেছি। নিশ্চিত করতে বা অন্য সময় প্রস্তাব করতে এখানে ক্লিক করুন:';

  @override
  String get dashboard => 'ড্যাশবোর্ড';

  @override
  String get businessDashboard => 'ব্যবসা ড্যাশবোর্ড';

  @override
  String get myProfile => 'আমার প্রোফাইল';

  @override
  String get noProfileFound => 'কোনো প্রোফাইল পাওয়া যায়নি';

  @override
  String get errorLoadingProfile => 'প্রোফাইল লোড করতে ত্রুটি';

  @override
  String get myInvites => 'আমার আমন্ত্রণ';

  @override
  String get inviteDetail => 'আমন্ত্রণের বিস্তারিত';

  @override
  String get inviteContact => 'যোগাযোগ আমন্ত্রণ';

  @override
  String get noInvites => 'কোনো আমন্ত্রণ নেই';

  @override
  String get errorLoadingInvites => 'আমন্ত্রণ লোড করতে ত্রুটি';

  @override
  String get accept => 'গ্রহণ করুন';

  @override
  String get decline => 'প্রত্যাখ্যান করুন';

  @override
  String get sendInvite => 'আমন্ত্রণ পাঠান';

  @override
  String get name => 'নাম';

  @override
  String get phoneNumber => 'ফোন নম্বর';

  @override
  String get emailOptional => 'ইমেইল (ঐচ্ছিক)';

  @override
  String get requiresInstallFallback => 'ইনস্টলেশন প্রয়োজন';

  @override
  String get notifications => 'বিজ্ঞপ্তি';

  @override
  String get notificationSettings => 'বিজ্ঞপ্তির সেটিংস';

  @override
  String get enableNotifications => 'বিজ্ঞপ্তি চালু করুন';

  @override
  String get errorFetchingToken => 'টোকেন আনতে ত্রুটি';

  @override
  String fcmToken(String token) {
    return 'FCM টোকেন: $token';
  }

  @override
  String get familyDashboard => 'পরিবার ড্যাশবোর্ড';

  @override
  String get pleaseLoginForFamilyFeatures =>
      'পরিবার ফিচার অ্যাক্সেস করতে দয়া করে লগইন করুন';

  @override
  String get familyMembers => 'পরিবারের সদস্য';

  @override
  String get invite => 'আমন্ত্রণ';

  @override
  String get pendingInvites => 'অপেক্ষমাণ আমন্ত্রণ';

  @override
  String get connectedChildren => 'সংযুক্ত শিশু';

  @override
  String get noFamilyMembersYet =>
      'এখনও কোনো পরিবার সদস্য নেই। শুরু করতে কাউকে আমন্ত্রণ জানান!';

  @override
  String errorLoadingFamilyLinks(String error) {
    return 'পরিবার লিঙ্ক লোড করতে ত্রুটি: $error';
  }

  @override
  String get inviteChild => 'শিশুকে আমন্ত্রণ জানান';

  @override
  String get managePermissions => 'অনুমতি পরিচালনা করুন';

  @override
  String get removeChild => 'শিশু সরান';

  @override
  String get loading => 'লোড হচ্ছে...';

  @override
  String get childEmail => 'শিশুর ইমেইল';

  @override
  String get childEmailOrPhone => 'শিশুর ইমেইল অথবা ফোন';

  @override
  String get enterChildEmail => 'শিশুর ইমেইল লিখুন';

  @override
  String get otpCode => 'OTP কোড';

  @override
  String get enterOtp => 'OTP লিখুন';

  @override
  String get verify => 'যাচাই করুন';

  @override
  String get otpResentSuccessfully => 'OTP সফলভাবে পুনরায় পাঠানো হয়েছে!';

  @override
  String failedToResendOtp(String error) {
    return 'OTP পুনরায় পাঠাতে ব্যর্থ: $error';
  }

  @override
  String get childLinkedSuccessfully => 'শিশু সফলভাবে সংযুক্ত হয়েছে!';

  @override
  String get invitationSentSuccessfully => 'আমন্ত্রণ সফলভাবে পাঠানো হয়েছে!';

  @override
  String failedToSendInvitation(String error) {
    return 'আমন্ত্রণ পাঠাতে ব্যর্থ: $error';
  }

  @override
  String get pleaseEnterValidEmail => 'একটি বৈধ ইমেইল লিখুন';

  @override
  String get pleaseEnterValidEmailOrPhone => 'একটি বৈধ ইমেইল বা ফোন লিখুন';

  @override
  String get invalidCode => 'ভুল কোড, দয়া করে আবার চেষ্টা করুন';

  @override
  String get cancelInvite => 'আমন্ত্রণ বাতিল করুন';

  @override
  String get cancelInviteConfirmation =>
      'আপনি কি নিশ্চিত যে আপনি এই আমন্ত্রণ বাতিল করতে চান?';

  @override
  String get no => 'না';

  @override
  String get yesCancel => 'হ্যাঁ, বাতিল করুন';

  @override
  String get inviteCancelledSuccessfully => 'আমন্ত্রণ সফলভাবে বাতিল হয়েছে!';

  @override
  String failedToCancelInvite(String error) {
    return 'আমন্ত্রণ বাতিল করতে ব্যর্থ: $error';
  }

  @override
  String get revokeAccess => 'অ্যাক্সেস বাতিল করুন';

  @override
  String get revokeAccessConfirmation =>
      'আপনি কি নিশ্চিত যে আপনি এই শিশুর অ্যাক্সেস বাতিল করতে চান? এটি পূর্বাবস্থায় ফেরানো যাবে না।';

  @override
  String get revoke => 'বাতিল করুন';

  @override
  String get accessRevokedSuccessfully => 'অ্যাক্সেস সফলভাবে বাতিল হয়েছে!';

  @override
  String failedToRevokeAccess(String error) {
    return 'অ্যাক্সেস বাতিল করতে ব্যর্থ: $error';
  }

  @override
  String get grantConsent => 'অনুমতি দিন';

  @override
  String get revokeConsent => 'অনুমতি প্রত্যাহার করুন';

  @override
  String get consentGrantedSuccessfully => 'অনুমতি সফলভাবে প্রদান করা হয়েছে!';

  @override
  String get consentRevokedSuccessfully =>
      'অনুমতি সফলভাবে প্রত্যাহার করা হয়েছে!';

  @override
  String failedToUpdateConsent(String error) {
    return 'অনুমতি আপডেট করতে ব্যর্থ: $error';
  }

  @override
  String get checkingPermissions => 'অনুমতি যাচাই করা হচ্ছে...';

  @override
  String get cancel => 'বাতিল করুন';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get save => 'সংরক্ষণ করুন';

  @override
  String get sendNow => 'এখনই পাঠান';

  @override
  String get details => 'বিস্তারিত';

  @override
  String get noBroadcastMessages => 'এখনও কোনো সম্প্রচার বার্তা নেই';

  @override
  String errorCheckingPermissions(String error) {
    return 'অনুমতি যাচাই করতে ত্রুটি: $error';
  }

  @override
  String get mediaOptional => 'মিডিয়া (ঐচ্ছিক)';

  @override
  String get pickImage => 'ছবি নির্বাচন করুন';

  @override
  String get pickVideo => 'ভিডিও নির্বাচন করুন';

  @override
  String get pollOptions => 'ভোটের বিকল্পসমূহ:';

  @override
  String get targetingFilters => 'টার্গেটিং ফিল্টার';

  @override
  String get scheduling => 'সময় নির্ধারণ';

  @override
  String get scheduleForLater => 'পরে নির্ধারণ করুন';

  @override
  String errorEstimatingRecipients(String error) {
    return 'গ্রাহক সংখ্যা অনুমান করতে ত্রুটি: $error';
  }

  @override
  String errorPickingImage(String error) {
    return 'ছবি বাছাই করতে ত্রুটি: $error';
  }

  @override
  String errorPickingVideo(String error) {
    return 'ভিডিও বাছাই করতে ত্রুটি: $error';
  }

  @override
  String get noPermissionForBroadcast =>
      'আপনার সম্প্রচার বার্তা তৈরি করার অনুমতি নেই।';

  @override
  String get messageSavedSuccessfully => 'বার্তা সফলভাবে সংরক্ষিত হয়েছে';

  @override
  String errorSavingMessage(String error) {
    return 'বার্তা সংরক্ষণ করতে ত্রুটি: $error';
  }

  @override
  String get messageSentSuccessfully => 'বার্তা সফলভাবে পাঠানো হয়েছে';

  @override
  String errorSendingMessage(String error) {
    return 'বার্তা পাঠাতে ত্রুটি: $error';
  }

  @override
  String content(String content) {
    return 'বিষয়বস্তু: $content';
  }

  @override
  String type(String type) {
    return 'ধরণ: $type';
  }

  @override
  String link(String link) {
    return 'লিংক: $link';
  }

  @override
  String status(String status) {
    return 'স্ট্যাটাস: $status';
  }

  @override
  String recipients(String count) {
    return 'গ্রাহক: $count';
  }

  @override
  String opened(String count) {
    return 'খোলা হয়েছে: $count';
  }

  @override
  String clicked(String count) {
    return 'ক্লিক হয়েছে: $count';
  }

  @override
  String created(String date) {
    return 'তৈরি হয়েছে: $date';
  }

  @override
  String scheduled(String date) {
    return 'নির্ধারিত হয়েছে: $date';
  }

  @override
  String get organizations => 'সংগঠনসমূহ';

  @override
  String get noOrganizations => 'কোনো সংগঠন নেই';

  @override
  String get errorLoadingOrganizations => 'সংগঠন লোড করতে ত্রুটি';

  @override
  String members(String count) {
    return '$count জন সদস্য';
  }

  @override
  String get users => 'ব্যবহারকারী';

  @override
  String get noUsers => 'কোনো ব্যবহারকারী নেই';

  @override
  String get errorLoadingUsers => 'ব্যবহারকারী লোড করতে ত্রুটি';

  @override
  String get changeRole => 'ভূমিকা পরিবর্তন করুন';

  @override
  String get totalAppointments => 'মোট অ্যাপয়েন্টমেন্ট';

  @override
  String get completedAppointments => 'সম্পন্ন অ্যাপয়েন্টমেন্ট';

  @override
  String get revenue => 'আয়';

  @override
  String get errorLoadingStats => 'পরিসংখ্যান লোড করতে ত্রুটি';

  @override
  String appointment(String id) {
    return 'অ্যাপয়েন্টমেন্ট: $id';
  }

  @override
  String from(String name) {
    return 'থেকে: $name';
  }

  @override
  String phone(String number) {
    return 'ফোন: $number';
  }

  @override
  String noRouteDefined(String route) {
    return '$route এর জন্য কোনো রুট নির্ধারিত নেই';
  }

  @override
  String get meetingDetails => 'মিটিং এর বিবরণ';

  @override
  String meetingId(String id) {
    return 'মিটিং আইডি: $id';
  }

  @override
  String creator(String id) {
    return 'স্রষ্টা: $id';
  }

  @override
  String context(String id) {
    return 'প্রসঙ্গ: $id';
  }

  @override
  String group(String id) {
    return 'গ্রুপ: $id';
  }

  @override
  String get requestPrivateSession => 'ব্যক্তিগত সেশনের অনুরোধ';

  @override
  String get privacyRequestSent =>
      'আপনার অভিভাবকদের কাছে গোপনীয়তা অনুরোধ পাঠানো হয়েছে!';

  @override
  String failedToSendPrivacyRequest(String error) {
    return 'গোপনীয়তা অনুরোধ পাঠাতে ব্যর্থ: $error';
  }

  @override
  String errorLoadingPrivacyRequests(String error) {
    return 'গোপনীয়তা অনুরোধ লোড করতে ত্রুটি: $error';
  }

  @override
  String requestType(String type) {
    return '$type অনুরোধ';
  }

  @override
  String statusColon(String status) {
    return 'স্ট্যাটাস: $status';
  }

  @override
  String failedToActionPrivacyRequest(String action, String error) {
    return 'গোপনীয়তা অনুরোধ $action করতে ব্যর্থ: $error';
  }

  @override
  String get yes => 'হ্যাঁ';

  @override
  String get send => 'পাঠান';

  @override
  String get permissions => 'অনুমতি';

  @override
  String permissionsFor(String childId) {
    return 'অনুমতি - $childId';
  }

  @override
  String errorLoadingPermissions(String error) {
    return 'অনুমতি লোড করতে ত্রুটি: $error';
  }

  @override
  String get none => 'কোনোটি নয়';

  @override
  String get readOnly => 'শুধুমাত্র পড়ার জন্য';

  @override
  String get readWrite => 'পড়া ও লেখা';

  @override
  String permissionUpdated(String category, String newValue) {
    return 'অনুমতি $category আপডেট করা হয়েছে $newValue এ';
  }

  @override
  String failedToUpdatePermission(String error) {
    return 'অনুমতি আপডেট করতে ব্যর্থ: $error';
  }

  @override
  String invited(String date) {
    return 'আমন্ত্রণ জানানো হয়েছে: $date';
  }

  @override
  String get adminBroadcast => 'অ্যাডমিন সম্প্রচার';

  @override
  String get composeBroadcastMessage => 'সম্প্রচার বার্তা লিখুন';

  @override
  String get adminScreenTBD => 'অ্যাডমিন স্ক্রীন - পরে তৈরি করা হবে';

  @override
  String get staffScreenTBD => 'স্টাফ স্ক্রীন - পরে তৈরি করা হবে';

  @override
  String get clientScreenTBD => 'ক্লায়েন্ট স্ক্রীন - পরে তৈরি করা হবে';

  @override
  String get ambassadorTitle => 'রাষ্ট্রদূত';

  @override
  String get ambassadorOnboardingTitle => 'রাষ্ট্রদূত হন';

  @override
  String get ambassadorOnboardingSubtitle =>
      'আপনার ভাষা এবং অঞ্চলে আমাদের সম্প্রদায়কে বাড়াতে সাহায্য করুন।';

  @override
  String get ambassadorOnboardingButton => 'এখনই শুরু করুন';

  @override
  String get ambassadorDashboardTitle => 'রাষ্ট্রদূত ড্যাশবোর্ড';

  @override
  String get ambassadorDashboardSubtitle =>
      'আপনার পরিসংখ্যান এবং কার্যকলাপের সংক্ষিপ্ত বিবরণ';

  @override
  String get ambassadorDashboardChartLabel =>
      'এই সপ্তাহে আমন্ত্রিত ব্যবহারকারীরা';

  @override
  String get ambassadorDashboardRemainingSlots => 'অবশিষ্ট রাষ্ট্রদূত পদ';

  @override
  String get ambassadorDashboardCountryLanguage => 'দেশ এবং ভাষা';

  @override
  String get ambassadorQuotaFull => 'আপনার অঞ্চলে রাষ্ট্রদূত কোটা পূর্ণ।';

  @override
  String get ambassadorQuotaAvailable => 'রাষ্ট্রদূত পদ উপলব্ধ!';

  @override
  String get ambassadorStatusAssigned => 'আপনি একজন সক্রিয় রাষ্ট্রদূত।';

  @override
  String get ambassadorStatusNotEligible =>
      'আপনি রাষ্ট্রদূত পদমর্যাদার জন্য যোগ্য নন।';

  @override
  String get ambassadorStatusWaiting => 'পদের উপলব্ধতার জন্য অপেক্ষা করছে...';

  @override
  String get ambassadorStatusRevoked =>
      'আপনার রাষ্ট্রদূত পদমর্যাদা বাতিল করা হয়েছে।';

  @override
  String get ambassadorNoticeAdultOnly =>
      'শুধুমাত্র প্রাপ্তবয়স্ক অ্যাকাউন্টগুলি রাষ্ট্রদূত হতে পারে।';

  @override
  String get ambassadorNoticeQuotaReached =>
      'আপনার দেশ এবং ভাষার জন্য রাষ্ট্রদূত কোটা পূর্ণ হয়েছে।';

  @override
  String get ambassadorNoticeAutoAssign =>
      'রাষ্ট্রদূতত্ব স্বয়ংক্রিয়ভাবে যোগ্য ব্যবহারকারীদের দেওয়া হয়।';
}
