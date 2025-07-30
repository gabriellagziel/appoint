// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get refresh => 'تازه‌سازی';

  @override
  String get home => 'خانه';

  @override
  String get noSessionsYet => '[FA] هنوز جلسه‌ای برگزار نشده';

  @override
  String get ok => 'باشه';

  @override
  String get playtimeLandingChooseMode => '[FA] یک حالت را انتخاب کنید';

  @override
  String get signUp => 'ثبت‌نام';

  @override
  String get scheduleMessage => '[FA] برنامه‌ریزی پیام';

  @override
  String get decline => '[FA] رد کردن';

  @override
  String get adminBroadcast => '[FA] پخش ادمین';

  @override
  String get login => 'ورود';

  @override
  String get playtimeChooseFriends => '[FA] انتخاب دوستان';

  @override
  String get noInvites => '[FA] دعوتی موجود نیست';

  @override
  String get playtimeChooseTime => '[FA] انتخاب زمان';

  @override
  String get success => 'موفقیت';

  @override
  String get undo => 'واگرد';

  @override
  String opened(Object count) {
    return '[FA] باز شده: $count';
  }

  @override
  String get createVirtualSession => '[FA] ایجاد جلسه مجازی';

  @override
  String get messageSentSuccessfully => '[FA] پیام با موفقیت ارسال شد';

  @override
  String get redo => 'تکرار';

  @override
  String get next => 'بعدی';

  @override
  String get search => 'جستجو';

  @override
  String get cancelInviteConfirmation =>
      '[FA] آیا مطمئن هستید که می‌خواهید این دعوت را لغو کنید؟';

  @override
  String created(String created, Object date) {
    return '[FA] ایجاد شده: $date';
  }

  @override
  String get revokeAccess => '[FA] لغو دسترسی';

  @override
  String get playtimeLiveScheduled => '[FA] جلسه زنده برنامه‌ریزی شد';

  @override
  String get revokeAccessConfirmation =>
      '[FA] آیا مطمئن هستید که می‌خواهید دسترسی این کودک را لغو کنید؟ این عمل قابل بازگشت نیست.';

  @override
  String get download => 'دانلود';

  @override
  String get password => '[FA] رمز عبور';

  @override
  String errorLoadingFamilyLinks(Object error) {
    return '[FA] خطا در بارگذاری ارتباطات خانوادگی: $error';
  }

  @override
  String get cancel => 'لغو';

  @override
  String get playtimeCreate => '[FA] ایجاد Playtime';

  @override
  String failedToActionPrivacyRequest(Object action, Object error) {
    return '[FA] انجام $action درخواست حریم خصوصی با شکست مواجه شد: $error';
  }

  @override
  String get appTitle => '[FA] Appoint';

  @override
  String get accept => 'پذیرش';

  @override
  String get playtimeModeVirtual => '[FA] حالت مجازی';

  @override
  String get playtimeDescription => '[FA] توضیحات Playtime';

  @override
  String get delete => 'حذف';

  @override
  String get playtimeVirtualStarted => '[FA] جلسه مجازی آغاز شد';

  @override
  String get createYourFirstGame => '[FA] اولین بازی خود را بسازید';

  @override
  String get participants => 'شرکت‌کنندگان';

  @override
  String recipients(String recipients, Object count) {
    return '[FA] گیرندگان: $count';
  }

  @override
  String get noResults => '[FA] بدون نتیجه';

  @override
  String get yes => 'بله';

  @override
  String get invite => 'دعوت';

  @override
  String get playtimeModeLive => '[FA] حالت زنده';

  @override
  String get done => '[FA] انجام شد';

  @override
  String get defaultShareMessage =>
      '[FA] سلام! من یک جلسه با شما از طریق APP-OINT برنامه‌ریزی کرده‌ام. برای تأیید یا پیشنهاد زمان دیگر کلیک کنید:';

  @override
  String get no => 'خیر';

  @override
  String get playtimeHub => '[FA] مرکز Playtime';

  @override
  String get createLiveSession => '[FA] ایجاد جلسه زنده';

  @override
  String get enableNotifications => '[FA] فعال‌سازی اعلان‌ها';

  @override
  String invited(Object date) {
    return '[FA] دعوت‌شده: $date';
  }

  @override
  String content(String content) {
    return '[FA] محتوا: $content';
  }

  @override
  String get meetingSharedSuccessfully =>
      '[FA] جلسه با موفقیت به اشتراک گذاشته شد!';

  @override
  String get welcomeToPlaytime => '[FA] به Playtime خوش آمدید';

  @override
  String get viewAll => '[FA] نمایش همه';

  @override
  String get playtimeVirtual => '[FA] Playtime مجازی';

  @override
  String get staffScreenTBD => '[FA] صفحه کارکنان - در حال توسعه';

  @override
  String get cut => 'برش';

  @override
  String get inviteCancelledSuccessfully => '[FA] دعوت با موفقیت لغو شد!';

  @override
  String get retry => '[FA] تلاش مجدد';

  @override
  String get composeBroadcastMessage => '[FA] نگارش پیام پخش';

  @override
  String get sendNow => '[FA] ارسال اکنون';

  @override
  String get noGamesYet => '[FA] هنوز هیچ بازی نیست';

  @override
  String get select => '[FA] انتخاب کنید';

  @override
  String get about => 'درباره';

  @override
  String get choose => 'انتخاب';

  @override
  String get profile => 'پروفایل';

  @override
  String get removeChild => '[FA] حذف کودک';

  @override
  String status(String status) {
    return '[FA] وضعیت: $status';
  }

  @override
  String get logout => 'خروج';

  @override
  String get paste => 'چسباندن';

  @override
  String get welcome => '[FA] خوش آمدید';

  @override
  String get playtimeCreateSession => '[FA] ایجاد جلسه';

  @override
  String get familyMembers => '[FA] اعضای خانواده';

  @override
  String get upload => 'بارگذاری';

  @override
  String get upcomingSessions => '[FA] جلسات آینده';

  @override
  String get confirm => 'تأیید';

  @override
  String get playtimeLive => '[FA] Playtime زنده';

  @override
  String get errorLoadingInvites => '[FA] خطا در بارگذاری دعوت‌ها';

  @override
  String get targetingFilters => '[FA] فیلترهای هدف‌گذاری';

  @override
  String get pickVideo => '[FA] انتخاب ویدئو';

  @override
  String get playtimeGameDeleted => '[FA] بازی حذف شد';

  @override
  String get scheduleForLater => '[FA] برنامه‌ریزی برای بعد';

  @override
  String get accessRevokedSuccessfully => '[FA] دسترسی با موفقیت لغو شد!';

  @override
  String type(String type) {
    return '[FA] نوع: $type';
  }

  @override
  String get checkingPermissions => '[FA] در حال بررسی مجوزها...';

  @override
  String get copy => 'کپی';

  @override
  String get yesCancel => '[FA] بله، لغو';

  @override
  String get email => 'ایمیل';

  @override
  String get shareOnWhatsApp => '[FA] اشتراک‌گذاری در واتساپ';

  @override
  String get notificationSettings => '[FA] تنظیمات اعلان';

  @override
  String get myProfile => '[FA] پروفایل من';

  @override
  String get revoke => 'لغو';

  @override
  String get noBroadcastMessages => '[FA] هنوز پیامی برای پخش وجود ندارد';

  @override
  String requestType(Object type) {
    return '[FA] درخواست $type';
  }

  @override
  String get notifications => 'اعلان‌ها';

  @override
  String get details => 'جزئیات';

  @override
  String get cancelInvite => '[FA] لغو دعوت';

  @override
  String get createNew => '[FA] ایجاد جدید';

  @override
  String get settings => 'تنظیمات';

  @override
  String get playtimeReject => '[FA] رد Playtime';

  @override
  String get errorLoadingProfile => '[FA] خطا در بارگذاری پروفایل';

  @override
  String get edit => 'ویرایش';

  @override
  String get add => 'افزودن';

  @override
  String get playtimeGameApproved => '[FA] بازی تأیید شد';

  @override
  String get forgotPassword => '[FA] رمز عبور را فراموش کرده‌اید؟';

  @override
  String get familyDashboard => '[FA] داشبورد خانواده';

  @override
  String get loading => '[FA] در حال بارگذاری...';

  @override
  String get quickActions => '[FA] اقدامات سریع';

  @override
  String get playtimeTitle => '[FA] عنوان Playtime';

  @override
  String get otpResentSuccessfully => '[FA] کد OTP با موفقیت دوباره ارسال شد!';

  @override
  String errorCheckingPermissions(Object error) {
    return '[FA] خطا در بررسی دسترسی‌ها: $error';
  }

  @override
  String get clientScreenTBD => '[FA] صفحه مشتری - در حال توسعه';

  @override
  String fcmToken(Object token) {
    return '[FA] توکن FCM: $token';
  }

  @override
  String get pickImage => '[FA] انتخاب تصویر';

  @override
  String get previous => 'قبلی';

  @override
  String get noProfileFound => '[FA] پروفایلی یافت نشد';

  @override
  String get noFamilyMembersYet =>
      '[FA] هنوز هیچ عضو خانواده‌ای اضافه نشده است. برای شروع کسی را دعوت کنید!';

  @override
  String get mediaOptional => '[FA] رسانه (اختیاری)';

  @override
  String get messageSavedSuccessfully => '[FA] پیام با موفقیت ذخیره شد';

  @override
  String get scheduledFor => '[FA] زمان‌بندی شده برای';

  @override
  String get dashboard => 'داشبورد';

  @override
  String get noPermissionForBroadcast =>
      '[FA] شما مجاز به ایجاد پیام‌های پخش نیستید.';

  @override
  String get playtimeAdminPanelTitle => '[FA] Playtime Games – Admin';

  @override
  String get inviteDetail => '[FA] جزئیات دعوت';

  @override
  String scheduled(String scheduled, Object date) {
    return '[FA] زمان‌بندی شده: $date';
  }

  @override
  String failedToResendOtp(Object error) {
    return '[FA] ارسال مجدد OTP با شکست مواجه شد: $error';
  }

  @override
  String get scheduling => 'زمان‌بندی';

  @override
  String errorSavingMessage(String error) {
    return '[FA] خطا در ذخیره پیام: $error';
  }

  @override
  String get save => 'ذخیره';

  @override
  String get playtimeApprove => '[FA] تأیید Playtime';

  @override
  String get createYourFirstSession => '[FA] اولین جلسه خود را بسازید';

  @override
  String get playtimeGameRejected => '[FA] بازی رد شد';

  @override
  String failedToRevokeAccess(Object error) {
    return '[FA] لغو دسترسی با شکست مواجه شد: $error';
  }

  @override
  String get recentGames => '[FA] بازی‌های اخیر';

  @override
  String get customizeMessage => '[FA] پیام خود را سفارشی کنید...';

  @override
  String failedToCancelInvite(Object error) {
    return '[FA] لغو دعوت با شکست مواجه شد: $error';
  }

  @override
  String errorSendingMessage(String error) {
    return '[FA] خطا در ارسال پیام: $error';
  }

  @override
  String get confirmPassword => '[FA] تأیید رمز عبور';

  @override
  String errorLoadingPrivacyRequests(Object error) {
    return '[FA] خطا در بارگذاری درخواست‌های حریم خصوصی: $error';
  }

  @override
  String get connectedChildren => '[FA] کودکان متصل شده';

  @override
  String get share => 'اشتراک‌گذاری';

  @override
  String get playtimeEnterGameName => '[FA] نام بازی را وارد کنید';

  @override
  String get pleaseLoginForFamilyFeatures =>
      '[FA] برای استفاده از قابلیت‌های خانوادگی وارد شوید';

  @override
  String get myInvites => '[FA] دعوت‌نامه‌های من';

  @override
  String get createGame => '[FA] ایجاد بازی';

  @override
  String get playtimeNoSessions => '[FA] هیچ جلسه Playtime نیست';

  @override
  String get adminScreenTBD => '[FA] صفحه مدیر - در حال توسعه';

  @override
  String get playtimeParentDashboardTitle => '[FA] داشبورد والدین Playtime';

  @override
  String get close => 'بستن';

  @override
  String get back => 'بازگشت';

  @override
  String get playtimeChooseGame => '[FA] بازی را انتخاب کنید';

  @override
  String get managePermissions => '[FA] مدیریت دسترسی‌ها';

  @override
  String get pollOptions => '[FA] گزینه‌های نظرسنجی:';

  @override
  String clicked(String clicked, Object count) {
    return '[FA] کلیک شده: $count';
  }

  @override
  String link(String link) {
    return '[FA] لینک: $link';
  }

  @override
  String get meetingReadyMessage =>
      '[FA] جلسه آماده است! می‌خواهید آن را برای گروه ارسال کنید؟';

  @override
  String get pendingInvites => '[FA] دعوت‌های در انتظار';

  @override
  String statusColon(Object status) {
    return '[FA] وضعیت: $status';
  }

  @override
  String get pleaseLoginToViewProfile =>
      '[FA] لطفاً برای مشاهده پروفایل خود وارد شوید.';

  @override
  String get adminMetrics => '[FA] Admin Metrics';

  @override
  String get overview => '[FA] Overview';

  @override
  String get bookings => '[FA] Bookings';

  @override
  String get users => 'کاربران';

  @override
  String get revenue => 'درآمد';

  @override
  String get contentLibrary => '[FA] Content Library';

  @override
  String get authErrorUserNotFound =>
      '[FA] No account found with this email address.';

  @override
  String get authErrorWrongPassword =>
      '[FA] Incorrect password. Please try again.';

  @override
  String get authErrorInvalidEmail =>
      '[FA] Please enter a valid email address.';

  @override
  String get authErrorUserDisabled =>
      '[FA] This account has been disabled. Please contact support.';

  @override
  String get authErrorWeakPassword =>
      '[FA] Password is too weak. Please choose a stronger password.';

  @override
  String get authErrorEmailAlreadyInUse =>
      '[FA] An account with this email already exists.';

  @override
  String get authErrorTooManyRequests =>
      '[FA] Too many failed attempts. Please try again later.';

  @override
  String get authErrorOperationNotAllowed =>
      '[FA] This sign-in method is not enabled. Please contact support.';

  @override
  String get authErrorInvalidCredential =>
      '[FA] Invalid credentials. Please try again.';

  @override
  String get authErrorAccountExistsWithDifferentCredential =>
      '[FA] An account already exists with this email using a different sign-in method.';

  @override
  String get authErrorCredentialAlreadyInUse =>
      '[FA] These credentials are already associated with another account.';

  @override
  String get authErrorNetworkRequestFailed =>
      '[FA] Network error. Please check your connection and try again.';

  @override
  String get socialAccountConflictTitle => 'تعارض حساب الشبكة الاجتماعية';

  @override
  String socialAccountConflictMessage(Object email) {
    return 'يبدو أن هناك حساب موجود بالفعل';
  }

  @override
  String get linkAccounts => 'ربط الحسابات';

  @override
  String get signInWithExistingMethod => 'تسجيل الدخول بالطريقة الموجودة';

  @override
  String get authErrorRequiresRecentLogin =>
      '[FA] Please log in again to perform this operation.';

  @override
  String get authErrorAppNotAuthorized =>
      '[FA] This app is not authorized to use Firebase Authentication.';

  @override
  String get authErrorInvalidVerificationCode =>
      '[FA] The verification code is invalid.';

  @override
  String get authErrorInvalidVerificationId =>
      '[FA] The verification ID is invalid.';

  @override
  String get authErrorMissingVerificationCode =>
      '[FA] Please enter the verification code.';

  @override
  String get authErrorMissingVerificationId => '[FA] Missing verification ID.';

  @override
  String get authErrorInvalidPhoneNumber => '[FA] The phone number is invalid.';

  @override
  String get authErrorMissingPhoneNumber => '[FA] Please enter a phone number.';

  @override
  String get authErrorQuotaExceeded =>
      '[FA] The SMS quota for this project has been exceeded. Please try again later.';

  @override
  String get authErrorCodeExpired =>
      '[FA] The verification code has expired. Please request a new one.';

  @override
  String get authErrorSessionExpired =>
      '[FA] Your session has expired. Please log in again.';

  @override
  String get authErrorMultiFactorAuthRequired =>
      '[FA] Multi-factor authentication is required.';

  @override
  String get authErrorMultiFactorInfoNotFound =>
      '[FA] Multi-factor information not found.';

  @override
  String get authErrorMissingMultiFactorSession =>
      '[FA] Missing multi-factor session.';

  @override
  String get authErrorInvalidMultiFactorSession =>
      '[FA] Invalid multi-factor session.';

  @override
  String get authErrorSecondFactorAlreadyInUse =>
      '[FA] This second factor is already in use.';

  @override
  String get authErrorMaximumSecondFactorCountExceeded =>
      '[FA] Maximum number of second factors exceeded.';

  @override
  String get authErrorUnsupportedFirstFactor =>
      '[FA] Unsupported first factor for multi-factor authentication.';

  @override
  String get authErrorEmailChangeNeedsVerification =>
      '[FA] Email change requires verification.';

  @override
  String get authErrorPhoneNumberAlreadyExists =>
      '[FA] This phone number is already in use.';

  @override
  String get authErrorInvalidPassword =>
      '[FA] The password is invalid or too weak.';

  @override
  String get authErrorInvalidIdToken => '[FA] The ID token is invalid.';

  @override
  String get authErrorIdTokenExpired => '[FA] The ID token has expired.';

  @override
  String get authErrorIdTokenRevoked => '[FA] The ID token has been revoked.';

  @override
  String get authErrorInternalError =>
      '[FA] An internal error occurred. Please try again.';

  @override
  String get authErrorInvalidArgument =>
      '[FA] An invalid argument was provided.';

  @override
  String get authErrorInvalidClaims => '[FA] Invalid custom claims provided.';

  @override
  String get authErrorInvalidContinueUri => '[FA] The continue URL is invalid.';

  @override
  String get authErrorInvalidCreationTime =>
      '[FA] The creation time is invalid.';

  @override
  String get authErrorInvalidDisabledField =>
      '[FA] The disabled field value is invalid.';

  @override
  String get authErrorInvalidDisplayName => '[FA] The display name is invalid.';

  @override
  String get authErrorInvalidDynamicLinkDomain =>
      '[FA] The dynamic link domain is invalid.';

  @override
  String get authErrorInvalidEmailVerified =>
      '[FA] The email verified value is invalid.';

  @override
  String get authErrorInvalidHashAlgorithm =>
      '[FA] The hash algorithm is invalid.';

  @override
  String get authErrorInvalidHashBlockSize =>
      '[FA] The hash block size is invalid.';

  @override
  String get authErrorInvalidHashDerivedKeyLength =>
      '[FA] The hash derived key length is invalid.';

  @override
  String get authErrorInvalidHashKey => '[FA] The hash key is invalid.';

  @override
  String get authErrorInvalidHashMemoryCost =>
      '[FA] The hash memory cost is invalid.';

  @override
  String get authErrorInvalidHashParallelization =>
      '[FA] The hash parallelization is invalid.';

  @override
  String get authErrorInvalidHashRounds =>
      '[FA] The hash rounds value is invalid.';

  @override
  String get authErrorInvalidHashSaltSeparator =>
      '[FA] The hash salt separator is invalid.';

  @override
  String get authErrorInvalidLastSignInTime =>
      '[FA] The last sign-in time is invalid.';

  @override
  String get authErrorInvalidPageToken => '[FA] The page token is invalid.';

  @override
  String get authErrorInvalidProviderData =>
      '[FA] The provider data is invalid.';

  @override
  String get authErrorInvalidProviderId => '[FA] The provider ID is invalid.';

  @override
  String get authErrorInvalidSessionCookieDuration =>
      '[FA] The session cookie duration is invalid.';

  @override
  String get authErrorInvalidUid => '[FA] The UID is invalid.';

  @override
  String get authErrorInvalidUserImport =>
      '[FA] The user import record is invalid.';

  @override
  String get authErrorMaximumUserCountExceeded =>
      '[FA] Maximum user import count exceeded.';

  @override
  String get authErrorMissingAndroidPkgName =>
      '[FA] Missing Android package name.';

  @override
  String get authErrorMissingContinueUri => '[FA] Missing continue URL.';

  @override
  String get authErrorMissingHashAlgorithm => '[FA] Missing hash algorithm.';

  @override
  String get authErrorMissingIosBundleId => '[FA] Missing iOS bundle ID.';

  @override
  String get authErrorMissingUid => '[FA] Missing UID.';

  @override
  String get authErrorMissingOauthClientSecret =>
      '[FA] Missing OAuth client secret.';

  @override
  String get authErrorProjectNotFound => '[FA] Firebase project not found.';

  @override
  String get authErrorReservedClaims => '[FA] Reserved claims provided.';

  @override
  String get authErrorSessionCookieExpired =>
      '[FA] Session cookie has expired.';

  @override
  String get authErrorSessionCookieRevoked =>
      '[FA] Session cookie has been revoked.';

  @override
  String get authErrorUidAlreadyExists => '[FA] The UID is already in use.';

  @override
  String get authErrorUnauthorizedContinueUri =>
      '[FA] The continue URL domain is not whitelisted.';

  @override
  String get authErrorUnknown =>
      '[FA] An unknown authentication error occurred.';

  @override
  String get checkingPermissions1 => 'فحص الأذونات...';

  @override
  String get paymentSuccessful => 'تم الدفع بنجاح';

  @override
  String get businessAvailability => 'توفر الأعمال';

  @override
  String get send => 'إرسال';

  @override
  String newNotificationPayloadtitle(Object payloadTitle, Object title) {
    return 'عنوان الإشعار الجديد: $title';
  }

  @override
  String get gameList => 'قائمة الألعاب';

  @override
  String get deleteAvailability => 'حذف التوفر';

  @override
  String get connectToGoogleCalendar => 'الاتصال بتقويم Google';

  @override
  String get adminFreeAccess => '[FA] Admin Free Access';

  @override
  String emailProfileemail(Object email, Object profileEmail) {
    return 'البريد الإلكتروني للملف الشخصي: $email';
  }

  @override
  String get calendar => 'التقويم';

  @override
  String get upload1 => '[FA] Upload (Persian)';

  @override
  String get resolved => 'تم الحل';

  @override
  String get keepSubscription => 'الاحتفاظ بالاشتراك';

  @override
  String get virtualSessionCreatedInvitingFriends =>
      '[FA] Virtual session created! Inviting friends... (Persian)';

  @override
  String get noEventsScheduledForToday => 'لا توجد أحداث مجدولة لليوم';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get rewards => '[FA] Rewards (Persian)';

  @override
  String get time => '[FA] Time (Persian)';

  @override
  String userCid(Object cid, Object id) {
    return '[FA] User $id';
  }

  @override
  String get noSlots => '[FA] وقت خالی موجود نیست';

  @override
  String get signIn => '[FA] ورود به سیستم';

  @override
  String get homeFeedScreen => '[FA] Home Feed Screen (Persian)';

  @override
  String get selectLocation => '[FA] Select Location (Persian)';

  @override
  String get noTicketsYet => '[FA] No tickets yet (Persian)';

  @override
  String get meetingSharedSuccessfully1 => 'تم مشاركة الاجتماع بنجاح';

  @override
  String get studioProfile => 'ملف الاستوديو';

  @override
  String get subscriptionUnavailable =>
      '[FA] Subscription unavailable (Persian)';

  @override
  String get confirmBooking => '[FA] تأیید رزرو';

  @override
  String get failedToUpdatePermissionE =>
      '[FA] Failed to update permission: \$e (Persian)';

  @override
  String get reject => '[FA] Reject (Persian)';

  @override
  String ambassadorStatusAmbassadorstatus(Object ambassadorStatus) {
    return '[FA] Ambassador Status: $ambassadorStatus (Persian)';
  }

  @override
  String get noProviders => '[FA] No providers';

  @override
  String get checkingSubscription => '[FA] Checking subscription... (Persian)';

  @override
  String errorPickingImageE(Object e) {
    return 'خطأ في اختيار الصورة: $e';
  }

  @override
  String get noContentAvailableYet => '[FA] No content available yet (Persian)';

  @override
  String get resolve => '[FA] Resolve (Persian)';

  @override
  String get errorLoadingSurveysError =>
      '[FA] Error loading surveys: \$error (Persian)';

  @override
  String errorLogerrormessage(Object errorMessage) {
    return '[FA] Error: $errorMessage';
  }

  @override
  String get getHelpWithYourAccount =>
      '[FA] Get help with your account (Persian)';

  @override
  String get pay => '[FA] Pay (Persian)';

  @override
  String get noOrganizations => '[FA] هیچ سازمانی وجود ندارد';

  @override
  String get meetingDetails => 'تفاصيل الاجتماع';

  @override
  String get errorLoadingAppointments => 'خطأ في تحميل المواعيد';

  @override
  String get changesSavedSuccessfully =>
      '[FA] Changes saved successfully! (Persian)';

  @override
  String get createNewInvoice => '[FA] Create New Invoice (Persian)';

  @override
  String get profileNotFound => 'الملف الشخصي غير موجود';

  @override
  String errorConfirmingPaymentE(Object e) {
    return 'خطأ في تأكيد الدفع: $e';
  }

  @override
  String get inviteFriends => 'دعوة الأصدقاء';

  @override
  String get profileSaved => '[FA] Profile saved! (Persian)';

  @override
  String get receiveBookingNotificationsViaEmail =>
      'استقبال إشعارات الحجز عبر البريد الإلكتروني';

  @override
  String valuetointk(Object k, Object value) {
    return '[FA] \\\$${value}K (Persian)';
  }

  @override
  String get deleteAccount => '[FA] Delete Account (Persian)';

  @override
  String get profile1 => 'الملف الشخصي';

  @override
  String get businessOnboarding => '[FA] Business Onboarding (Persian)';

  @override
  String get addNewClient => '[FA] Add New Client (Persian)';

  @override
  String get darkMode => '[FA] Dark Mode (Persian)';

  @override
  String get addProvider => '[FA] Add Provider';

  @override
  String noRouteDefinedForStateuripath(Object path) {
    return '[FA] No route defined for $path';
  }

  @override
  String get youWillReceiveAConfirmationEmailShortly =>
      '[FA] You will receive a confirmation email shortly. (Persian)';

  @override
  String get addQuestion => '[FA] Add Question (Persian)';

  @override
  String get privacyPolicy => '[FA] Privacy Policy (Persian)';

  @override
  String branchesLengthBranches(Object branchCount) {
    return '[FA] $branchCount branches (Persian)';
  }

  @override
  String get join => '[FA] Join (Persian)';

  @override
  String get businessSubscription => '[FA] Business Subscription (Persian)';

  @override
  String get myInvites1 => 'دعواتي';

  @override
  String get providers => '[FA] Providers';

  @override
  String get surveyManagement => '[FA] Survey Management (Persian)';

  @override
  String get pleaseEnterAValidEmailOrPhone =>
      '[FA] Please enter a valid email or phone';

  @override
  String get noRoomsFoundAddYourFirstRoom =>
      '[FA] No rooms found. Add your first room! (Persian)';

  @override
  String get readOurPrivacyPolicy => '[FA] Read our privacy policy (Persian)';

  @override
  String get couldNotOpenPrivacyPolicy =>
      '[FA] Could not open privacy policy (Persian)';

  @override
  String get refresh1 => '[FA] Refresh (Persian)';

  @override
  String get roomUpdatedSuccessfully =>
      '[FA] Room updated successfully! (Persian)';

  @override
  String get contentDetail => '[FA] Content Detail (Persian)';

  @override
  String get cancelSubscription => '[FA] Cancel Subscription (Persian)';

  @override
  String get successfullyRegisteredAsAmbassador =>
      '[FA] Successfully registered as Ambassador! (Persian)';

  @override
  String get save1 => '[FA] Save (Persian)';

  @override
  String get copy1 => '[FA] Copy (Persian)';

  @override
  String get failedToSendInvitationE =>
      '[FA] Failed to send invitation: \$e (Persian)';

  @override
  String get surveyScore => '[FA] Survey Score (Persian)';

  @override
  String userUserid(Object userId) {
    return '[FA] User \$userId';
  }

  @override
  String get noAppointmentsFound => '[FA] No appointments found. (Persian)';

  @override
  String get responseDetail => '[FA] Response Detail (Persian)';

  @override
  String get businessVerificationScreenComingSoon =>
      'شاشة التحقق من الأعمال - قريباً';

  @override
  String get businessProfileActivatedSuccessfully =>
      'تم تفعيل الملف التجاري بنجاح';

  @override
  String get failedToStartProSubscriptionE =>
      '[FA] Failed to start Pro subscription: \$e (Persian)';

  @override
  String get businessDashboardEntryScreenComingSoon =>
      '[FA] Business Dashboard Entry Screen - Coming Soon (Persian)';

  @override
  String get contentFilter => '[FA] Content Filter (Persian)';

  @override
  String get helpSupport => '[FA] Help & Support (Persian)';

  @override
  String get editRoom => '[FA] Edit Room (Persian)';

  @override
  String appointmentApptid(Object appointmentId) {
    return '[FA] Appointment: $appointmentId';
  }

  @override
  String deviceLogdeviceinfo(Object deviceInfo) {
    return '[FA] Device: $deviceInfo';
  }

  @override
  String get businessCrmEntryScreenComingSoon =>
      '[FA] Business CRM Entry Screen - Coming Soon (Persian)';

  @override
  String get adminDashboard => '[FA] Admin Dashboard';

  @override
  String orgmemberidslengthMembers(Object memberCount) {
    return '[FA] $memberCount members';
  }

  @override
  String get errorLoadingDashboardError =>
      '[FA] Error loading dashboard: \$error (Persian)';

  @override
  String get gameDeletedSuccessfully =>
      '[FA] Game deleted successfully! (Persian)';

  @override
  String get viewResponsesComingSoon =>
      '[FA] View responses - Coming soon! (Persian)';

  @override
  String get deleteProvider => '[FA] Delete Provider';

  @override
  String get errorLoadingRewards => '[FA] Error loading rewards (Persian)';

  @override
  String get failedToDeleteAccountE =>
      '[FA] Failed to delete account: \$e (Persian)';

  @override
  String get invited1 => '[FA] Invited (Persian)';

  @override
  String get noBranchesAvailable => '[FA] No branches available (Persian)';

  @override
  String get errorError => '[FA] Error: \$error (Persian)';

  @override
  String get noEvents => '[FA] No events (Persian)';

  @override
  String get gameCreatedSuccessfully =>
      '[FA] Game created successfully! (Persian)';

  @override
  String get add1 => '[FA] Add (Persian)';

  @override
  String get creatorCreatorid => '[FA] Creator: \$creatorId';

  @override
  String eventstarttimeEventendtime(Object endTime, Object startTime) {
    return '[FA] $startTime - $endTime (Persian)';
  }

  @override
  String get allowPlaytime => '[FA] Allow Playtime (Persian)';

  @override
  String get clients => '[FA] Clients (Persian)';

  @override
  String get noAmbassadorDataAvailable =>
      '[FA] No ambassador data available (Persian)';

  @override
  String get backgroundDeletedSuccessfully =>
      '[FA] Background deleted successfully! (Persian)';

  @override
  String errorSnapshoterror(Object error) {
    return '[FA] Error: $error (Persian)';
  }

  @override
  String get noAnalyticsDataAvailableYet =>
      '[FA] No analytics data available yet. (Persian)';

  @override
  String errorDeletingSlotE(Object e) {
    return 'خطأ في حذف الفترة: $e';
  }

  @override
  String get businessPhoneBookingEntryScreenComingSoon =>
      '[FA] Business Phone Booking Entry Screen - Coming Soon (Persian)';

  @override
  String get verification => '[FA] Verification (Persian)';

  @override
  String get copyLink => '[FA] Copy Link (Persian)';

  @override
  String get dashboard1 => '[FA] Dashboard (Persian)';

  @override
  String get manageChildAccounts => '[FA] Manage Child Accounts (Persian)';

  @override
  String get grantConsent => '[FA] اعطای رضایت';

  @override
  String get myProfile1 => '[FA] My Profile (Persian)';

  @override
  String get submit => '[FA] Submit (Persian)';

  @override
  String userLoguseremail(Object userEmail) {
    return '[FA] User: $userEmail';
  }

  @override
  String get emailNotifications => 'إشعارات البريد الإلكتروني';

  @override
  String get ambassadorDashboard => '[FA] Ambassador Dashboard (Persian)';

  @override
  String get phoneBooking => '[FA] Phone Booking (Persian)';

  @override
  String get bookViaChat => '[FA] رزرو با چت';

  @override
  String get error => 'خطا';

  @override
  String get businessProfile => '[FA] Business Profile (Persian)';

  @override
  String get businessBookingEntryScreenComingSoon =>
      '[FA] Business Booking Entry Screen - Coming Soon (Persian)';

  @override
  String get createNewSurvey => '[FA] Create New Survey (Persian)';

  @override
  String get backgroundRejected => '[FA] Background rejected (Persian)';

  @override
  String get noMediaSelected => '[FA] No media selected (Persian)';

  @override
  String get syncToGoogle => '[FA] Sync to Google (Persian)';

  @override
  String get virtualPlaytime => '[FA] Virtual Playtime (Persian)';

  @override
  String get colorContrastTesting => '[FA] Color Contrast Testing';

  @override
  String get loginFailedE => '[FA] Login failed: \$e';

  @override
  String get invitationSentSuccessfully => '[FA] دعوت‌نامه با موفقیت ارسال شد!';

  @override
  String get registering => '[FA] Registering... (Persian)';

  @override
  String statusAppointmentstatusname(Object status) {
    return '[FA] Status: $status (Persian)';
  }

  @override
  String get home1 => '[FA] Home (Persian)';

  @override
  String get errorSavingSettingsE =>
      '[FA] Error saving settings: \$e (Persian)';

  @override
  String get appVersionAndInformation =>
      '[FA] App version and information (Persian)';

  @override
  String get businessSubscriptionEntryScreenComingSoon =>
      '[FA] Business Subscription Entry Screen - Coming Soon (Persian)';

  @override
  String ekeyEvalue(Object key, Object value) {
    return '[FA] $key: $value (Persian)';
  }

  @override
  String get yourPaymentHasBeenProcessedSuccessfully =>
      '[FA] Your payment has been processed successfully. (Persian)';

  @override
  String get errorE => '[FA] Error: \$e (Persian)';

  @override
  String get viewAll1 => '[FA] View All (Persian)';

  @override
  String get editSurveyComingSoon =>
      '[FA] Edit survey - Coming soon! (Persian)';

  @override
  String get enterOtp => '[FA] کد OTP را وارد کنید';

  @override
  String get payment => '[FA] Payment (Persian)';

  @override
  String get automaticallyConfirmNewBookingRequests =>
      '[FA] Automatically confirm new booking requests (Persian)';

  @override
  String errorPickingVideoE(Object e) {
    return 'خطأ في اختيار الفيديو: $e';
  }

  @override
  String noRouteDefinedForSettingsname(Object settingsName) {
    return '[FA] No route defined for $settingsName (Persian)';
  }

  @override
  String get pleaseSignInToUploadABackground =>
      '[FA] Please sign in to upload a background (Persian)';

  @override
  String logtargettypeLogtargetid(Object targetId, Object targetType) {
    return '[FA] $targetType: $targetId';
  }

  @override
  String get staffAvailability => '[FA] Staff Availability (Persian)';

  @override
  String get livePlaytime => '[FA] Live Playtime (Persian)';

  @override
  String get autoconfirmBookings => '[FA] Auto-Confirm Bookings (Persian)';

  @override
  String get redirectingToStripeCheckoutForProPlan =>
      '[FA] Redirecting to Stripe checkout for Pro plan... (Persian)';

  @override
  String get exportAsCsv => '[FA] Export as CSV (Persian)';

  @override
  String get deleteFunctionalityComingSoon =>
      '[FA] Delete functionality coming soon! (Persian)';

  @override
  String get editClient => '[FA] Edit Client (Persian)';

  @override
  String get areYouSureYouWantToDeleteThisMessage =>
      '[FA] Are you sure you want to delete this message? (Persian)';

  @override
  String referralsAmbassadorreferrals(Object referrals) {
    return '[FA] Referrals: $referrals (Persian)';
  }

  @override
  String get notAuthenticated => '[FA] Not authenticated';

  @override
  String get privacyRequestSentToYourParents =>
      '[FA] Privacy request sent to your parents! (Persian)';

  @override
  String get clientDeletedSuccessfully =>
      '[FA] Client deleted successfully! (Persian)';

  @override
  String get failedToCancelSubscription =>
      '[FA] Failed to cancel subscription (Persian)';

  @override
  String get allLanguages => '[FA] All Languages (Persian)';

  @override
  String get slotDeletedSuccessfully =>
      '[FA] Slot deleted successfully (Persian)';

  @override
  String get businessProvidersEntryScreenComingSoon =>
      '[FA] Business Providers Entry Screen - Coming Soon';

  @override
  String get parentsMustApproveBeforeChildrenCanJoin =>
      '[FA] Parents must approve before children can join (Persian)';

  @override
  String get subscribeToPro1499mo =>
      '[FA] Subscribe to Pro (€14.99/mo) (Persian)';

  @override
  String get businessAvailabilityEntryScreenComingSoon =>
      '[FA] Business Availability Entry Screen - Coming Soon (Persian)';

  @override
  String appointmentsListlength(Object count) {
    return '[FA] Appointments: $count (Persian)';
  }

  @override
  String get clearFilters => '[FA] Clear Filters (Persian)';

  @override
  String get submitBooking => '[FA] ارسال رزرو';

  @override
  String get areYouSureYouWantToCancelThisAppointment =>
      '[FA] Are you sure you want to cancel this appointment? (Persian)';

  @override
  String get noUpcomingBookings => '[FA] No upcoming bookings (Persian)';

  @override
  String get goBack => '[FA] Go Back (Persian)';

  @override
  String get setup => '[FA] Setup (Persian)';

  @override
  String get inviteChild => '[FA] دعوت کودک';

  @override
  String get goToDashboard => '[FA] Go to Dashboard (Persian)';

  @override
  String get ambassadorQuotaDashboard =>
      '[FA] Ambassador Quota Dashboard (Persian)';

  @override
  String get adminSettings => '[FA] Admin Settings';

  @override
  String get referralCode => '[FA] Referral Code (Persian)';

  @override
  String adminLogadminemail(Object adminEmail) {
    return '[FA] Admin: $adminEmail';
  }

  @override
  String get date => '[FA] Date (Persian)';

  @override
  String get readOnly => '[FA] فقط خواندنی';

  @override
  String get bookingRequest => '[FA] درخواست رزرو';

  @override
  String get advancedReporting => '[FA] • Advanced reporting (Persian)';

  @override
  String get rooms => '[FA] Rooms (Persian)';

  @override
  String get copiedToClipboard => '[FA] Copied to clipboard (Persian)';

  @override
  String get bookingConfirmed => '[FA] رزرو تأیید شد';

  @override
  String get sessionApproved => 'تمت الموافقة على الجلسة';

  @override
  String get clientAddedSuccessfully =>
      '[FA] Client added successfully! (Persian)';

  @override
  String get noNotifications => 'لا توجد إشعارات';

  @override
  String get backgroundApproved => '[FA] Background approved! (Persian)';

  @override
  String get familySupport => '[FA] Family Support (Persian)';

  @override
  String get deletingAccount => '[FA] Deleting account... (Persian)';

  @override
  String get bookAppointment => '[FA] رزرو نوبت';

  @override
  String get receivePushNotificationsForNewBookings =>
      'استقبال إشعارات الدفع للحجوزات الجديدة';

  @override
  String get delete1 => '[FA] Delete (Persian)';

  @override
  String get sendBookingInvite => '[FA] Send Booking Invite (Persian)';

  @override
  String get text => '[FA] Text (Persian)';

  @override
  String get manageSubscription => '[FA] Manage Subscription (Persian)';

  @override
  String get requiresInstallFallback => '[FA] نیاز به نصب دارد';

  @override
  String get paymentConfirmation => '[FA] Payment Confirmation (Persian)';

  @override
  String get promoAppliedYourNextBillIsFree =>
      '[FA] Promo applied! Your next bill is free. (Persian)';

  @override
  String inviteeArgsinviteeid(Object inviteeId) {
    return 'المدعو: $inviteeId';
  }

  @override
  String get errorLoadingSlots => '[FA] Error loading slots (Persian)';

  @override
  String get allowOtherUsersToFindAndJoinThisGame =>
      '[FA] Allow other users to find and join this game (Persian)';

  @override
  String get businessOnboardingScreenComingSoon =>
      '[FA] Business Onboarding Screen - Coming Soon (Persian)';

  @override
  String get activateBusinessProfile =>
      '[FA] Activate Business Profile (Persian)';

  @override
  String get contentNotFound => '[FA] Content not found (Persian)';

  @override
  String pspecialtynpcontactinfo(Object contactInfo, Object specialty) {
    return '[FA] $specialty\\n$contactInfo (Persian)';
  }

  @override
  String get rating => '[FA] Rating (Persian)';

  @override
  String get messages => '[FA] Messages (Persian)';

  @override
  String errorEstimatingRecipientsE(Object e) {
    return 'خطأ في تقدير المستلمين: $e';
  }

  @override
  String get becomeAnAmbassador => '[FA] Become an Ambassador (Persian)';

  @override
  String get subscribeNow => '[FA] Subscribe Now (Persian)';

  @override
  String timeArgsslotformatcontext(Object time) {
    return '[FA] Time: $time (Persian)';
  }

  @override
  String get shareViaWhatsapp => '[FA] Share via WhatsApp (Persian)';

  @override
  String get users1 => '[FA] Users (Persian)';

  @override
  String get shareLink => '[FA] Share Link (Persian)';

  @override
  String get areYouSureYouWantToDeleteThisProvider =>
      '[FA] Are you sure you want to delete this provider?';

  @override
  String get deleteAppointment => '[FA] Delete Appointment (Persian)';

  @override
  String get toggleAvailability => '[FA] Toggle Availability (Persian)';

  @override
  String get changePlan => '[FA] Change Plan (Persian)';

  @override
  String get errorLoadingStaff => '[FA] Error loading staff (Persian)';

  @override
  String errorLoadingConfigurationE(Object e) {
    return 'خطأ في تحميل التكوين: $e';
  }

  @override
  String get updateYourBusinessInformation =>
      '[FA] Update your business information (Persian)';

  @override
  String get noProvidersFoundAddYourFirstProvider =>
      '[FA] No providers found. Add your first provider!';

  @override
  String get parentDashboard => '[FA] Parent Dashboard (Persian)';

  @override
  String get menu => 'منو';

  @override
  String get studioBooking => '[FA] Studio Booking (Persian)';

  @override
  String get about1 => '[FA] About (Persian)';

  @override
  String get multipleChoice => '[FA] Multiple Choice (Persian)';

  @override
  String dateAppointmentscheduledattostring(Object date) {
    return '[FA] Date: $date (Persian)';
  }

  @override
  String get studioBookingIsOnlyAvailableOnWeb =>
      '[FA] Studio booking is only available on web (Persian)';

  @override
  String get errorLoadingBranchesE =>
      '[FA] Error loading branches: \$e (Persian)';

  @override
  String ud83dudcc5Bookingdatetimetolocal(Object dateTime) {
    return '[FA] \\uD83D\\uDCC5 $dateTime (Persian)';
  }

  @override
  String appointmentInviteappointmentid(Object appointmentId) {
    return 'دعوة الموعد: $appointmentId';
  }

  @override
  String get none => 'هیچ‌کدام';

  @override
  String get failedToUpdateConsentE =>
      '[FA] Failed to update consent: \$e (Persian)';

  @override
  String get welcome1 => '[FA] Welcome (Persian)';

  @override
  String get failedToCreateSessionE =>
      '[FA] Failed to create session: \$e (Persian)';

  @override
  String get inviteContact => '[FA] تماس دعوت';

  @override
  String get surveyEditor => '[FA] Survey Editor (Persian)';

  @override
  String get failedToStartBasicSubscriptionE =>
      '[FA] Failed to start Basic subscription: \$e (Persian)';

  @override
  String get mySchedule => '[FA] My Schedule (Persian)';

  @override
  String get studioDashboard => '[FA] Studio Dashboard (Persian)';

  @override
  String get editProfile => 'تحرير الملف الشخصي';

  @override
  String get logout1 => '[FA] Logout';

  @override
  String serviceServiceidNotSelected(Object service) {
    return '[FA] Service: $service';
  }

  @override
  String get settingsSavedSuccessfully =>
      '[FA] Settings saved successfully! (Persian)';

  @override
  String get linkCopiedToClipboard =>
      '[FA] Link copied to clipboard! (Persian)';

  @override
  String get accept1 => '[FA] Accept (Persian)';

  @override
  String get noAvailableSlots => '[FA] No available slots (Persian)';

  @override
  String get makeGamePublic => '[FA] Make Game Public (Persian)';

  @override
  String permissionPermissioncategoryUpdatedToNewvalue(Object category) {
    return '[FA] Permission $category updated to \$newValue (Persian)';
  }

  @override
  String get roomDeletedSuccessfully =>
      '[FA] Room deleted successfully! (Persian)';

  @override
  String get businessCalendar => '[FA] Business Calendar (Persian)';

  @override
  String get addAvailability => '[FA] Add Availability (Persian)';

  @override
  String get ambassadorOnboarding => '[FA] Ambassador Onboarding (Persian)';

  @override
  String phoneProfileasyncphone(Object phone) {
    return '[FA] Phone: $phone (Persian)';
  }

  @override
  String get addNewRoom => '[FA] Add New Room (Persian)';

  @override
  String get requireParentApproval => '[FA] Require Parent Approval (Persian)';

  @override
  String get closed => '[FA] Closed (Persian)';

  @override
  String get exportAsPdf => '[FA] Export as PDF (Persian)';

  @override
  String get enableVibration => '[FA] Enable Vibration (Persian)';

  @override
  String toAvailendformatcontext(Object endTime) {
    return '[FA] To: $endTime (Persian)';
  }

  @override
  String yourUpgradeCodeUpgradecode(Object upgradeCode) {
    return '[FA] Your upgrade code: \$upgradeCode (Persian)';
  }

  @override
  String get requestPrivateSession => '[FA] درخواست جلسه خصوصی';

  @override
  String get country => '[FA] Country (Persian)';

  @override
  String get loginScreen => '[FA] Login Screen';

  @override
  String staffArgsstaffdisplayname(Object staffName) {
    return '[FA] Staff: $staffName (Persian)';
  }

  @override
  String get revokeConsent => '[FA] لغو رضایت';

  @override
  String get settings1 => '[FA] Settings (Persian)';

  @override
  String get cancel1 => '[FA] Cancel (Persian)';

  @override
  String get subscriptionActivatedSuccessfully =>
      '[FA] Subscription activated successfully! (Persian)';

  @override
  String activityLogaction(Object action) {
    return '[FA] Activity: $action';
  }

  @override
  String get broadcast => '[FA] Broadcast (Persian)';

  @override
  String get noEventsScheduledThisWeek =>
      '[FA] No events scheduled this week (Persian)';

  @override
  String get googleCalendar => '[FA] Google Calendar (Persian)';

  @override
  String get sendInvite => 'إرسال دعوة';

  @override
  String get childDashboard => '[FA] Child Dashboard (Persian)';

  @override
  String get failedToUploadBackgroundE =>
      '[FA] Failed to upload background: \$e (Persian)';

  @override
  String linkchildidsubstring08(Object linkId) {
    return '[FA] $linkId...';
  }

  @override
  String targetLogtargettypeLogtargetid(Object targetId, Object targetType) {
    return '[FA] Target: $targetType - $targetId';
  }

  @override
  String get contextContextid => '[FA] Context: \$contextId';

  @override
  String get noAppointments => '[FA] No appointments (Persian)';

  @override
  String get unlimitedBookingsPerWeek =>
      '[FA] • Unlimited bookings per week (Persian)';

  @override
  String errorDetailsLogerrortype(Object errorType, Object logErrorType) {
    return 'تفاصيل الخطأ: $logErrorType';
  }

  @override
  String get scheduledAtScheduledat =>
      '[FA] Scheduled at: \$scheduledAt (Persian)';

  @override
  String get selectStaff => '[FA] انتخاب کارمند';

  @override
  String get subscriptionCancelledSuccessfully =>
      '[FA] Subscription cancelled successfully (Persian)';

  @override
  String get pleaseLogInToViewYourProfile =>
      'يرجى تسجيل الدخول لعرض ملفك الشخصي';

  @override
  String get cancelAppointment => '[FA] Cancel Appointment (Persian)';

  @override
  String permissionsFamilylinkchildid(Object childId) {
    return '[FA] Permissions - $childId';
  }

  @override
  String get businessSignup => '[FA] Business Signup (Persian)';

  @override
  String get businessCompletionScreenComingSoon =>
      '[FA] Business Completion Screen - Coming Soon (Persian)';

  @override
  String get createGame1 => '[FA] Create Game (Persian)';

  @override
  String valuetoint(Object value) {
    return '[FA] $value (Persian)';
  }

  @override
  String get pleaseEnterAPromoCode =>
      '[FA] Please enter a promo code (Persian)';

  @override
  String get errorLoadingAvailabilityE =>
      '[FA] Error loading availability: \$e (Persian)';

  @override
  String get parentalControls => '[FA] Parental Controls (Persian)';

  @override
  String get editBusinessProfile => 'تحرير الملف التجاري';

  @override
  String get childLinkedSuccessfully => '[FA] کودک با موفقیت متصل شد!';

  @override
  String get create => '[FA] Create (Persian)';

  @override
  String get noExternalMeetingsFound =>
      '[FA] No external meetings found. (Persian)';

  @override
  String staffSelectionstaffdisplayname(Object staffName) {
    return '[FA] Staff: $staffName (Persian)';
  }

  @override
  String get pleaseEnterAValidEmailAddress =>
      '[FA] Please enter a valid email address';

  @override
  String get schedulerScreen => '[FA] Scheduler Screen (Persian)';

  @override
  String get clientUpdatedSuccessfully =>
      '[FA] Client updated successfully! (Persian)';

  @override
  String get surveyResponses => '[FA] Survey Responses (Persian)';

  @override
  String get syncToOutlook => '[FA] Sync to Outlook (Persian)';

  @override
  String get saveChanges => '[FA] Save Changes (Persian)';

  @override
  String get pickTime => '[FA] Pick Time (Persian)';

  @override
  String registrationFailedEtostring(Object error) {
    return '[FA] Registration failed: $error (Persian)';
  }

  @override
  String get analytics => '[FA] Analytics (Persian)';

  @override
  String get errorLoadingEvents => '[FA] Error loading events (Persian)';

  @override
  String get errorLoadingOrganizations => '[FA] خطا در بارگذاری سازمان‌ها';

  @override
  String get businessLoginScreenComingSoon =>
      '[FA] Business Login Screen - Coming Soon';

  @override
  String get success1 => '[FA] Success (Persian)';

  @override
  String appVersionLogappversion(Object appVersion) {
    return '[FA] App Version: $appVersion';
  }

  @override
  String fromAvailstartformatcontext(Object startTime) {
    return '[FA] From: $startTime (Persian)';
  }

  @override
  String get readWrite => '[FA] خواندن و نوشتن';

  @override
  String get redirectingToStripeCheckoutForBasicPlan =>
      '[FA] Redirecting to Stripe checkout for Basic plan... (Persian)';

  @override
  String get errorSavingConfigurationE =>
      '[FA] Error saving configuration: \$e';

  @override
  String get pickDate => '[FA] انتخاب تاریخ';

  @override
  String get chatBooking => '[FA] رزرو از طریق چت';

  @override
  String get noQuestionsAdded => '[FA] No questions added (Persian)';

  @override
  String severityLogseverityname(Object severity) {
    return '[FA] Severity: $severity';
  }

  @override
  String get markAsPaid => '[FA] Mark as Paid';

  @override
  String get typeOpenCall => '[FA] Type: Open Call (Persian)';

  @override
  String appointmentAppointmentid(Object appointmentId) {
    return '[FA] Appointment $appointmentId';
  }

  @override
  String statusInvitestatusname(Object inviteStatusName, Object status) {
    return 'الحالة: $inviteStatusName';
  }

  @override
  String get businessLogin => '[FA] Business Login';

  @override
  String get invoiceCreatedSuccessfully =>
      '[FA] Invoice created successfully! (Persian)';

  @override
  String get noTimeSeriesDataAvailable =>
      '[FA] No time series data available (Persian)';

  @override
  String subscribeToWidgetplanname(Object planName) {
    return '[FA] Subscribe to $planName';
  }

  @override
  String timestamp_formatdatelogtimestamp(Object timestamp) {
    return '[FA] Timestamp: $timestamp';
  }

  @override
  String get failedToSendPrivacyRequestE =>
      '[FA] Failed to send privacy request: \$e (Persian)';

  @override
  String get chooseYourPlan => '[FA] Choose Your Plan (Persian)';

  @override
  String get playtimeManagement => '[FA] Playtime Management (Persian)';

  @override
  String get availability => '[FA] Availability (Persian)';

  @override
  String get eventCreated => '[FA] Event created (Persian)';

  @override
  String get subscribeToBasic499mo =>
      '[FA] Subscribe to Basic (€4.99/mo) (Persian)';

  @override
  String get completion => '[FA] Completion (Persian)';

  @override
  String get supportTicketSubmitted =>
      '[FA] Support ticket submitted (Persian)';

  @override
  String get monetizationSettings => '[FA] Monetization Settings (Persian)';

  @override
  String get noBookingsFound => '[FA] هیچ رزروی یافت نشد';

  @override
  String get admin => '[FA] Admin';

  @override
  String get deleteSurvey => '[FA] Delete Survey (Persian)';

  @override
  String get gameApprovedSuccessfully =>
      '[FA] Game approved successfully! (Persian)';

  @override
  String get errorLoadingPermissionsError =>
      '[FA] Error loading permissions: \$error (Persian)';

  @override
  String get referrals => '[FA] Referrals (Persian)';

  @override
  String get crm => '[FA] CRM (Persian)';

  @override
  String get gameRejected => '[FA] Game rejected (Persian)';

  @override
  String get appointments => '[FA] Appointments (Persian)';

  @override
  String get onboardingScreen => '[FA] Onboarding Screen (Persian)';

  @override
  String get welcomeToYourStudio => '[FA] Welcome to your studio (Persian)';

  @override
  String get update => '[FA] Update (Persian)';

  @override
  String get retry1 => '[FA] Retry (Persian)';

  @override
  String get booking => '[FA] Booking (Persian)';

  @override
  String get parentalSettings => '[FA] Parental Settings (Persian)';

  @override
  String get language => '[FA] Language (Persian)';

  @override
  String get deleteSlot => '[FA] Delete Slot (Persian)';

  @override
  String get organizations => 'سازمان‌ها';

  @override
  String get configurationSavedSuccessfully =>
      '[FA] Configuration saved successfully!';

  @override
  String get createNewGame => '[FA] Create New Game (Persian)';

  @override
  String get next1 => '[FA] Next (Persian)';

  @override
  String get backgroundUploadedSuccessfully =>
      '[FA] Background uploaded successfully! (Persian)';

  @override
  String get noAppointmentRequestsFound =>
      '[FA] No appointment requests found. (Persian)';

  @override
  String get pleaseSignInToCreateASession => 'يرجى تسجيل الدخول لإنشاء جلسة';

  @override
  String get restrictMatureContent => '[FA] Restrict mature content (Persian)';

  @override
  String get ambassadors => '[FA] Ambassadors (Persian)';

  @override
  String get smsNotifications => 'إشعارات الرسائل النصية';

  @override
  String get paymentWasCancelled => '[FA] Payment was cancelled (Persian)';

  @override
  String get clearAll => '[FA] Clear All (Persian)';

  @override
  String get viewDetails => '[FA] View Details (Persian)';

  @override
  String get notifications1 => 'الإشعارات';

  @override
  String get liveSessionScheduledWaitingForParentApproval =>
      'تم جدولة جلسة مباشرة، في انتظار موافقة الوالد';

  @override
  String get failedToCreateGameE => '[FA] Failed to create game: \$e (Persian)';

  @override
  String get noChartDataAvailable => '[FA] No chart data available (Persian)';

  @override
  String get phonebasedBookingSystem =>
      '[FA] • Phone-based booking system (Persian)';

  @override
  String get enableNotifications1 => 'تفعيل الإشعارات';

  @override
  String get invoices => '[FA] Invoices (Persian)';

  @override
  String get pleaseActivateYourBusinessProfileToContinue =>
      'يرجى تفعيل ملفك التجاري للمتابعة';

  @override
  String scheduledAtArgsscheduledat(Object scheduledAt) {
    return '[FA] Scheduled at: $scheduledAt (Persian)';
  }

  @override
  String durationDurationinminutes0Minutes(Object duration) {
    return '[FA] Duration: $duration minutes (Persian)';
  }

  @override
  String get tryAgain => '[FA] Try Again (Persian)';

  @override
  String get deleteBackground => '[FA] Delete Background (Persian)';

  @override
  String currentTierTiertouppercase(Object tier) {
    return '[FA] Current Tier: $tier (Persian)';
  }

  @override
  String get iDoNotConsent => '[FA] I Do Not Consent';

  @override
  String get noClientsFoundAddYourFirstClient =>
      '[FA] No clients found. Add your first client! (Persian)';

  @override
  String get settingsDialogWillBeImplementedHere =>
      '[FA] Settings dialog will be implemented here.';

  @override
  String get groupGroupid => '[FA] Group: \$groupId';

  @override
  String get appointmentRequests => '[FA] Appointment Requests (Persian)';

  @override
  String get forward => '[FA] Forward (Persian)';

  @override
  String get roomAddedSuccessfully => '[FA] Room added successfully! (Persian)';

  @override
  String get option => '[FA] • \$option (Persian)';

  @override
  String responseIndex1(Object number) {
    return '[FA] Response #$number (Persian)';
  }

  @override
  String get crmDashboardWithAnalytics =>
      '[FA] • CRM dashboard with analytics (Persian)';

  @override
  String get contentLibrary1 => '[FA] Content Library (Persian)';

  @override
  String get reply => '[FA] Reply (Persian)';

  @override
  String get subscriptionManagement => '[FA] Subscription Management (Persian)';

  @override
  String get monetizationSettingsWillBeImplementedHere =>
      '[FA] Monetization settings will be implemented here (Persian)';

  @override
  String get failedToApplyPromoCodeE =>
      '[FA] Failed to apply promo code: \$e (Persian)';

  @override
  String get editProvider => '[FA] Edit Provider';

  @override
  String get localizationContribution =>
      '[FA] Localization Contribution (Persian)';

  @override
  String get parentalConsent => '[FA] Parental Consent (Persian)';

  @override
  String get businessSignupScreenComingSoon =>
      '[FA] Business Signup Screen - Coming Soon (Persian)';

  @override
  String get areYouSureYouWantToDeleteThisAppointment =>
      '[FA] Are you sure you want to delete this appointment? (Persian)';

  @override
  String get syncAppointment => '[FA] Sync Appointment (Persian)';

  @override
  String get iConsent => '[FA] I Consent (Persian)';

  @override
  String get sessionRejected => 'تم رفض الجلسة';

  @override
  String get businessSetupScreenComingSoon =>
      '[FA] Business Setup Screen - Coming Soon (Persian)';

  @override
  String get edit1 => '[FA] Edit (Persian)';

  @override
  String get noEventsScheduledThisMonth =>
      '[FA] No events scheduled this month (Persian)';

  @override
  String get businessDashboard => '[FA] داشبورد کسب‌وکار';

  @override
  String get noMessagesFound => '[FA] No messages found. (Persian)';

  @override
  String staffStaffidNotSelected(Object staff) {
    return '[FA] Staff: $staff';
  }

  @override
  String get manageStaffAvailability =>
      '[FA] Manage Staff Availability (Persian)';

  @override
  String get noMissingTranslations => '[FA] No missing translations (Persian)';

  @override
  String get skip => '[FA] Skip (Persian)';

  @override
  String meetingIdMeetingid(Object meetingId) {
    return 'معرف الاجتماع: $meetingId';
  }

  @override
  String get noUsers => '[FA] کاربری وجود ندارد';

  @override
  String get errorLoadingReferralCode =>
      '[FA] Error loading referral code (Persian)';

  @override
  String get allCountries => '[FA] All Countries (Persian)';

  @override
  String get deleteGame => '[FA] Delete Game (Persian)';

  @override
  String get staffManagementTools => '[FA] • Staff management tools (Persian)';

  @override
  String get deleteMessage => '[FA] Delete Message (Persian)';

  @override
  String get receiveBookingNotificationsViaSms =>
      'استقبال إشعارات الحجز عبر الرسائل النصية';

  @override
  String get changeRole => '[FA] تغییر نقش';

  @override
  String errorLoadingBookingsSnapshoterror(Object error) {
    return 'خطأ في تحميل لقطة الحجوزات: $error';
  }

  @override
  String get openingCustomerPortal =>
      '[FA] Opening customer portal... (Persian)';

  @override
  String get signOut => 'خروج';

  @override
  String nameProfilename(Object name) {
    return '[FA] Name: $name (Persian)';
  }

  @override
  String get businessProfileEntryScreenComingSoon =>
      'شاشة إدخال الملف التجاري - قريباً';

  @override
  String get upgradeToBusiness => '[FA] Upgrade to Business (Persian)';

  @override
  String get apply => 'تطبيق';

  @override
  String errorLoadingSubscriptionError(Object error) {
    return 'خطأ في تحميل الاشتراك: $error';
  }

  @override
  String get errorLoadingUsers => 'خطأ في تحميل المستخدمين';

  @override
  String get verify => 'التحقق';

  @override
  String get subscription => 'الاشتراك';

  @override
  String get deleteMyAccount => 'حذف حسابي';

  @override
  String get businessAppointmentsEntryScreenComingSoon =>
      'شاشة إدخال مواعيد الأعمال - قريباً';

  @override
  String get viewResponses => '[FA] View Responses (Persian)';

  @override
  String get businessWelcomeScreenComingSoon => 'شاشة ترحيب الأعمال - قريباً';

  @override
  String failedToOpenCustomerPortalE(Object e) {
    return 'فشل في فتح بوابة العميل: $e';
  }

  @override
  String get continueText => 'متابعة';

  @override
  String get close1 => 'إغلاق';

  @override
  String get confirm1 => 'تأكيد';

  @override
  String get externalMeetings => 'الاجتماعات الخارجية';

  @override
  String get approve => 'موافقة';

  @override
  String get noInvoicesFoundCreateYourFirstInvoice =>
      'لم يتم العثور على فواتير. أنشئ فاتورتك الأولى!';

  @override
  String get subscribe => 'اشتراك';

  @override
  String get login1 => 'تسجيل الدخول';

  @override
  String get adminOverviewGoesHere => 'نظرة عامة على المسؤول هنا';

  @override
  String get loadingCheckout => 'جار تحميل الدفع...';

  @override
  String get ad_pre_title => 'Watch an ad to confirm your appointment';

  @override
  String get ad_pre_description =>
      'As a free user, you must watch a short ad before confirming. You can remove all ads permanently by upgrading.';

  @override
  String get watch_ad_button => 'Watch Ad';

  @override
  String get upgrade_button => 'Upgrade to Premium (€4)';

  @override
  String get ad_post_title =>
      'Ad finished! You may now confirm your appointment.';

  @override
  String get confirm_appointment_button => 'Confirm Appointment';

  @override
  String get upgrade_prompt_title => 'One-time upgrade';

  @override
  String get upgrade_prompt_description => 'Pay €4 to remove all ads forever';

  @override
  String get purchase_now_button => 'Purchase Now';

  @override
  String get welcomeAmbassador => 'Welcome Ambassador';

  @override
  String get activeStatus => 'Active Status';

  @override
  String get totalReferrals => 'Total Referrals';

  @override
  String get thisMonth => 'This Month';

  @override
  String get activeRewards => 'Active Rewards';

  @override
  String get nextTierProgress => 'Next Tier Progress';

  @override
  String get progressToPremium => 'Progress to Premium';

  @override
  String get remaining => 'Remaining';

  @override
  String get monthlyGoal => 'Monthly Goal';

  @override
  String get onTrack => 'On Track';

  @override
  String get needsAttention => 'Needs Attention';

  @override
  String get monthlyReferralRequirement => 'Monthly Referral Requirement';

  @override
  String get viewRewards => 'View Rewards';

  @override
  String get referralStatistics => 'Referral Statistics';

  @override
  String get activeReferrals => 'Active Referrals';

  @override
  String get conversionRate => 'Conversion Rate';

  @override
  String get recentReferrals => 'Recent Referrals';

  @override
  String get tierBenefits => 'Tier Benefits';

  @override
  String get yourReferralQRCode => 'Your Referral QR Code';

  @override
  String get yourReferralLink => 'Your Referral Link';

  @override
  String get shareYourLink => 'Share Your Link';

  @override
  String get shareViaMessage => 'Share via Message';

  @override
  String get shareViaEmail => 'Share via Email';

  @override
  String get shareMore => 'Share More';

  @override
  String get becomeAmbassador => 'Become Ambassador';

  @override
  String get ambassadorEligible => 'Ambassador Eligible';

  @override
  String get ambassadorWelcomeTitle => 'Ambassador Welcome Title';

  @override
  String get ambassadorWelcomeMessage => 'Ambassador Welcome Message';

  @override
  String get ambassadorPromotionTitle =>
      '[FA] Congratulations! You\'re now an Ambassador! (Persian)';

  @override
  String ambassadorPromotionBody(String tier) {
    return '[FA] Welcome to the $tier tier! Start sharing your referral link to earn rewards. (Persian)';
  }

  @override
  String get tierUpgradeTitle => '[FA] Tier Upgrade! 🎉 (Persian)';

  @override
  String tierUpgradeBody(
    String previousTier,
    String newTier,
    String totalReferrals,
  ) {
    return '[FA] Amazing! You\'ve been upgraded from $previousTier to $newTier with $totalReferrals referrals! (Persian)';
  }

  @override
  String get monthlyReminderTitle => '[FA] Monthly Goal Reminder (Persian)';

  @override
  String monthlyReminderBody(
    String currentReferrals,
    String targetReferrals,
    String daysRemaining,
  ) {
    return '[FA] You have $currentReferrals/$targetReferrals referrals this month. $daysRemaining days left to reach your goal! (Persian)';
  }

  @override
  String get performanceWarningTitle =>
      '[FA] Ambassador Performance Alert (Persian)';

  @override
  String performanceWarningBody(
    String currentReferrals,
    String minimumRequired,
  ) {
    return '[FA] Your monthly referrals ($currentReferrals) are below the minimum requirement ($minimumRequired). Your ambassador status may be affected. (Persian)';
  }

  @override
  String get ambassadorDemotionTitle =>
      '[FA] Ambassador Status Update (Persian)';

  @override
  String ambassadorDemotionBody(String reason) {
    return '[FA] Your ambassador status has been temporarily suspended due to: $reason. You can regain your status by meeting the requirements again. (Persian)';
  }

  @override
  String get referralSuccessTitle => '[FA] New Referral! 🎉 (Persian)';

  @override
  String referralSuccessBody(String referredUserName, String totalReferrals) {
    return '[FA] $referredUserName joined through your referral! You now have $totalReferrals total referrals. (Persian)';
  }

  @override
  String get title => 'Title';

  @override
  String get pleaseEnterTitle => 'Please Enter Title';

  @override
  String get messageType => 'Message Type';

  @override
  String get pleaseEnterContent => 'Please Enter Content';

  @override
  String get imageSelected => 'Image Selected';

  @override
  String get videoSelected => 'Video Selected';

  @override
  String get externalLink => 'External Link';

  @override
  String get pleaseEnterLink => 'Please Enter Link';

  @override
  String get estimatedRecipients => 'Estimated Recipients';

  @override
  String get countries => 'Countries';

  @override
  String get cities => 'Cities';

  @override
  String get subscriptionTiers => 'Subscription Tiers';

  @override
  String get userRoles => 'User Roles';

  @override
  String get errorEstimatingRecipients => 'Error Estimating Recipients';

  @override
  String get errorPickingImage => 'Error Picking Image';

  @override
  String get errorPickingVideo => 'Error Picking Video';

  @override
  String get userNotAuthenticated => 'User Not Authenticated';

  @override
  String get failedToUploadImage => 'Failed to Upload Image';

  @override
  String get failedToUploadVideo => 'Failed to Upload Video';

  @override
  String get image => 'Image';

  @override
  String get video => 'Video';

  @override
  String get continue1 => 'Continue';

  @override
  String get getStarted => 'Get Started';
}
