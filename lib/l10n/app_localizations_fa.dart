// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'Appoint';

  @override
  String get welcome => 'خوش آمدید';

  @override
  String get home => 'خانه';

  @override
  String get menu => 'منو';

  @override
  String get profile => 'پروفایل';

  @override
  String get signOut => 'خروج';

  @override
  String get login => 'ورود';

  @override
  String get email => 'ایمیل';

  @override
  String get password => 'رمز عبور';

  @override
  String get signIn => 'ورود به سیستم';

  @override
  String get bookMeeting => 'رزرو جلسه';

  @override
  String get bookAppointment => 'رزرو نوبت';

  @override
  String get bookingRequest => 'درخواست رزرو';

  @override
  String get confirmBooking => 'تأیید رزرو';

  @override
  String get chatBooking => 'رزرو از طریق چت';

  @override
  String get bookViaChat => 'رزرو با چت';

  @override
  String get submitBooking => 'ارسال رزرو';

  @override
  String get next => 'بعدی';

  @override
  String get selectStaff => 'انتخاب کارمند';

  @override
  String get pickDate => 'انتخاب تاریخ';

  @override
  String get staff => 'کارکنان';

  @override
  String get service => 'خدمت';

  @override
  String get dateTime => 'تاریخ و زمان';

  @override
  String duration(String duration) {
    return 'مدت زمان: $duration دقیقه';
  }

  @override
  String get notSelected => 'انتخاب نشده';

  @override
  String get noSlots => 'وقت خالی موجود نیست';

  @override
  String get bookingConfirmed => 'رزرو تأیید شد';

  @override
  String get failedToConfirmBooking => 'تأیید رزرو با شکست مواجه شد';

  @override
  String get noBookingsFound => 'هیچ رزروی یافت نشد';

  @override
  String errorLoadingBookings(String error) {
    return 'خطا در بارگذاری رزروها: $error';
  }

  @override
  String get shareOnWhatsApp => 'اشتراک‌گذاری در واتساپ';

  @override
  String get shareMeetingInvitation => 'اشتراک‌گذاری دعوت جلسه:';

  @override
  String get meetingReadyMessage =>
      'جلسه آماده است! می‌خواهید آن را برای گروه ارسال کنید؟';

  @override
  String get customizeMessage => 'پیام خود را سفارشی کنید...';

  @override
  String get saveGroupForRecognition => 'ذخیره گروه برای شناسایی در آینده';

  @override
  String get groupNameOptional => 'نام گروه (اختیاری)';

  @override
  String get enterGroupName => 'نام گروه را وارد کنید برای شناسایی';

  @override
  String get knownGroupDetected => 'گروه شناخته‌شده شناسایی شد';

  @override
  String get meetingSharedSuccessfully => 'جلسه با موفقیت به اشتراک گذاشته شد!';

  @override
  String get bookingConfirmedShare =>
      'رزرو تأیید شد! اکنون می‌توانید دعوت را به اشتراک بگذارید.';

  @override
  String get defaultShareMessage =>
      'سلام! من یک جلسه با شما از طریق APP-OINT برنامه‌ریزی کرده‌ام. برای تأیید یا پیشنهاد زمان دیگر کلیک کنید:';

  @override
  String get dashboard => 'داشبورد';

  @override
  String get businessDashboard => 'داشبورد کسب‌وکار';

  @override
  String get myProfile => 'پروفایل من';

  @override
  String get noProfileFound => 'پروفایلی یافت نشد';

  @override
  String get errorLoadingProfile => 'خطا در بارگذاری پروفایل';

  @override
  String get myInvites => 'دعوت‌نامه‌های من';

  @override
  String get inviteDetail => 'جزئیات دعوت';

  @override
  String get inviteContact => 'تماس دعوت';

  @override
  String get noInvites => 'دعوتی موجود نیست';

  @override
  String get errorLoadingInvites => 'خطا در بارگذاری دعوت‌ها';

  @override
  String get accept => 'پذیرش';

  @override
  String get decline => 'رد کردن';

  @override
  String get sendInvite => 'ارسال دعوت';

  @override
  String get name => 'نام';

  @override
  String get phoneNumber => 'شماره تلفن';

  @override
  String get emailOptional => 'ایمیل (اختیاری)';

  @override
  String get requiresInstallFallback => 'نیاز به نصب دارد';

  @override
  String get notifications => 'اعلان‌ها';

  @override
  String get notificationSettings => 'تنظیمات اعلان';

  @override
  String get enableNotifications => 'فعال‌سازی اعلان‌ها';

  @override
  String get errorFetchingToken => 'خطا در دریافت توکن';

  @override
  String fcmToken(String token) {
    return 'توکن FCM: $token';
  }

  @override
  String get familyDashboard => 'داشبورد خانواده';

  @override
  String get pleaseLoginForFamilyFeatures =>
      'برای استفاده از قابلیت‌های خانوادگی وارد شوید';

  @override
  String get familyMembers => 'اعضای خانواده';

  @override
  String get invite => 'دعوت';

  @override
  String get pendingInvites => 'دعوت‌های در انتظار';

  @override
  String get connectedChildren => 'کودکان متصل شده';

  @override
  String get noFamilyMembersYet =>
      'هنوز هیچ عضو خانواده‌ای اضافه نشده است. برای شروع کسی را دعوت کنید!';

  @override
  String errorLoadingFamilyLinks(String error) {
    return 'خطا در بارگذاری ارتباطات خانوادگی: $error';
  }

  @override
  String get inviteChild => 'دعوت کودک';

  @override
  String get managePermissions => 'مدیریت دسترسی‌ها';

  @override
  String get removeChild => 'حذف کودک';

  @override
  String get loading => 'در حال بارگذاری...';

  @override
  String get childEmail => 'ایمیل کودک';

  @override
  String get childEmailOrPhone => 'ایمیل یا تلفن کودک';

  @override
  String get enterChildEmail => 'ایمیل کودک را وارد کنید';

  @override
  String get otpCode => 'کد OTP';

  @override
  String get enterOtp => 'کد OTP را وارد کنید';

  @override
  String get verify => 'تأیید';

  @override
  String get otpResentSuccessfully => 'کد OTP با موفقیت دوباره ارسال شد!';

  @override
  String failedToResendOtp(String error) {
    return 'ارسال مجدد OTP با شکست مواجه شد: $error';
  }

  @override
  String get childLinkedSuccessfully => 'کودک با موفقیت متصل شد!';

  @override
  String get invitationSentSuccessfully => 'دعوت‌نامه با موفقیت ارسال شد!';

  @override
  String failedToSendInvitation(String error) {
    return 'ارسال دعوت‌نامه با شکست مواجه شد: $error';
  }

  @override
  String get pleaseEnterValidEmail => 'لطفاً یک ایمیل معتبر وارد کنید';

  @override
  String get pleaseEnterValidEmailOrPhone =>
      'لطفاً ایمیل یا شماره تلفن معتبر وارد کنید';

  @override
  String get invalidCode => 'کد نامعتبر است، دوباره امتحان کنید';

  @override
  String get cancelInvite => 'لغو دعوت';

  @override
  String get cancelInviteConfirmation =>
      'آیا مطمئن هستید که می‌خواهید این دعوت را لغو کنید؟';

  @override
  String get no => 'خیر';

  @override
  String get yesCancel => 'بله، لغو';

  @override
  String get inviteCancelledSuccessfully => 'دعوت با موفقیت لغو شد!';

  @override
  String failedToCancelInvite(String error) {
    return 'لغو دعوت با شکست مواجه شد: $error';
  }

  @override
  String get revokeAccess => 'لغو دسترسی';

  @override
  String get revokeAccessConfirmation =>
      'آیا مطمئن هستید که می‌خواهید دسترسی این کودک را لغو کنید؟ این عمل قابل بازگشت نیست.';

  @override
  String get revoke => 'لغو';

  @override
  String get accessRevokedSuccessfully => 'دسترسی با موفقیت لغو شد!';

  @override
  String failedToRevokeAccess(String error) {
    return 'لغو دسترسی با شکست مواجه شد: $error';
  }

  @override
  String get grantConsent => 'اعطای رضایت';

  @override
  String get revokeConsent => 'لغو رضایت';

  @override
  String get consentGrantedSuccessfully => 'رضایت با موفقیت اعطا شد!';

  @override
  String get consentRevokedSuccessfully => 'رضایت با موفقیت لغو شد!';

  @override
  String failedToUpdateConsent(String error) {
    return 'به‌روزرسانی رضایت با شکست مواجه شد: $error';
  }

  @override
  String get checkingPermissions => 'در حال بررسی مجوزها...';

  @override
  String get cancel => 'لغو';

  @override
  String get close => 'بستن';

  @override
  String get save => 'ذخیره';

  @override
  String get sendNow => 'ارسال اکنون';

  @override
  String get details => 'جزئیات';

  @override
  String get noBroadcastMessages => 'هنوز پیامی برای پخش وجود ندارد';

  @override
  String errorCheckingPermissions(String error) {
    return 'خطا در بررسی دسترسی‌ها: $error';
  }

  @override
  String get mediaOptional => 'رسانه (اختیاری)';

  @override
  String get pickImage => 'انتخاب تصویر';

  @override
  String get pickVideo => 'انتخاب ویدئو';

  @override
  String get pollOptions => 'گزینه‌های نظرسنجی:';

  @override
  String get targetingFilters => 'فیلترهای هدف‌گذاری';

  @override
  String get scheduling => 'زمان‌بندی';

  @override
  String get scheduleForLater => 'برنامه‌ریزی برای بعد';

  @override
  String errorEstimatingRecipients(String error) {
    return 'خطا در برآورد گیرندگان: $error';
  }

  @override
  String errorPickingImage(String error) {
    return 'خطا در انتخاب تصویر: $error';
  }

  @override
  String errorPickingVideo(String error) {
    return 'خطا در انتخاب ویدئو: $error';
  }

  @override
  String get noPermissionForBroadcast =>
      'شما مجاز به ایجاد پیام‌های پخش نیستید.';

  @override
  String get messageSavedSuccessfully => 'پیام با موفقیت ذخیره شد';

  @override
  String errorSavingMessage(String error) {
    return 'خطا در ذخیره پیام: $error';
  }

  @override
  String get messageSentSuccessfully => 'پیام با موفقیت ارسال شد';

  @override
  String errorSendingMessage(String error) {
    return 'خطا در ارسال پیام: $error';
  }

  @override
  String content(String content) {
    return 'محتوا: $content';
  }

  @override
  String type(String type) {
    return 'نوع: $type';
  }

  @override
  String link(String link) {
    return 'لینک: $link';
  }

  @override
  String status(String status) {
    return 'وضعیت: $status';
  }

  @override
  String recipients(String count) {
    return 'گیرندگان: $count';
  }

  @override
  String opened(String count) {
    return 'باز شده: $count';
  }

  @override
  String clicked(String count) {
    return 'کلیک شده: $count';
  }

  @override
  String created(String date) {
    return 'ایجاد شده: $date';
  }

  @override
  String scheduled(String date) {
    return 'زمان‌بندی شده: $date';
  }

  @override
  String get organizations => 'سازمان‌ها';

  @override
  String get noOrganizations => 'هیچ سازمانی وجود ندارد';

  @override
  String get errorLoadingOrganizations => 'خطا در بارگذاری سازمان‌ها';

  @override
  String members(String count) {
    return '$count عضو';
  }

  @override
  String get users => 'کاربران';

  @override
  String get noUsers => 'کاربری وجود ندارد';

  @override
  String get errorLoadingUsers => 'خطا در بارگذاری کاربران';

  @override
  String get changeRole => 'تغییر نقش';

  @override
  String get totalAppointments => 'مجموع نوبت‌ها';

  @override
  String get completedAppointments => 'نوبت‌های تکمیل‌شده';

  @override
  String get revenue => 'درآمد';

  @override
  String get errorLoadingStats => 'خطا در بارگذاری آمار';

  @override
  String appointment(String id) {
    return 'نوبت: $id';
  }

  @override
  String from(String name) {
    return 'از: $name';
  }

  @override
  String phone(String number) {
    return 'تلفن: $number';
  }

  @override
  String noRouteDefined(String route) {
    return 'مسیری برای $route تعریف نشده است';
  }

  @override
  String get meetingDetails => 'جزئیات جلسه';

  @override
  String meetingId(String id) {
    return 'شناسه جلسه: $id';
  }

  @override
  String creator(String id) {
    return 'سازنده: $id';
  }

  @override
  String context(String id) {
    return 'زمینه: $id';
  }

  @override
  String group(String id) {
    return 'گروه: $id';
  }

  @override
  String get requestPrivateSession => 'درخواست جلسه خصوصی';

  @override
  String get privacyRequestSent => 'درخواست حریم خصوصی به والدین شما ارسال شد!';

  @override
  String failedToSendPrivacyRequest(String error) {
    return 'ارسال درخواست حریم خصوصی با شکست مواجه شد: $error';
  }

  @override
  String errorLoadingPrivacyRequests(String error) {
    return 'خطا در بارگذاری درخواست‌های حریم خصوصی: $error';
  }

  @override
  String requestType(String type) {
    return 'درخواست $type';
  }

  @override
  String statusColon(String status) {
    return 'وضعیت: $status';
  }

  @override
  String failedToActionPrivacyRequest(String action, String error) {
    return 'انجام $action درخواست حریم خصوصی با شکست مواجه شد: $error';
  }

  @override
  String get yes => 'بله';

  @override
  String get send => 'ارسال';

  @override
  String get permissions => 'دسترسی‌ها';

  @override
  String permissionsFor(String childId) {
    return 'دسترسی‌ها - $childId';
  }

  @override
  String errorLoadingPermissions(String error) {
    return 'خطا در بارگذاری دسترسی‌ها: $error';
  }

  @override
  String get none => 'هیچ‌کدام';

  @override
  String get readOnly => 'فقط خواندنی';

  @override
  String get readWrite => 'خواندن و نوشتن';

  @override
  String permissionUpdated(String category, String newValue) {
    return 'دسترسی $category به $newValue به‌روزرسانی شد';
  }

  @override
  String failedToUpdatePermission(String error) {
    return 'به‌روزرسانی دسترسی با شکست مواجه شد: $error';
  }

  @override
  String invited(String date) {
    return 'دعوت‌شده: $date';
  }

  @override
  String get adminBroadcast => 'پخش ادمین';

  @override
  String get composeBroadcastMessage => 'نگارش پیام پخش';

  @override
  String get adminScreenTBD => 'صفحه مدیر - در حال توسعه';

  @override
  String get staffScreenTBD => 'صفحه کارکنان - در حال توسعه';

  @override
  String get clientScreenTBD => 'صفحه مشتری - در حال توسعه';

  @override
  String get ambassadorTitle => 'سفیر';

  @override
  String get ambassadorOnboardingTitle => 'سفیر شوید';

  @override
  String get ambassadorOnboardingSubtitle =>
      'به رشد جامعه ما در زبان و منطقه شما کمک کنید.';

  @override
  String get ambassadorOnboardingButton => 'اکنون شروع کنید';

  @override
  String get ambassadorDashboardTitle => 'داشبورد سفیر';

  @override
  String get ambassadorDashboardSubtitle => 'نمای کلی آمار و فعالیت‌های شما';

  @override
  String get ambassadorDashboardChartLabel => 'کاربران دعوت شده این هفته';

  @override
  String get ambassadorDashboardRemainingSlots => 'موقعیت‌های باقی‌مانده سفیر';

  @override
  String get ambassadorDashboardCountryLanguage => 'کشور و زبان';

  @override
  String get ambassadorQuotaFull => 'سهمیه سفیر در منطقه شما پر است.';

  @override
  String get ambassadorQuotaAvailable => 'موقعیت‌های سفیر موجود است!';

  @override
  String get ambassadorStatusAssigned => 'شما یک سفیر فعال هستید.';

  @override
  String get ambassadorStatusNotEligible =>
      'شما برای وضعیت سفیر واجد شرایط نیستید.';

  @override
  String get ambassadorStatusWaiting => 'در انتظار در دسترس بودن موقعیت...';

  @override
  String get ambassadorStatusRevoked => 'وضعیت سفیر شما لغو شده است.';

  @override
  String get ambassadorNoticeAdultOnly =>
      'فقط حساب‌های بزرگسال می‌توانند سفیر شوند.';

  @override
  String get ambassadorNoticeQuotaReached =>
      'سهمیه سفیر برای کشور و زبان شما به پایان رسیده است.';

  @override
  String get ambassadorNoticeAutoAssign =>
      'سفارت به طور خودکار به کاربران واجد شرایط اعطا می‌شود.';
}
