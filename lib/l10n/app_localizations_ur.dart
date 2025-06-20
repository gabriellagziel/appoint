// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'Appoint';

  @override
  String get welcome => 'خوش آمدید';

  @override
  String get home => 'ہوم';

  @override
  String get menu => 'مینو';

  @override
  String get profile => 'پروفائل';

  @override
  String get signOut => 'سائن آؤٹ';

  @override
  String get login => 'لاگ ان';

  @override
  String get email => 'ای میل';

  @override
  String get password => 'پاس ورڈ';

  @override
  String get signIn => 'سائن ان کریں';

  @override
  String get bookMeeting => 'ملاقات بُک کریں';

  @override
  String get bookAppointment => 'وقت بُک کریں';

  @override
  String get bookingRequest => 'بُکنگ کی درخواست';

  @override
  String get confirmBooking => 'بُکنگ کی تصدیق کریں';

  @override
  String get chatBooking => 'چیٹ بُکنگ';

  @override
  String get bookViaChat => 'چیٹ کے ذریعے بُک کریں';

  @override
  String get submitBooking => 'بُکنگ جمع کروائیں';

  @override
  String get next => 'اگلا';

  @override
  String get selectStaff => 'اسٹاف منتخب کریں';

  @override
  String get pickDate => 'تاریخ منتخب کریں';

  @override
  String get staff => 'اسٹاف';

  @override
  String get service => 'سروس';

  @override
  String get dateTime => 'تاریخ اور وقت';

  @override
  String duration(String duration) {
    return 'دورانیہ: $duration منٹ';
  }

  @override
  String get notSelected => 'منتخب نہیں ہوا';

  @override
  String get noSlots => 'کوئی دستیاب وقت نہیں';

  @override
  String get bookingConfirmed => 'بُکنگ کی تصدیق ہو گئی ہے';

  @override
  String get failedToConfirmBooking => 'بُکنگ کی تصدیق ناکام رہی';

  @override
  String get noBookingsFound => 'کوئی بُکنگ نہیں ملی';

  @override
  String errorLoadingBookings(String error) {
    return 'بُکنگ لوڈ کرنے میں خرابی: $error';
  }

  @override
  String get shareOnWhatsApp => 'واٹس ایپ پر شیئر کریں';

  @override
  String get shareMeetingInvitation => 'اپنی ملاقات کی دعوت شیئر کریں:';

  @override
  String get meetingReadyMessage =>
      'ملاقات تیار ہے! کیا آپ اسے اپنے گروپ کو بھیجنا چاہتے ہیں؟';

  @override
  String get customizeMessage => 'اپنا پیغام حسبِ ضرورت بنائیں...';

  @override
  String get saveGroupForRecognition => 'گروپ کو شناخت کے لیے محفوظ کریں';

  @override
  String get groupNameOptional => 'گروپ کا نام (اختیاری)';

  @override
  String get enterGroupName => 'شناخت کے لیے گروپ کا نام درج کریں';

  @override
  String get knownGroupDetected => 'معروف گروپ شناخت ہو گیا';

  @override
  String get meetingSharedSuccessfully => 'ملاقات کامیابی سے شیئر کی گئی!';

  @override
  String get bookingConfirmedShare =>
      'بُکنگ کی تصدیق ہو گئی! اب آپ دعوت شیئر کر سکتے ہیں۔';

  @override
  String get defaultShareMessage =>
      'ہیلو! میں نے APP-OINT کے ذریعے آپ کے ساتھ ملاقات شیڈول کی ہے۔ تصدیق کرنے یا دوسرا وقت تجویز کرنے کے لیے یہاں کلک کریں:';

  @override
  String get dashboard => 'ڈیش بورڈ';

  @override
  String get businessDashboard => 'کاروباری ڈیش بورڈ';

  @override
  String get myProfile => 'میری پروفائل';

  @override
  String get noProfileFound => 'کوئی پروفائل نہیں ملی';

  @override
  String get errorLoadingProfile => 'پروفائل لوڈ کرنے میں خرابی';

  @override
  String get myInvites => 'میرے دعوت نامے';

  @override
  String get inviteDetail => 'دعوت کی تفصیل';

  @override
  String get inviteContact => 'رابطہ دعوت دیں';

  @override
  String get noInvites => 'کوئی دعوت نہیں';

  @override
  String get errorLoadingInvites => 'دعوت نامے لوڈ کرنے میں خرابی';

  @override
  String get accept => 'قبول کریں';

  @override
  String get decline => 'مسترد کریں';

  @override
  String get sendInvite => 'دعوت بھیجیں';

  @override
  String get name => 'نام';

  @override
  String get phoneNumber => 'فون نمبر';

  @override
  String get emailOptional => 'ای میل (اختیاری)';

  @override
  String get requiresInstallFallback => 'انسٹالیشن درکار ہے';

  @override
  String get notifications => 'اطلاعات';

  @override
  String get notificationSettings => 'اطلاع کی ترتیبات';

  @override
  String get enableNotifications => 'اطلاعات فعال کریں';

  @override
  String get errorFetchingToken => 'ٹوکن حاصل کرنے میں خرابی';

  @override
  String fcmToken(String token) {
    return 'ایف سی ایم ٹوکن: $token';
  }

  @override
  String get familyDashboard => 'فیملی ڈیش بورڈ';

  @override
  String get pleaseLoginForFamilyFeatures =>
      'خاندانی خصوصیات کے لیے براہ کرم لاگ ان کریں';

  @override
  String get familyMembers => 'خاندان کے افراد';

  @override
  String get invite => 'دعوت دیں';

  @override
  String get pendingInvites => 'زیر التواء دعوتیں';

  @override
  String get connectedChildren => 'منسلک بچے';

  @override
  String get noFamilyMembersYet =>
      'ابھی تک کوئی خاندانی رکن نہیں۔ شروع کرنے کے لیے کسی کو مدعو کریں!';

  @override
  String errorLoadingFamilyLinks(String error) {
    return 'خاندانی روابط لوڈ کرنے میں خرابی: $error';
  }

  @override
  String get inviteChild => 'بچے کو دعوت دیں';

  @override
  String get managePermissions => 'اجازتوں کا نظم کریں';

  @override
  String get removeChild => 'بچے کو ہٹائیں';

  @override
  String get loading => 'لوڈ ہو رہا ہے...';

  @override
  String get childEmail => 'بچے کا ای میل';

  @override
  String get childEmailOrPhone => 'بچے کا ای میل یا فون';

  @override
  String get enterChildEmail => 'بچے کا ای میل درج کریں';

  @override
  String get otpCode => 'او ٹی پی کوڈ';

  @override
  String get enterOtp => 'او ٹی پی درج کریں';

  @override
  String get verify => 'تصدیق کریں';

  @override
  String get otpResentSuccessfully => 'او ٹی پی کامیابی سے دوبارہ بھیجا گیا!';

  @override
  String failedToResendOtp(String error) {
    return 'او ٹی پی دوبارہ بھیجنے میں ناکامی: $error';
  }

  @override
  String get childLinkedSuccessfully => 'بچہ کامیابی سے منسلک ہو گیا!';

  @override
  String get invitationSentSuccessfully => 'دعوت کامیابی سے بھیج دی گئی!';

  @override
  String failedToSendInvitation(String error) {
    return 'دعوت بھیجنے میں ناکامی: $error';
  }

  @override
  String get pleaseEnterValidEmail => 'براہ کرم درست ای میل درج کریں';

  @override
  String get pleaseEnterValidEmailOrPhone =>
      'براہ کرم درست ای میل یا فون نمبر درج کریں';

  @override
  String get invalidCode => 'غلط کوڈ، دوبارہ کوشش کریں';

  @override
  String get cancelInvite => 'دعوت منسوخ کریں';

  @override
  String get cancelInviteConfirmation =>
      'کیا آپ واقعی اس دعوت کو منسوخ کرنا چاہتے ہیں؟';

  @override
  String get no => 'نہیں';

  @override
  String get yesCancel => 'ہاں، منسوخ کریں';

  @override
  String get inviteCancelledSuccessfully => 'دعوت کامیابی سے منسوخ ہو گئی!';

  @override
  String failedToCancelInvite(String error) {
    return 'دعوت منسوخ کرنے میں ناکامی: $error';
  }

  @override
  String get revokeAccess => 'رسائی منسوخ کریں';

  @override
  String get revokeAccessConfirmation =>
      'کیا آپ واقعی اس بچے کی رسائی منسوخ کرنا چاہتے ہیں؟ یہ عمل ناقابل واپسی ہے۔';

  @override
  String get revoke => 'منسوخ کریں';

  @override
  String get accessRevokedSuccessfully => 'رسائی کامیابی سے منسوخ ہو گئی!';

  @override
  String failedToRevokeAccess(String error) {
    return 'رسائی منسوخ کرنے میں ناکامی: $error';
  }

  @override
  String get grantConsent => 'اجازت دیں';

  @override
  String get revokeConsent => 'اجازت واپس لیں';

  @override
  String get consentGrantedSuccessfully => 'اجازت کامیابی سے دی گئی!';

  @override
  String get consentRevokedSuccessfully => 'اجازت کامیابی سے واپس لے لی گئی!';

  @override
  String failedToUpdateConsent(String error) {
    return 'اجازت کو اپ ڈیٹ کرنے میں ناکامی: $error';
  }

  @override
  String get checkingPermissions => 'اجازتیں چیک کی جا رہی ہیں...';

  @override
  String get cancel => 'منسوخ کریں';

  @override
  String get close => 'بند کریں';

  @override
  String get save => 'محفوظ کریں';

  @override
  String get sendNow => 'ابھی بھیجیں';

  @override
  String get details => 'تفصیلات';

  @override
  String get noBroadcastMessages => 'ابھی تک کوئی نشریاتی پیغام نہیں';

  @override
  String errorCheckingPermissions(String error) {
    return 'اجازتیں چیک کرنے میں خرابی: $error';
  }

  @override
  String get mediaOptional => 'میڈیا (اختیاری)';

  @override
  String get pickImage => 'تصویر منتخب کریں';

  @override
  String get pickVideo => 'ویڈیو منتخب کریں';

  @override
  String get pollOptions => 'پول آپشنز:';

  @override
  String get targetingFilters => 'ہدف سازی کے فلٹرز';

  @override
  String get scheduling => 'شیڈولنگ';

  @override
  String get scheduleForLater => 'بعد میں شیڈول کریں';

  @override
  String errorEstimatingRecipients(String error) {
    return 'وصول کنندگان کا اندازہ لگانے میں خرابی: $error';
  }

  @override
  String errorPickingImage(String error) {
    return 'تصویر منتخب کرنے میں خرابی: $error';
  }

  @override
  String errorPickingVideo(String error) {
    return 'ویڈیو منتخب کرنے میں خرابی: $error';
  }

  @override
  String get noPermissionForBroadcast =>
      'آپ کو نشریاتی پیغامات بنانے کی اجازت نہیں ہے۔';

  @override
  String get messageSavedSuccessfully => 'پیغام کامیابی سے محفوظ ہو گیا';

  @override
  String errorSavingMessage(String error) {
    return 'پیغام محفوظ کرنے میں خرابی: $error';
  }

  @override
  String get messageSentSuccessfully => 'پیغام کامیابی سے بھیجا گیا';

  @override
  String errorSendingMessage(String error) {
    return 'پیغام بھیجنے میں خرابی: $error';
  }

  @override
  String content(String content) {
    return 'مواد: $content';
  }

  @override
  String type(String type) {
    return 'قسم: $type';
  }

  @override
  String link(String link) {
    return 'لنک: $link';
  }

  @override
  String status(String status) {
    return 'حیثیت: $status';
  }

  @override
  String recipients(String count) {
    return 'وصول کنندگان: $count';
  }

  @override
  String opened(String count) {
    return 'کھولا گیا: $count';
  }

  @override
  String clicked(String count) {
    return 'کلک کیا گیا: $count';
  }

  @override
  String created(String date) {
    return 'بنایا گیا: $date';
  }

  @override
  String scheduled(String date) {
    return 'شیڈول: $date';
  }

  @override
  String get organizations => 'تنظیمیں';

  @override
  String get noOrganizations => 'کوئی تنظیم نہیں';

  @override
  String get errorLoadingOrganizations => 'تنظیمیں لوڈ کرنے میں خرابی';

  @override
  String members(String count) {
    return '$count اراکین';
  }

  @override
  String get users => 'صارفین';

  @override
  String get noUsers => 'کوئی صارف نہیں';

  @override
  String get errorLoadingUsers => 'صارفین لوڈ کرنے میں خرابی';

  @override
  String get changeRole => 'کردار تبدیل کریں';

  @override
  String get totalAppointments => 'کل ملاقاتیں';

  @override
  String get completedAppointments => 'مکمل ملاقاتیں';

  @override
  String get revenue => 'آمدنی';

  @override
  String get errorLoadingStats => 'اعدادوشمار لوڈ کرنے میں خرابی';

  @override
  String appointment(String id) {
    return 'ملاقات: $id';
  }

  @override
  String from(String name) {
    return 'سے: $name';
  }

  @override
  String phone(String number) {
    return 'فون: $number';
  }

  @override
  String noRouteDefined(String route) {
    return '$route کے لیے کوئی راستہ متعین نہیں';
  }

  @override
  String get meetingDetails => 'ملاقات کی تفصیلات';

  @override
  String meetingId(String id) {
    return 'ملاقات کی شناخت: $id';
  }

  @override
  String creator(String id) {
    return 'تخلیق کار: $id';
  }

  @override
  String context(String id) {
    return 'سیاق و سباق: $id';
  }

  @override
  String group(String id) {
    return 'گروپ: $id';
  }

  @override
  String get requestPrivateSession => 'نجی سیشن کی درخواست کریں';

  @override
  String get privacyRequestSent => 'نجی سیشن کی درخواست والدین کو بھیج دی گئی!';

  @override
  String failedToSendPrivacyRequest(String error) {
    return 'نجی درخواست بھیجنے میں ناکامی: $error';
  }

  @override
  String errorLoadingPrivacyRequests(String error) {
    return 'پرائیویسی درخواستیں لوڈ کرنے میں خرابی: $error';
  }

  @override
  String requestType(String type) {
    return '$type درخواست';
  }

  @override
  String statusColon(String status) {
    return 'حیثیت: $status';
  }

  @override
  String failedToActionPrivacyRequest(String action, String error) {
    return '$action پرائیویسی درخواست پر عملدرآمد میں ناکامی: $error';
  }

  @override
  String get yes => 'جی ہاں';

  @override
  String get send => 'بھیجیں';

  @override
  String get permissions => 'اجازتیں';

  @override
  String permissionsFor(String childId) {
    return 'اجازتیں - $childId';
  }

  @override
  String errorLoadingPermissions(String error) {
    return 'اجازتیں لوڈ کرنے میں خرابی: $error';
  }

  @override
  String get none => 'کوئی نہیں';

  @override
  String get readOnly => 'صرف پڑھنے کے لیے';

  @override
  String get readWrite => 'پڑھنے اور لکھنے کی اجازت';

  @override
  String permissionUpdated(String category, String newValue) {
    return 'اجازت $category کو $newValue پر اپ ڈیٹ کیا گیا';
  }

  @override
  String failedToUpdatePermission(String error) {
    return 'اجازت کو اپ ڈیٹ کرنے میں ناکامی: $error';
  }

  @override
  String invited(String date) {
    return 'مدعو: $date';
  }

  @override
  String get adminBroadcast => 'ایڈمن نشریات';

  @override
  String get composeBroadcastMessage => 'نشریاتی پیغام لکھیں';

  @override
  String get adminScreenTBD => 'ایڈمن اسکرین - تیار ہونا باقی ہے';

  @override
  String get staffScreenTBD => 'اسٹاف اسکرین - تیار ہونا باقی ہے';

  @override
  String get clientScreenTBD => 'کلائنٹ اسکرین - تیار ہونا باقی ہے';

  @override
  String get ambassadorTitle => 'سفیر';

  @override
  String get ambassadorOnboardingTitle => 'سفیر بنیں';

  @override
  String get ambassadorOnboardingSubtitle =>
      'اپنی زبان اور علاقے میں ہماری کمیونٹی کو بڑھانے میں مدد کریں۔';

  @override
  String get ambassadorOnboardingButton => 'ابھی شروع کریں';

  @override
  String get ambassadorDashboardTitle => 'سفیر ڈیش بورڈ';

  @override
  String get ambassadorDashboardSubtitle =>
      'آپ کی اعدادوشمار اور سرگرمیوں کا جائزہ';

  @override
  String get ambassadorDashboardChartLabel => 'اس ہفتے مدعو کیے گئے صارفین';

  @override
  String get REDACTED_TOKEN => 'باقی سفیر کی جگہیں';

  @override
  String get REDACTED_TOKEN => 'ملک اور زبان';

  @override
  String get ambassadorQuotaFull => 'آپ کے علاقے میں سفیر کی کوٹہ پوری ہے۔';

  @override
  String get ambassadorQuotaAvailable => 'سفیر کی جگہیں دستیاب ہیں!';

  @override
  String get ambassadorStatusAssigned => 'آپ ایک فعال سفیر ہیں۔';

  @override
  String get ambassadorStatusNotEligible =>
      'آپ سفیر کی حیثیت کے لیے اہل نہیں ہیں۔';

  @override
  String get ambassadorStatusWaiting => 'جگہ کی دستیابی کا انتظار...';

  @override
  String get ambassadorStatusRevoked =>
      'آپ کی سفیر کی حیثیت منسوخ کر دی گئی ہے۔';

  @override
  String get ambassadorNoticeAdultOnly =>
      'صرف بالغ اکاؤنٹس ہی سفیر بن سکتے ہیں۔';

  @override
  String get ambassadorNoticeQuotaReached =>
      'آپ کے ملک اور زبان کے لیے سفیر کی کوٹہ پوری ہو گئی ہے۔';

  @override
  String get ambassadorNoticeAutoAssign =>
      'سفارت کاری خودکار طور پر اہل صارفین کو دی جاتی ہے۔';
}
