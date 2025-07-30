// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get refresh => '更新';

  @override
  String get home => 'ホーム';

  @override
  String get noSessionsYet => 'まだセッションがありません';

  @override
  String get ok => '[JA] OK';

  @override
  String get playtimeLandingChooseMode => '[JA] プレイモードを選択してください:';

  @override
  String get signUp => 'サインアップ';

  @override
  String get scheduleMessage => 'メッセージをスケジュール';

  @override
  String get decline => '拒否';

  @override
  String get adminBroadcast => '[JA] Admin Broadcast';

  @override
  String get login => 'ログイン';

  @override
  String get playtimeChooseFriends => '友達を選択';

  @override
  String get noInvites => '招待なし';

  @override
  String get playtimeChooseTime => '時間を選択';

  @override
  String get success => '成功';

  @override
  String get undo => '元に戻す';

  @override
  String opened(Object count) {
    return '開きました';
  }

  @override
  String get createVirtualSession => 'バーチャルセッションを作成';

  @override
  String get messageSentSuccessfully => 'メッセージが正常に送信されました';

  @override
  String get redo => 'やり直す';

  @override
  String get next => '次へ';

  @override
  String get search => '検索';

  @override
  String get cancelInviteConfirmation => '招待の確認をキャンセル';

  @override
  String created(String created, Object date) {
    return '作成しました';
  }

  @override
  String get revokeAccess => 'アクセスを取り消す';

  @override
  String get playtimeLiveScheduled => 'ライブセッションがスケジュールされました';

  @override
  String get revokeAccessConfirmation => 'アクセス取り消しの確認';

  @override
  String get download => 'ダウンロード';

  @override
  String get password => 'パスワード';

  @override
  String errorLoadingFamilyLinks(Object error) {
    return '家族リンクの読み込みエラー';
  }

  @override
  String get cancel => 'キャンセル';

  @override
  String get playtimeCreate => '[JA] Playtimeを作成';

  @override
  String failedToActionPrivacyRequest(Object action, Object error) {
    return 'プライバシーリクエストの処理に失敗しました';
  }

  @override
  String get appTitle => 'アプリのタイトル';

  @override
  String get accept => '承認';

  @override
  String get playtimeModeVirtual => 'バーチャルモード';

  @override
  String get playtimeDescription => '[JA] Playtimeの説明';

  @override
  String get delete => '削除';

  @override
  String get playtimeVirtualStarted => 'バーチャルセッションが開始されました';

  @override
  String get createYourFirstGame => '最初のゲームを作成';

  @override
  String get participants => '参加者';

  @override
  String recipients(String recipients, Object count) {
    return '受信者';
  }

  @override
  String get noResults => '結果なし';

  @override
  String get yes => 'はい';

  @override
  String get invite => '招待';

  @override
  String get playtimeModeLive => 'ライブモード';

  @override
  String get done => '完了';

  @override
  String get defaultShareMessage => 'デフォルトの共有メッセージ';

  @override
  String get no => 'いいえ';

  @override
  String get playtimeHub => '[JA] Playtimeハブ';

  @override
  String get createLiveSession => 'ライブセッションを作成';

  @override
  String get enableNotifications => '通知を有効にする';

  @override
  String invited(Object date) {
    return '招待済み';
  }

  @override
  String content(String content) {
    return 'コンテンツ';
  }

  @override
  String get meetingSharedSuccessfully => 'ミーティングが正常に共有されました';

  @override
  String get welcomeToPlaytime => '[JA] Playtimeへようこそ';

  @override
  String get viewAll => 'すべて表示';

  @override
  String get playtimeVirtual => '[JA] バーチャルPlaytime';

  @override
  String get staffScreenTBD => 'スタッフ画面は後日設定';

  @override
  String get cut => 'カット';

  @override
  String get inviteCancelledSuccessfully => '招待が正常にキャンセルされました';

  @override
  String get retry => '再試行';

  @override
  String get composeBroadcastMessage => '放送メッセージを作成';

  @override
  String get sendNow => '今すぐ送信';

  @override
  String get noGamesYet => 'まだゲームはありません';

  @override
  String get select => '選択';

  @override
  String get about => '約';

  @override
  String get choose => '選択';

  @override
  String get profile => 'プロフィール';

  @override
  String get removeChild => '子供を削除';

  @override
  String status(String status) {
    return 'ステータス';
  }

  @override
  String get logout => 'ログアウト';

  @override
  String get paste => '貼り付け';

  @override
  String get welcome => 'ようこそ';

  @override
  String get playtimeCreateSession => 'セッションを作成';

  @override
  String get familyMembers => '家族メンバー';

  @override
  String get upload => 'アップロード';

  @override
  String get upcomingSessions => '今後のセッション';

  @override
  String get confirm => '確認';

  @override
  String get playtimeLive => '[JA] ライブPlaytime';

  @override
  String get errorLoadingInvites => '招待の読み込みエラー';

  @override
  String get targetingFilters => 'ターゲティングフィルター';

  @override
  String get pickVideo => 'ビデオを選択';

  @override
  String get playtimeGameDeleted => 'ゲームが削除されました';

  @override
  String get scheduleForLater => '後でスケジュール';

  @override
  String get accessRevokedSuccessfully => 'アクセスが正常に取り消されました';

  @override
  String type(String type) {
    return 'タイプ';
  }

  @override
  String get checkingPermissions => '権限を確認中';

  @override
  String get copy => 'コピー';

  @override
  String get yesCancel => 'はい、キャンセル';

  @override
  String get email => 'メール';

  @override
  String get shareOnWhatsApp => '[JA] [JA] Share on WhatsApp';

  @override
  String get notificationSettings => '通知設定';

  @override
  String get myProfile => 'マイプロフィール';

  @override
  String get revoke => '取り消す';

  @override
  String get noBroadcastMessages => '放送メッセージなし';

  @override
  String requestType(Object type) {
    return 'リクエストタイプ';
  }

  @override
  String get notifications => '通知';

  @override
  String get details => '詳細';

  @override
  String get cancelInvite => '招待をキャンセル';

  @override
  String get createNew => '新規作成';

  @override
  String get settings => '設定';

  @override
  String get playtimeReject => '[JA] Playtimeを拒否';

  @override
  String get errorLoadingProfile => 'プロフィール読み込みエラー';

  @override
  String get edit => '編集';

  @override
  String get add => '追加';

  @override
  String get playtimeGameApproved => 'ゲームが承認されました';

  @override
  String get forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get familyDashboard => 'ファミリーダッシュボード';

  @override
  String get loading => '読み込み中';

  @override
  String get quickActions => 'クイックアクション';

  @override
  String get playtimeTitle => '[JA] Playtimeタイトル';

  @override
  String get otpResentSuccessfully => '[JA] OTPが正常に再送信されました';

  @override
  String errorCheckingPermissions(Object error) {
    return '権限の確認エラー';
  }

  @override
  String get clientScreenTBD => 'クライアント画面は後日設定';

  @override
  String fcmToken(Object token) {
    return '[JA] FCMトークン';
  }

  @override
  String get pickImage => '画像を選択';

  @override
  String get previous => '前へ';

  @override
  String get noProfileFound => 'プロフィールが見つかりません';

  @override
  String get noFamilyMembersYet => 'まだ家族メンバーがいません';

  @override
  String get mediaOptional => 'メディア（オプション）';

  @override
  String get messageSavedSuccessfully => 'メッセージが正常に保存されました';

  @override
  String get scheduledFor => '次の日時にスケジュール済み';

  @override
  String get dashboard => 'ダッシュボード';

  @override
  String get noPermissionForBroadcast => '放送権限がありません';

  @override
  String get playtimeAdminPanelTitle => '[JA] Playtime Games – Admin';

  @override
  String get inviteDetail => '招待の詳細';

  @override
  String scheduled(String scheduled, Object date) {
    return 'スケジュール済み';
  }

  @override
  String failedToResendOtp(Object error) {
    return '[JA] OTPの再送信に失敗しました';
  }

  @override
  String get scheduling => 'スケジュール中';

  @override
  String errorSavingMessage(String error) {
    return 'メッセージ保存エラー';
  }

  @override
  String get save => '保存';

  @override
  String get playtimeApprove => '[JA] Playtimeを承認';

  @override
  String get createYourFirstSession => '最初のセッションを作成';

  @override
  String get playtimeGameRejected => 'ゲームが拒否されました';

  @override
  String failedToRevokeAccess(Object error) {
    return '[JA] [JA] Failed to revoke access';
  }

  @override
  String get recentGames => '最近のゲーム';

  @override
  String get customizeMessage => 'メッセージをカスタマイズ';

  @override
  String failedToCancelInvite(Object error) {
    return '招待キャンセルに失敗しました';
  }

  @override
  String errorSendingMessage(String error) {
    return 'メッセージ送信エラー';
  }

  @override
  String get confirmPassword => 'パスワードを確認';

  @override
  String errorLoadingPrivacyRequests(Object error) {
    return 'プライバシーリクエスト読み込みエラー';
  }

  @override
  String get connectedChildren => '接続された子供';

  @override
  String get share => '共有';

  @override
  String get playtimeEnterGameName => 'ゲーム名を入力';

  @override
  String get pleaseLoginForFamilyFeatures =>
      '[JA] [JA] Please login to access family features';

  @override
  String get myInvites => '[JA] [JA] My Invites';

  @override
  String get createGame => '[JA] [JA] Create Game';

  @override
  String get playtimeNoSessions => '[JA] [JA] No playtime sessions found.';

  @override
  String get adminScreenTBD => '[JA] Admin screen coming soon';

  @override
  String get playtimeParentDashboardTitle => '[JA] [JA] Playtime Dashboard';

  @override
  String get close => '[JA] [JA] Close';

  @override
  String get back => '[JA] [JA] Back';

  @override
  String get playtimeChooseGame => '[JA] [JA] Choose a game';

  @override
  String get managePermissions => '[JA] [JA] Manage Permissions';

  @override
  String get pollOptions => '[JA] [JA] Poll Options';

  @override
  String clicked(String clicked, Object count) {
    return '[JA] [JA] Clicked';
  }

  @override
  String link(String link) {
    return '[JA] [JA] Link';
  }

  @override
  String get meetingReadyMessage => '[JA] [JA] Your meeting is ready! Join now';

  @override
  String get pendingInvites => '[JA] [JA] Pending Invites';

  @override
  String statusColon(Object status) {
    return '[JA] [JA] Status:';
  }

  @override
  String get pleaseLoginToViewProfile => 'プロフィールを表示するにはログインしてください';

  @override
  String get adminMetrics => '[JA] Admin Metrics';

  @override
  String get overview => '[JA] Overview';

  @override
  String get bookings => '[JA] Bookings';

  @override
  String get users => '[JA] users (TRANSLATE)';

  @override
  String get revenue => '[JA] revenue (TRANSLATE)';

  @override
  String get contentLibrary => '[JA] Content Library';

  @override
  String get authErrorUserNotFound =>
      '[JA] No account found with this email address.';

  @override
  String get authErrorWrongPassword =>
      '[JA] Incorrect password. Please try again.';

  @override
  String get authErrorInvalidEmail =>
      '[JA] Please enter a valid email address.';

  @override
  String get authErrorUserDisabled =>
      '[JA] This account has been disabled. Please contact support.';

  @override
  String get authErrorWeakPassword =>
      '[JA] Password is too weak. Please choose a stronger password.';

  @override
  String get authErrorEmailAlreadyInUse =>
      '[JA] An account with this email already exists.';

  @override
  String get authErrorTooManyRequests =>
      '[JA] Too many failed attempts. Please try again later.';

  @override
  String get authErrorOperationNotAllowed =>
      '[JA] This sign-in method is not enabled. Please contact support.';

  @override
  String get authErrorInvalidCredential =>
      '[JA] Invalid credentials. Please try again.';

  @override
  String get authErrorAccountExistsWithDifferentCredential =>
      '[JA] An account already exists with this email using a different sign-in method.';

  @override
  String get authErrorCredentialAlreadyInUse =>
      '[JA] These credentials are already associated with another account.';

  @override
  String get authErrorNetworkRequestFailed =>
      '[JA] Network error. Please check your connection and try again.';

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
      '[JA] Please log in again to perform this operation.';

  @override
  String get authErrorAppNotAuthorized =>
      '[JA] This app is not authorized to use Firebase Authentication.';

  @override
  String get authErrorInvalidVerificationCode =>
      '[JA] The verification code is invalid.';

  @override
  String get authErrorInvalidVerificationId =>
      '[JA] The verification ID is invalid.';

  @override
  String get authErrorMissingVerificationCode =>
      '[JA] Please enter the verification code.';

  @override
  String get authErrorMissingVerificationId => '[JA] Missing verification ID.';

  @override
  String get authErrorInvalidPhoneNumber => '[JA] The phone number is invalid.';

  @override
  String get authErrorMissingPhoneNumber => '[JA] Please enter a phone number.';

  @override
  String get authErrorQuotaExceeded =>
      '[JA] The SMS quota for this project has been exceeded. Please try again later.';

  @override
  String get authErrorCodeExpired =>
      '[JA] The verification code has expired. Please request a new one.';

  @override
  String get authErrorSessionExpired =>
      '[JA] Your session has expired. Please log in again.';

  @override
  String get authErrorMultiFactorAuthRequired =>
      '[JA] Multi-factor authentication is required.';

  @override
  String get authErrorMultiFactorInfoNotFound =>
      '[JA] Multi-factor information not found.';

  @override
  String get authErrorMissingMultiFactorSession =>
      '[JA] Missing multi-factor session.';

  @override
  String get authErrorInvalidMultiFactorSession =>
      '[JA] Invalid multi-factor session.';

  @override
  String get authErrorSecondFactorAlreadyInUse =>
      '[JA] This second factor is already in use.';

  @override
  String get authErrorMaximumSecondFactorCountExceeded =>
      '[JA] Maximum number of second factors exceeded.';

  @override
  String get authErrorUnsupportedFirstFactor =>
      '[JA] Unsupported first factor for multi-factor authentication.';

  @override
  String get authErrorEmailChangeNeedsVerification =>
      '[JA] Email change requires verification.';

  @override
  String get authErrorPhoneNumberAlreadyExists =>
      '[JA] This phone number is already in use.';

  @override
  String get authErrorInvalidPassword =>
      '[JA] The password is invalid or too weak.';

  @override
  String get authErrorInvalidIdToken => '[JA] The ID token is invalid.';

  @override
  String get authErrorIdTokenExpired => '[JA] The ID token has expired.';

  @override
  String get authErrorIdTokenRevoked => '[JA] The ID token has been revoked.';

  @override
  String get authErrorInternalError =>
      '[JA] An internal error occurred. Please try again.';

  @override
  String get authErrorInvalidArgument =>
      '[JA] An invalid argument was provided.';

  @override
  String get authErrorInvalidClaims => '[JA] Invalid custom claims provided.';

  @override
  String get authErrorInvalidContinueUri => '[JA] The continue URL is invalid.';

  @override
  String get authErrorInvalidCreationTime =>
      '[JA] The creation time is invalid.';

  @override
  String get authErrorInvalidDisabledField =>
      '[JA] The disabled field value is invalid.';

  @override
  String get authErrorInvalidDisplayName => '[JA] The display name is invalid.';

  @override
  String get authErrorInvalidDynamicLinkDomain =>
      '[JA] The dynamic link domain is invalid.';

  @override
  String get authErrorInvalidEmailVerified =>
      '[JA] The email verified value is invalid.';

  @override
  String get authErrorInvalidHashAlgorithm =>
      '[JA] The hash algorithm is invalid.';

  @override
  String get authErrorInvalidHashBlockSize =>
      '[JA] The hash block size is invalid.';

  @override
  String get authErrorInvalidHashDerivedKeyLength =>
      '[JA] The hash derived key length is invalid.';

  @override
  String get authErrorInvalidHashKey => '[JA] The hash key is invalid.';

  @override
  String get authErrorInvalidHashMemoryCost =>
      '[JA] The hash memory cost is invalid.';

  @override
  String get authErrorInvalidHashParallelization =>
      '[JA] The hash parallelization is invalid.';

  @override
  String get authErrorInvalidHashRounds =>
      '[JA] The hash rounds value is invalid.';

  @override
  String get authErrorInvalidHashSaltSeparator =>
      '[JA] The hash salt separator is invalid.';

  @override
  String get authErrorInvalidLastSignInTime =>
      '[JA] The last sign-in time is invalid.';

  @override
  String get authErrorInvalidPageToken => '[JA] The page token is invalid.';

  @override
  String get authErrorInvalidProviderData =>
      '[JA] The provider data is invalid.';

  @override
  String get authErrorInvalidProviderId => '[JA] The provider ID is invalid.';

  @override
  String get authErrorInvalidSessionCookieDuration =>
      '[JA] The session cookie duration is invalid.';

  @override
  String get authErrorInvalidUid => '[JA] The UID is invalid.';

  @override
  String get authErrorInvalidUserImport =>
      '[JA] The user import record is invalid.';

  @override
  String get authErrorMaximumUserCountExceeded =>
      '[JA] Maximum user import count exceeded.';

  @override
  String get authErrorMissingAndroidPkgName =>
      '[JA] Missing Android package name.';

  @override
  String get authErrorMissingContinueUri => '[JA] Missing continue URL.';

  @override
  String get authErrorMissingHashAlgorithm => '[JA] Missing hash algorithm.';

  @override
  String get authErrorMissingIosBundleId => '[JA] Missing iOS bundle ID.';

  @override
  String get authErrorMissingUid => '[JA] Missing UID.';

  @override
  String get authErrorMissingOauthClientSecret =>
      '[JA] Missing OAuth client secret.';

  @override
  String get authErrorProjectNotFound => '[JA] Firebase project not found.';

  @override
  String get authErrorReservedClaims => '[JA] Reserved claims provided.';

  @override
  String get authErrorSessionCookieExpired =>
      '[JA] Session cookie has expired.';

  @override
  String get authErrorSessionCookieRevoked =>
      '[JA] Session cookie has been revoked.';

  @override
  String get authErrorUidAlreadyExists => '[JA] The UID is already in use.';

  @override
  String get authErrorUnauthorizedContinueUri =>
      '[JA] The continue URL domain is not whitelisted.';

  @override
  String get authErrorUnknown =>
      '[JA] An unknown authentication error occurred.';

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
  String get adminFreeAccess => '[JA] Admin Free Access';

  @override
  String emailProfileemail(Object email, Object profileEmail) {
    return 'البريد الإلكتروني للملف الشخصي: $email';
  }

  @override
  String get calendar => 'التقويم';

  @override
  String get upload1 => '[JA] Upload (Japanese)';

  @override
  String get resolved => 'تم الحل';

  @override
  String get keepSubscription => 'الاحتفاظ بالاشتراك';

  @override
  String get virtualSessionCreatedInvitingFriends =>
      '[JA] Virtual session created! Inviting friends... (Japanese)';

  @override
  String get noEventsScheduledForToday => 'لا توجد أحداث مجدولة لليوم';

  @override
  String get exportData => 'تصدير البيانات';

  @override
  String get rewards => '[JA] Rewards (Japanese)';

  @override
  String get time => '[JA] Time (Japanese)';

  @override
  String userCid(Object cid, Object id) {
    return '[JA] User $id';
  }

  @override
  String get noSlots => '[JA] No slots (Japanese)';

  @override
  String get signIn => '[JA] Sign In (Japanese)';

  @override
  String get homeFeedScreen => '[JA] Home Feed Screen (Japanese)';

  @override
  String get selectLocation => '[JA] Select Location (Japanese)';

  @override
  String get noTicketsYet => '[JA] No tickets yet (Japanese)';

  @override
  String get meetingSharedSuccessfully1 => 'تم مشاركة الاجتماع بنجاح';

  @override
  String get studioProfile => 'ملف الاستوديو';

  @override
  String get subscriptionUnavailable =>
      '[JA] Subscription unavailable (Japanese)';

  @override
  String get confirmBooking => '[JA] Confirm Booking (Japanese)';

  @override
  String get failedToUpdatePermissionE =>
      '[JA] Failed to update permission: \$e (Japanese)';

  @override
  String get reject => '[JA] Reject (Japanese)';

  @override
  String ambassadorStatusAmbassadorstatus(Object ambassadorStatus) {
    return '[JA] Ambassador Status: $ambassadorStatus (Japanese)';
  }

  @override
  String get noProviders => '[JA] No providers';

  @override
  String get checkingSubscription => '[JA] Checking subscription... (Japanese)';

  @override
  String errorPickingImageE(Object e) {
    return 'خطأ في اختيار الصورة: $e';
  }

  @override
  String get noContentAvailableYet =>
      '[JA] No content available yet (Japanese)';

  @override
  String get resolve => '[JA] Resolve (Japanese)';

  @override
  String get errorLoadingSurveysError =>
      '[JA] Error loading surveys: \$error (Japanese)';

  @override
  String errorLogerrormessage(Object errorMessage) {
    return '[JA] Error: $errorMessage';
  }

  @override
  String get getHelpWithYourAccount =>
      '[JA] Get help with your account (Japanese)';

  @override
  String get pay => '[JA] Pay (Japanese)';

  @override
  String get noOrganizations => '[JA] noOrganizations (TRANSLATE)';

  @override
  String get meetingDetails => 'تفاصيل الاجتماع';

  @override
  String get errorLoadingAppointments => 'خطأ في تحميل المواعيد';

  @override
  String get changesSavedSuccessfully =>
      '[JA] Changes saved successfully! (Japanese)';

  @override
  String get createNewInvoice => '[JA] Create New Invoice (Japanese)';

  @override
  String get profileNotFound => 'الملف الشخصي غير موجود';

  @override
  String errorConfirmingPaymentE(Object e) {
    return 'خطأ في تأكيد الدفع: $e';
  }

  @override
  String get inviteFriends => 'دعوة الأصدقاء';

  @override
  String get profileSaved => '[JA] Profile saved! (Japanese)';

  @override
  String get receiveBookingNotificationsViaEmail =>
      'استقبال إشعارات الحجز عبر البريد الإلكتروني';

  @override
  String valuetointk(Object k, Object value) {
    return '[JA] \\\$${value}K (Japanese)';
  }

  @override
  String get deleteAccount => '[JA] Delete Account (Japanese)';

  @override
  String get profile1 => 'الملف الشخصي';

  @override
  String get businessOnboarding => '[JA] Business Onboarding (Japanese)';

  @override
  String get addNewClient => '[JA] Add New Client (Japanese)';

  @override
  String get darkMode => '[JA] Dark Mode (Japanese)';

  @override
  String get addProvider => '[JA] Add Provider';

  @override
  String noRouteDefinedForStateuripath(Object path) {
    return '[JA] No route defined for $path';
  }

  @override
  String get youWillReceiveAConfirmationEmailShortly =>
      '[JA] You will receive a confirmation email shortly. (Japanese)';

  @override
  String get addQuestion => '[JA] Add Question (Japanese)';

  @override
  String get privacyPolicy => '[JA] Privacy Policy (Japanese)';

  @override
  String branchesLengthBranches(Object branchCount) {
    return '[JA] $branchCount branches (Japanese)';
  }

  @override
  String get join => '[JA] Join (Japanese)';

  @override
  String get businessSubscription => '[JA] Business Subscription (Japanese)';

  @override
  String get myInvites1 => 'دعواتي';

  @override
  String get providers => '[JA] Providers';

  @override
  String get surveyManagement => '[JA] Survey Management (Japanese)';

  @override
  String get pleaseEnterAValidEmailOrPhone =>
      '[JA] Please enter a valid email or phone';

  @override
  String get noRoomsFoundAddYourFirstRoom =>
      '[JA] No rooms found. Add your first room! (Japanese)';

  @override
  String get readOurPrivacyPolicy => '[JA] Read our privacy policy (Japanese)';

  @override
  String get couldNotOpenPrivacyPolicy =>
      '[JA] Could not open privacy policy (Japanese)';

  @override
  String get refresh1 => '[JA] Refresh (Japanese)';

  @override
  String get roomUpdatedSuccessfully =>
      '[JA] Room updated successfully! (Japanese)';

  @override
  String get contentDetail => '[JA] Content Detail (Japanese)';

  @override
  String get cancelSubscription => '[JA] Cancel Subscription (Japanese)';

  @override
  String get successfullyRegisteredAsAmbassador =>
      '[JA] Successfully registered as Ambassador! (Japanese)';

  @override
  String get save1 => '[JA] Save (Japanese)';

  @override
  String get copy1 => '[JA] Copy (Japanese)';

  @override
  String get failedToSendInvitationE =>
      '[JA] Failed to send invitation: \$e (Japanese)';

  @override
  String get surveyScore => '[JA] Survey Score (Japanese)';

  @override
  String userUserid(Object userId) {
    return '[JA] User \$userId';
  }

  @override
  String get noAppointmentsFound => '[JA] No appointments found. (Japanese)';

  @override
  String get responseDetail => '[JA] Response Detail (Japanese)';

  @override
  String get businessVerificationScreenComingSoon =>
      'شاشة التحقق من الأعمال - قريباً';

  @override
  String get businessProfileActivatedSuccessfully =>
      'تم تفعيل الملف التجاري بنجاح';

  @override
  String get failedToStartProSubscriptionE =>
      '[JA] Failed to start Pro subscription: \$e (Japanese)';

  @override
  String get businessDashboardEntryScreenComingSoon =>
      '[JA] Business Dashboard Entry Screen - Coming Soon (Japanese)';

  @override
  String get contentFilter => '[JA] Content Filter (Japanese)';

  @override
  String get helpSupport => '[JA] Help & Support (Japanese)';

  @override
  String get editRoom => '[JA] Edit Room (Japanese)';

  @override
  String appointmentApptid(Object appointmentId) {
    return '[JA] Appointment: $appointmentId';
  }

  @override
  String deviceLogdeviceinfo(Object deviceInfo) {
    return '[JA] Device: $deviceInfo';
  }

  @override
  String get businessCrmEntryScreenComingSoon =>
      '[JA] Business CRM Entry Screen - Coming Soon (Japanese)';

  @override
  String get adminDashboard => '[JA] Admin Dashboard';

  @override
  String orgmemberidslengthMembers(Object memberCount) {
    return '[JA] $memberCount members';
  }

  @override
  String get errorLoadingDashboardError =>
      '[JA] Error loading dashboard: \$error (Japanese)';

  @override
  String get gameDeletedSuccessfully =>
      '[JA] Game deleted successfully! (Japanese)';

  @override
  String get viewResponsesComingSoon =>
      '[JA] View responses - Coming soon! (Japanese)';

  @override
  String get deleteProvider => '[JA] Delete Provider';

  @override
  String get errorLoadingRewards => '[JA] Error loading rewards (Japanese)';

  @override
  String get failedToDeleteAccountE =>
      '[JA] Failed to delete account: \$e (Japanese)';

  @override
  String get invited1 => '[JA] Invited (Japanese)';

  @override
  String get noBranchesAvailable => '[JA] No branches available (Japanese)';

  @override
  String get errorError => '[JA] Error: \$error (Japanese)';

  @override
  String get noEvents => '[JA] No events (Japanese)';

  @override
  String get gameCreatedSuccessfully =>
      '[JA] Game created successfully! (Japanese)';

  @override
  String get add1 => '[JA] Add (Japanese)';

  @override
  String get creatorCreatorid => '[JA] Creator: \$creatorId';

  @override
  String eventstarttimeEventendtime(Object endTime, Object startTime) {
    return '[JA] $startTime - $endTime (Japanese)';
  }

  @override
  String get allowPlaytime => '[JA] Allow Playtime (Japanese)';

  @override
  String get clients => '[JA] Clients (Japanese)';

  @override
  String get noAmbassadorDataAvailable =>
      '[JA] No ambassador data available (Japanese)';

  @override
  String get backgroundDeletedSuccessfully =>
      '[JA] Background deleted successfully! (Japanese)';

  @override
  String errorSnapshoterror(Object error) {
    return '[JA] Error: $error (Japanese)';
  }

  @override
  String get noAnalyticsDataAvailableYet =>
      '[JA] No analytics data available yet. (Japanese)';

  @override
  String errorDeletingSlotE(Object e) {
    return 'خطأ في حذف الفترة: $e';
  }

  @override
  String get businessPhoneBookingEntryScreenComingSoon =>
      '[JA] Business Phone Booking Entry Screen - Coming Soon (Japanese)';

  @override
  String get verification => '[JA] Verification (Japanese)';

  @override
  String get copyLink => '[JA] Copy Link (Japanese)';

  @override
  String get dashboard1 => '[JA] Dashboard (Japanese)';

  @override
  String get manageChildAccounts => '[JA] Manage Child Accounts (Japanese)';

  @override
  String get grantConsent => '[JA] Grant Consent (Japanese)';

  @override
  String get myProfile1 => '[JA] My Profile (Japanese)';

  @override
  String get submit => '[JA] Submit (Japanese)';

  @override
  String userLoguseremail(Object userEmail) {
    return '[JA] User: $userEmail';
  }

  @override
  String get emailNotifications => 'إشعارات البريد الإلكتروني';

  @override
  String get ambassadorDashboard => '[JA] Ambassador Dashboard (Japanese)';

  @override
  String get phoneBooking => '[JA] Phone Booking (Japanese)';

  @override
  String get bookViaChat => '[JA] Book via Chat (Japanese)';

  @override
  String get error => 'エラー';

  @override
  String get businessProfile => '[JA] Business Profile (Japanese)';

  @override
  String get businessBookingEntryScreenComingSoon =>
      '[JA] Business Booking Entry Screen - Coming Soon (Japanese)';

  @override
  String get createNewSurvey => '[JA] Create New Survey (Japanese)';

  @override
  String get backgroundRejected => '[JA] Background rejected (Japanese)';

  @override
  String get noMediaSelected => '[JA] No media selected (Japanese)';

  @override
  String get syncToGoogle => '[JA] Sync to Google (Japanese)';

  @override
  String get virtualPlaytime => '[JA] Virtual Playtime (Japanese)';

  @override
  String get colorContrastTesting => '[JA] Color Contrast Testing';

  @override
  String get loginFailedE => '[JA] Login failed: \$e';

  @override
  String get invitationSentSuccessfully =>
      '[JA] Invitation sent successfully! (Japanese)';

  @override
  String get registering => '[JA] Registering... (Japanese)';

  @override
  String statusAppointmentstatusname(Object status) {
    return '[JA] Status: $status (Japanese)';
  }

  @override
  String get home1 => '[JA] Home (Japanese)';

  @override
  String get errorSavingSettingsE =>
      '[JA] Error saving settings: \$e (Japanese)';

  @override
  String get appVersionAndInformation =>
      '[JA] App version and information (Japanese)';

  @override
  String get businessSubscriptionEntryScreenComingSoon =>
      '[JA] Business Subscription Entry Screen - Coming Soon (Japanese)';

  @override
  String ekeyEvalue(Object key, Object value) {
    return '[JA] $key: $value (Japanese)';
  }

  @override
  String get yourPaymentHasBeenProcessedSuccessfully =>
      '[JA] Your payment has been processed successfully. (Japanese)';

  @override
  String get errorE => '[JA] Error: \$e (Japanese)';

  @override
  String get viewAll1 => '[JA] View All (Japanese)';

  @override
  String get editSurveyComingSoon =>
      '[JA] Edit survey - Coming soon! (Japanese)';

  @override
  String get enterOtp => '[JA] Enter OTP (Japanese)';

  @override
  String get payment => '[JA] Payment (Japanese)';

  @override
  String get automaticallyConfirmNewBookingRequests =>
      '[JA] Automatically confirm new booking requests (Japanese)';

  @override
  String errorPickingVideoE(Object e) {
    return 'خطأ في اختيار الفيديو: $e';
  }

  @override
  String noRouteDefinedForSettingsname(Object settingsName) {
    return '[JA] No route defined for $settingsName (Japanese)';
  }

  @override
  String get pleaseSignInToUploadABackground =>
      '[JA] Please sign in to upload a background (Japanese)';

  @override
  String logtargettypeLogtargetid(Object targetId, Object targetType) {
    return '[JA] $targetType: $targetId';
  }

  @override
  String get staffAvailability => '[JA] Staff Availability (Japanese)';

  @override
  String get livePlaytime => '[JA] Live Playtime (Japanese)';

  @override
  String get autoconfirmBookings => '[JA] Auto-Confirm Bookings (Japanese)';

  @override
  String get redirectingToStripeCheckoutForProPlan =>
      '[JA] Redirecting to Stripe checkout for Pro plan... (Japanese)';

  @override
  String get exportAsCsv => '[JA] Export as CSV (Japanese)';

  @override
  String get deleteFunctionalityComingSoon =>
      '[JA] Delete functionality coming soon! (Japanese)';

  @override
  String get editClient => '[JA] Edit Client (Japanese)';

  @override
  String get areYouSureYouWantToDeleteThisMessage =>
      '[JA] Are you sure you want to delete this message? (Japanese)';

  @override
  String referralsAmbassadorreferrals(Object referrals) {
    return '[JA] Referrals: $referrals (Japanese)';
  }

  @override
  String get notAuthenticated => '[JA] Not authenticated';

  @override
  String get privacyRequestSentToYourParents =>
      '[JA] Privacy request sent to your parents! (Japanese)';

  @override
  String get clientDeletedSuccessfully =>
      '[JA] Client deleted successfully! (Japanese)';

  @override
  String get failedToCancelSubscription =>
      '[JA] Failed to cancel subscription (Japanese)';

  @override
  String get allLanguages => '[JA] All Languages (Japanese)';

  @override
  String get slotDeletedSuccessfully =>
      '[JA] Slot deleted successfully (Japanese)';

  @override
  String get businessProvidersEntryScreenComingSoon =>
      '[JA] Business Providers Entry Screen - Coming Soon';

  @override
  String get parentsMustApproveBeforeChildrenCanJoin =>
      '[JA] Parents must approve before children can join (Japanese)';

  @override
  String get subscribeToPro1499mo =>
      '[JA] Subscribe to Pro (€14.99/mo) (Japanese)';

  @override
  String get businessAvailabilityEntryScreenComingSoon =>
      '[JA] Business Availability Entry Screen - Coming Soon (Japanese)';

  @override
  String appointmentsListlength(Object count) {
    return '[JA] Appointments: $count (Japanese)';
  }

  @override
  String get clearFilters => '[JA] Clear Filters (Japanese)';

  @override
  String get submitBooking => '[JA] Submit Booking (Japanese)';

  @override
  String get areYouSureYouWantToCancelThisAppointment =>
      '[JA] Are you sure you want to cancel this appointment? (Japanese)';

  @override
  String get noUpcomingBookings => '[JA] No upcoming bookings (Japanese)';

  @override
  String get goBack => '[JA] Go Back (Japanese)';

  @override
  String get setup => '[JA] Setup (Japanese)';

  @override
  String get inviteChild => '[JA] Invite Child (Japanese)';

  @override
  String get goToDashboard => '[JA] Go to Dashboard (Japanese)';

  @override
  String get ambassadorQuotaDashboard =>
      '[JA] Ambassador Quota Dashboard (Japanese)';

  @override
  String get adminSettings => '[JA] Admin Settings';

  @override
  String get referralCode => '[JA] Referral Code (Japanese)';

  @override
  String adminLogadminemail(Object adminEmail) {
    return '[JA] Admin: $adminEmail';
  }

  @override
  String get date => '[JA] Date (Japanese)';

  @override
  String get readOnly => '[JA] Read Only (Japanese)';

  @override
  String get bookingRequest => '[JA] Booking Request (Japanese)';

  @override
  String get advancedReporting => '[JA] • Advanced reporting (Japanese)';

  @override
  String get rooms => '[JA] Rooms (Japanese)';

  @override
  String get copiedToClipboard => '[JA] Copied to clipboard (Japanese)';

  @override
  String get bookingConfirmed => '[JA] Booking Confirmed (Japanese)';

  @override
  String get sessionApproved => 'تمت الموافقة على الجلسة';

  @override
  String get clientAddedSuccessfully =>
      '[JA] Client added successfully! (Japanese)';

  @override
  String get noNotifications => 'لا توجد إشعارات';

  @override
  String get backgroundApproved => '[JA] Background approved! (Japanese)';

  @override
  String get familySupport => '[JA] Family Support (Japanese)';

  @override
  String get deletingAccount => '[JA] Deleting account... (Japanese)';

  @override
  String get bookAppointment => '[JA] Book Appointment (Japanese)';

  @override
  String get receivePushNotificationsForNewBookings =>
      'استقبال إشعارات الدفع للحجوزات الجديدة';

  @override
  String get delete1 => '[JA] Delete (Japanese)';

  @override
  String get sendBookingInvite => '[JA] Send Booking Invite (Japanese)';

  @override
  String get text => '[JA] Text (Japanese)';

  @override
  String get manageSubscription => '[JA] Manage Subscription (Japanese)';

  @override
  String get requiresInstallFallback =>
      '[JA] Requires Install Fallback (Japanese)';

  @override
  String get paymentConfirmation => '[JA] Payment Confirmation (Japanese)';

  @override
  String get promoAppliedYourNextBillIsFree =>
      '[JA] Promo applied! Your next bill is free. (Japanese)';

  @override
  String inviteeArgsinviteeid(Object inviteeId) {
    return 'المدعو: $inviteeId';
  }

  @override
  String get errorLoadingSlots => '[JA] Error loading slots (Japanese)';

  @override
  String get allowOtherUsersToFindAndJoinThisGame =>
      '[JA] Allow other users to find and join this game (Japanese)';

  @override
  String get businessOnboardingScreenComingSoon =>
      '[JA] Business Onboarding Screen - Coming Soon (Japanese)';

  @override
  String get activateBusinessProfile =>
      '[JA] Activate Business Profile (Japanese)';

  @override
  String get contentNotFound => '[JA] Content not found (Japanese)';

  @override
  String pspecialtynpcontactinfo(Object contactInfo, Object specialty) {
    return '[JA] $specialty\\n$contactInfo (Japanese)';
  }

  @override
  String get rating => '[JA] Rating (Japanese)';

  @override
  String get messages => '[JA] Messages (Japanese)';

  @override
  String errorEstimatingRecipientsE(Object e) {
    return 'خطأ في تقدير المستلمين: $e';
  }

  @override
  String get becomeAnAmbassador => '[JA] Become an Ambassador (Japanese)';

  @override
  String get subscribeNow => '[JA] Subscribe Now (Japanese)';

  @override
  String timeArgsslotformatcontext(Object time) {
    return '[JA] Time: $time (Japanese)';
  }

  @override
  String get shareViaWhatsapp => '[JA] Share via WhatsApp (Japanese)';

  @override
  String get users1 => '[JA] Users (Japanese)';

  @override
  String get shareLink => '[JA] Share Link (Japanese)';

  @override
  String get areYouSureYouWantToDeleteThisProvider =>
      '[JA] Are you sure you want to delete this provider?';

  @override
  String get deleteAppointment => '[JA] Delete Appointment (Japanese)';

  @override
  String get toggleAvailability => '[JA] Toggle Availability (Japanese)';

  @override
  String get changePlan => '[JA] Change Plan (Japanese)';

  @override
  String get errorLoadingStaff => '[JA] Error loading staff (Japanese)';

  @override
  String errorLoadingConfigurationE(Object e) {
    return 'خطأ في تحميل التكوين: $e';
  }

  @override
  String get updateYourBusinessInformation =>
      '[JA] Update your business information (Japanese)';

  @override
  String get noProvidersFoundAddYourFirstProvider =>
      '[JA] No providers found. Add your first provider!';

  @override
  String get parentDashboard => '[JA] Parent Dashboard (Japanese)';

  @override
  String get menu => '[JA] Menu (Japanese)';

  @override
  String get studioBooking => '[JA] Studio Booking (Japanese)';

  @override
  String get about1 => '[JA] About (Japanese)';

  @override
  String get multipleChoice => '[JA] Multiple Choice (Japanese)';

  @override
  String dateAppointmentscheduledattostring(Object date) {
    return '[JA] Date: $date (Japanese)';
  }

  @override
  String get studioBookingIsOnlyAvailableOnWeb =>
      '[JA] Studio booking is only available on web (Japanese)';

  @override
  String get errorLoadingBranchesE =>
      '[JA] Error loading branches: \$e (Japanese)';

  @override
  String ud83dudcc5Bookingdatetimetolocal(Object dateTime) {
    return '[JA] \\uD83D\\uDCC5 $dateTime (Japanese)';
  }

  @override
  String appointmentInviteappointmentid(Object appointmentId) {
    return 'دعوة الموعد: $appointmentId';
  }

  @override
  String get none => '[JA] None (Japanese)';

  @override
  String get failedToUpdateConsentE =>
      '[JA] Failed to update consent: \$e (Japanese)';

  @override
  String get welcome1 => '[JA] Welcome (Japanese)';

  @override
  String get failedToCreateSessionE =>
      '[JA] Failed to create session: \$e (Japanese)';

  @override
  String get inviteContact => '[JA] Invite Contact (Japanese)';

  @override
  String get surveyEditor => '[JA] Survey Editor (Japanese)';

  @override
  String get failedToStartBasicSubscriptionE =>
      '[JA] Failed to start Basic subscription: \$e (Japanese)';

  @override
  String get mySchedule => '[JA] My Schedule (Japanese)';

  @override
  String get studioDashboard => '[JA] Studio Dashboard (Japanese)';

  @override
  String get editProfile => 'تحرير الملف الشخصي';

  @override
  String get logout1 => '[JA] Logout';

  @override
  String serviceServiceidNotSelected(Object service) {
    return '[JA] Service: $service';
  }

  @override
  String get settingsSavedSuccessfully =>
      '[JA] Settings saved successfully! (Japanese)';

  @override
  String get linkCopiedToClipboard =>
      '[JA] Link copied to clipboard! (Japanese)';

  @override
  String get accept1 => '[JA] Accept (Japanese)';

  @override
  String get noAvailableSlots => '[JA] No available slots (Japanese)';

  @override
  String get makeGamePublic => '[JA] Make Game Public (Japanese)';

  @override
  String permissionPermissioncategoryUpdatedToNewvalue(Object category) {
    return '[JA] Permission $category updated to \$newValue (Japanese)';
  }

  @override
  String get roomDeletedSuccessfully =>
      '[JA] Room deleted successfully! (Japanese)';

  @override
  String get businessCalendar => '[JA] Business Calendar (Japanese)';

  @override
  String get addAvailability => '[JA] Add Availability (Japanese)';

  @override
  String get ambassadorOnboarding => '[JA] Ambassador Onboarding (Japanese)';

  @override
  String phoneProfileasyncphone(Object phone) {
    return '[JA] Phone: $phone (Japanese)';
  }

  @override
  String get addNewRoom => '[JA] Add New Room (Japanese)';

  @override
  String get requireParentApproval => '[JA] Require Parent Approval (Japanese)';

  @override
  String get closed => '[JA] Closed (Japanese)';

  @override
  String get exportAsPdf => '[JA] Export as PDF (Japanese)';

  @override
  String get enableVibration => '[JA] Enable Vibration (Japanese)';

  @override
  String toAvailendformatcontext(Object endTime) {
    return '[JA] To: $endTime (Japanese)';
  }

  @override
  String yourUpgradeCodeUpgradecode(Object upgradeCode) {
    return '[JA] Your upgrade code: \$upgradeCode (Japanese)';
  }

  @override
  String get requestPrivateSession => '[JA] requestPrivateSession (TRANSLATE)';

  @override
  String get country => '[JA] Country (Japanese)';

  @override
  String get loginScreen => '[JA] Login Screen';

  @override
  String staffArgsstaffdisplayname(Object staffName) {
    return '[JA] Staff: $staffName (Japanese)';
  }

  @override
  String get revokeConsent => '[JA] Revoke Consent (Japanese)';

  @override
  String get settings1 => '[JA] Settings (Japanese)';

  @override
  String get cancel1 => '[JA] Cancel (Japanese)';

  @override
  String get subscriptionActivatedSuccessfully =>
      '[JA] Subscription activated successfully! (Japanese)';

  @override
  String activityLogaction(Object action) {
    return '[JA] Activity: $action';
  }

  @override
  String get broadcast => '[JA] Broadcast (Japanese)';

  @override
  String get noEventsScheduledThisWeek =>
      '[JA] No events scheduled this week (Japanese)';

  @override
  String get googleCalendar => '[JA] Google Calendar (Japanese)';

  @override
  String get sendInvite => 'إرسال دعوة';

  @override
  String get childDashboard => '[JA] Child Dashboard (Japanese)';

  @override
  String get failedToUploadBackgroundE =>
      '[JA] Failed to upload background: \$e (Japanese)';

  @override
  String linkchildidsubstring08(Object linkId) {
    return '[JA] $linkId...';
  }

  @override
  String targetLogtargettypeLogtargetid(Object targetId, Object targetType) {
    return '[JA] Target: $targetType - $targetId';
  }

  @override
  String get contextContextid => '[JA] Context: \$contextId';

  @override
  String get noAppointments => '[JA] No appointments (Japanese)';

  @override
  String get unlimitedBookingsPerWeek =>
      '[JA] • Unlimited bookings per week (Japanese)';

  @override
  String errorDetailsLogerrortype(Object errorType, Object logErrorType) {
    return 'تفاصيل الخطأ: $logErrorType';
  }

  @override
  String get scheduledAtScheduledat =>
      '[JA] Scheduled at: \$scheduledAt (Japanese)';

  @override
  String get selectStaff => '[JA] Select Staff (Japanese)';

  @override
  String get subscriptionCancelledSuccessfully =>
      '[JA] Subscription cancelled successfully (Japanese)';

  @override
  String get pleaseLogInToViewYourProfile =>
      'يرجى تسجيل الدخول لعرض ملفك الشخصي';

  @override
  String get cancelAppointment => '[JA] Cancel Appointment (Japanese)';

  @override
  String permissionsFamilylinkchildid(Object childId) {
    return '[JA] Permissions - $childId';
  }

  @override
  String get businessSignup => '[JA] Business Signup (Japanese)';

  @override
  String get businessCompletionScreenComingSoon =>
      '[JA] Business Completion Screen - Coming Soon (Japanese)';

  @override
  String get createGame1 => '[JA] Create Game (Japanese)';

  @override
  String valuetoint(Object value) {
    return '[JA] $value (Japanese)';
  }

  @override
  String get pleaseEnterAPromoCode =>
      '[JA] Please enter a promo code (Japanese)';

  @override
  String get errorLoadingAvailabilityE =>
      '[JA] Error loading availability: \$e (Japanese)';

  @override
  String get parentalControls => '[JA] Parental Controls (Japanese)';

  @override
  String get editBusinessProfile => 'تحرير الملف التجاري';

  @override
  String get childLinkedSuccessfully =>
      '[JA] Child linked successfully! (Japanese)';

  @override
  String get create => '[JA] Create (Japanese)';

  @override
  String get noExternalMeetingsFound =>
      '[JA] No external meetings found. (Japanese)';

  @override
  String staffSelectionstaffdisplayname(Object staffName) {
    return '[JA] Staff: $staffName (Japanese)';
  }

  @override
  String get pleaseEnterAValidEmailAddress =>
      '[JA] Please enter a valid email address';

  @override
  String get schedulerScreen => '[JA] Scheduler Screen (Japanese)';

  @override
  String get clientUpdatedSuccessfully =>
      '[JA] Client updated successfully! (Japanese)';

  @override
  String get surveyResponses => '[JA] Survey Responses (Japanese)';

  @override
  String get syncToOutlook => '[JA] Sync to Outlook (Japanese)';

  @override
  String get saveChanges => '[JA] Save Changes (Japanese)';

  @override
  String get pickTime => '[JA] Pick Time (Japanese)';

  @override
  String registrationFailedEtostring(Object error) {
    return '[JA] Registration failed: $error (Japanese)';
  }

  @override
  String get analytics => '[JA] Analytics (Japanese)';

  @override
  String get errorLoadingEvents => '[JA] Error loading events (Japanese)';

  @override
  String get errorLoadingOrganizations =>
      '[JA] errorLoadingOrganizations (TRANSLATE)';

  @override
  String get businessLoginScreenComingSoon =>
      '[JA] Business Login Screen - Coming Soon';

  @override
  String get success1 => '[JA] Success (Japanese)';

  @override
  String appVersionLogappversion(Object appVersion) {
    return '[JA] App Version: $appVersion';
  }

  @override
  String fromAvailstartformatcontext(Object startTime) {
    return '[JA] From: $startTime (Japanese)';
  }

  @override
  String get readWrite => '[JA] Read & Write (Japanese)';

  @override
  String get redirectingToStripeCheckoutForBasicPlan =>
      '[JA] Redirecting to Stripe checkout for Basic plan... (Japanese)';

  @override
  String get errorSavingConfigurationE =>
      '[JA] Error saving configuration: \$e';

  @override
  String get pickDate => '[JA] Pick Date (Japanese)';

  @override
  String get chatBooking => '[JA] Chat Booking (Japanese)';

  @override
  String get noQuestionsAdded => '[JA] No questions added (Japanese)';

  @override
  String severityLogseverityname(Object severity) {
    return '[JA] Severity: $severity';
  }

  @override
  String get markAsPaid => '[JA] Mark as Paid';

  @override
  String get typeOpenCall => '[JA] Type: Open Call (Japanese)';

  @override
  String appointmentAppointmentid(Object appointmentId) {
    return '[JA] Appointment $appointmentId';
  }

  @override
  String statusInvitestatusname(Object inviteStatusName, Object status) {
    return 'الحالة: $inviteStatusName';
  }

  @override
  String get businessLogin => '[JA] Business Login';

  @override
  String get invoiceCreatedSuccessfully =>
      '[JA] Invoice created successfully! (Japanese)';

  @override
  String get noTimeSeriesDataAvailable =>
      '[JA] No time series data available (Japanese)';

  @override
  String subscribeToWidgetplanname(Object planName) {
    return '[JA] Subscribe to $planName';
  }

  @override
  String timestamp_formatdatelogtimestamp(Object timestamp) {
    return '[JA] Timestamp: $timestamp';
  }

  @override
  String get failedToSendPrivacyRequestE =>
      '[JA] Failed to send privacy request: \$e (Japanese)';

  @override
  String get chooseYourPlan => '[JA] Choose Your Plan (Japanese)';

  @override
  String get playtimeManagement => '[JA] Playtime Management (Japanese)';

  @override
  String get availability => '[JA] Availability (Japanese)';

  @override
  String get eventCreated => '[JA] Event created (Japanese)';

  @override
  String get subscribeToBasic499mo =>
      '[JA] Subscribe to Basic (€4.99/mo) (Japanese)';

  @override
  String get completion => '[JA] Completion (Japanese)';

  @override
  String get supportTicketSubmitted =>
      '[JA] Support ticket submitted (Japanese)';

  @override
  String get monetizationSettings => '[JA] Monetization Settings (Japanese)';

  @override
  String get noBookingsFound => '[JA] No bookings found (Japanese)';

  @override
  String get admin => '[JA] Admin';

  @override
  String get deleteSurvey => '[JA] Delete Survey (Japanese)';

  @override
  String get gameApprovedSuccessfully =>
      '[JA] Game approved successfully! (Japanese)';

  @override
  String get errorLoadingPermissionsError =>
      '[JA] Error loading permissions: \$error (Japanese)';

  @override
  String get referrals => '[JA] Referrals (Japanese)';

  @override
  String get crm => '[JA] CRM (Japanese)';

  @override
  String get gameRejected => '[JA] Game rejected (Japanese)';

  @override
  String get appointments => '[JA] Appointments (Japanese)';

  @override
  String get onboardingScreen => '[JA] Onboarding Screen (Japanese)';

  @override
  String get welcomeToYourStudio => '[JA] Welcome to your studio (Japanese)';

  @override
  String get update => '[JA] Update (Japanese)';

  @override
  String get retry1 => '[JA] Retry (Japanese)';

  @override
  String get booking => '[JA] Booking (Japanese)';

  @override
  String get parentalSettings => '[JA] Parental Settings (Japanese)';

  @override
  String get language => '[JA] Language (Japanese)';

  @override
  String get deleteSlot => '[JA] Delete Slot (Japanese)';

  @override
  String get organizations => '[JA] organizations (TRANSLATE)';

  @override
  String get configurationSavedSuccessfully =>
      '[JA] Configuration saved successfully!';

  @override
  String get createNewGame => '[JA] Create New Game (Japanese)';

  @override
  String get next1 => '[JA] Next (Japanese)';

  @override
  String get backgroundUploadedSuccessfully =>
      '[JA] Background uploaded successfully! (Japanese)';

  @override
  String get noAppointmentRequestsFound =>
      '[JA] No appointment requests found. (Japanese)';

  @override
  String get pleaseSignInToCreateASession => 'يرجى تسجيل الدخول لإنشاء جلسة';

  @override
  String get restrictMatureContent => '[JA] Restrict mature content (Japanese)';

  @override
  String get ambassadors => '[JA] Ambassadors (Japanese)';

  @override
  String get smsNotifications => 'إشعارات الرسائل النصية';

  @override
  String get paymentWasCancelled => '[JA] Payment was cancelled (Japanese)';

  @override
  String get clearAll => '[JA] Clear All (Japanese)';

  @override
  String get viewDetails => '[JA] View Details (Japanese)';

  @override
  String get notifications1 => 'الإشعارات';

  @override
  String get liveSessionScheduledWaitingForParentApproval =>
      'تم جدولة جلسة مباشرة، في انتظار موافقة الوالد';

  @override
  String get failedToCreateGameE =>
      '[JA] Failed to create game: \$e (Japanese)';

  @override
  String get noChartDataAvailable => '[JA] No chart data available (Japanese)';

  @override
  String get phonebasedBookingSystem =>
      '[JA] • Phone-based booking system (Japanese)';

  @override
  String get enableNotifications1 => 'تفعيل الإشعارات';

  @override
  String get invoices => '[JA] Invoices (Japanese)';

  @override
  String get pleaseActivateYourBusinessProfileToContinue =>
      'يرجى تفعيل ملفك التجاري للمتابعة';

  @override
  String scheduledAtArgsscheduledat(Object scheduledAt) {
    return '[JA] Scheduled at: $scheduledAt (Japanese)';
  }

  @override
  String durationDurationinminutes0Minutes(Object duration) {
    return '[JA] Duration: $duration minutes (Japanese)';
  }

  @override
  String get tryAgain => '[JA] Try Again (Japanese)';

  @override
  String get deleteBackground => '[JA] Delete Background (Japanese)';

  @override
  String currentTierTiertouppercase(Object tier) {
    return '[JA] Current Tier: $tier (Japanese)';
  }

  @override
  String get iDoNotConsent => '[JA] I Do Not Consent';

  @override
  String get noClientsFoundAddYourFirstClient =>
      '[JA] No clients found. Add your first client! (Japanese)';

  @override
  String get settingsDialogWillBeImplementedHere =>
      '[JA] Settings dialog will be implemented here.';

  @override
  String get groupGroupid => '[JA] Group: \$groupId';

  @override
  String get appointmentRequests => '[JA] Appointment Requests (Japanese)';

  @override
  String get forward => '[JA] Forward (Japanese)';

  @override
  String get roomAddedSuccessfully =>
      '[JA] Room added successfully! (Japanese)';

  @override
  String get option => '[JA] • \$option (Japanese)';

  @override
  String responseIndex1(Object number) {
    return '[JA] Response #$number (Japanese)';
  }

  @override
  String get crmDashboardWithAnalytics =>
      '[JA] • CRM dashboard with analytics (Japanese)';

  @override
  String get contentLibrary1 => '[JA] Content Library (Japanese)';

  @override
  String get reply => '[JA] Reply (Japanese)';

  @override
  String get subscriptionManagement =>
      '[JA] Subscription Management (Japanese)';

  @override
  String get monetizationSettingsWillBeImplementedHere =>
      '[JA] Monetization settings will be implemented here (Japanese)';

  @override
  String get failedToApplyPromoCodeE =>
      '[JA] Failed to apply promo code: \$e (Japanese)';

  @override
  String get editProvider => '[JA] Edit Provider';

  @override
  String get localizationContribution =>
      '[JA] Localization Contribution (Japanese)';

  @override
  String get parentalConsent => '[JA] Parental Consent (Japanese)';

  @override
  String get businessSignupScreenComingSoon =>
      '[JA] Business Signup Screen - Coming Soon (Japanese)';

  @override
  String get areYouSureYouWantToDeleteThisAppointment =>
      '[JA] Are you sure you want to delete this appointment? (Japanese)';

  @override
  String get syncAppointment => '[JA] Sync Appointment (Japanese)';

  @override
  String get iConsent => '[JA] I Consent (Japanese)';

  @override
  String get sessionRejected => 'تم رفض الجلسة';

  @override
  String get businessSetupScreenComingSoon =>
      '[JA] Business Setup Screen - Coming Soon (Japanese)';

  @override
  String get edit1 => '[JA] Edit (Japanese)';

  @override
  String get noEventsScheduledThisMonth =>
      '[JA] No events scheduled this month (Japanese)';

  @override
  String get businessDashboard => '[JA] Business Dashboard (Japanese)';

  @override
  String get noMessagesFound => '[JA] No messages found. (Japanese)';

  @override
  String staffStaffidNotSelected(Object staff) {
    return '[JA] Staff: $staff';
  }

  @override
  String get manageStaffAvailability =>
      '[JA] Manage Staff Availability (Japanese)';

  @override
  String get noMissingTranslations => '[JA] No missing translations (Japanese)';

  @override
  String get skip => '[JA] Skip (Japanese)';

  @override
  String meetingIdMeetingid(Object meetingId) {
    return 'معرف الاجتماع: $meetingId';
  }

  @override
  String get noUsers => '[JA] noUsers (TRANSLATE)';

  @override
  String get errorLoadingReferralCode =>
      '[JA] Error loading referral code (Japanese)';

  @override
  String get allCountries => '[JA] All Countries (Japanese)';

  @override
  String get deleteGame => '[JA] Delete Game (Japanese)';

  @override
  String get staffManagementTools => '[JA] • Staff management tools (Japanese)';

  @override
  String get deleteMessage => '[JA] Delete Message (Japanese)';

  @override
  String get receiveBookingNotificationsViaSms =>
      'استقبال إشعارات الحجز عبر الرسائل النصية';

  @override
  String get changeRole => '[JA] changeRole (TRANSLATE)';

  @override
  String errorLoadingBookingsSnapshoterror(Object error) {
    return 'خطأ في تحميل لقطة الحجوزات: $error';
  }

  @override
  String get openingCustomerPortal =>
      '[JA] Opening customer portal... (Japanese)';

  @override
  String get signOut => '[JA] Sign Out (Japanese)';

  @override
  String nameProfilename(Object name) {
    return '[JA] Name: $name (Japanese)';
  }

  @override
  String get businessProfileEntryScreenComingSoon =>
      'شاشة إدخال الملف التجاري - قريباً';

  @override
  String get upgradeToBusiness => '[JA] Upgrade to Business (Japanese)';

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
  String get viewResponses => '[JA] View Responses (Japanese)';

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
  String get ad_pre_title => '広告を見て予約を確認してください';

  @override
  String get ad_pre_description =>
      '無料ユーザーとして、確認前に短い広告を見る必要があります。アップグレードすることで、すべての広告を永続的に削除できます。';

  @override
  String get watch_ad_button => '広告を見る';

  @override
  String get upgrade_button => 'プレミアムにアップグレード (€4)';

  @override
  String get ad_post_title => '広告終了！今すぐ予約を確認できます。';

  @override
  String get confirm_appointment_button => '予約を確認';

  @override
  String get upgrade_prompt_title => 'ワンタイムアップグレード';

  @override
  String get upgrade_prompt_description => '€4を支払ってすべての広告を永久に削除';

  @override
  String get purchase_now_button => '今すぐ購入';

  @override
  String get welcomeAmbassador => 'Welcome, Ambassador!';

  @override
  String get activeStatus => 'Active';

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
  String get remaining => 'remaining';

  @override
  String get monthlyGoal => 'Monthly Goal';

  @override
  String get onTrack => 'On Track';

  @override
  String get needsAttention => 'Needs Attention';

  @override
  String get monthlyReferralRequirement =>
      'Refer at least 10 new users monthly to maintain ambassador status';

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
  String get shareViaMessage => 'Message';

  @override
  String get shareViaEmail => 'Email';

  @override
  String get shareMore => 'More Options';

  @override
  String get becomeAmbassador => 'Become an Ambassador';

  @override
  String get ambassadorEligible => 'You\'re eligible to become an Ambassador!';

  @override
  String get ambassadorWelcomeTitle => 'Welcome to the Ambassador Program!';

  @override
  String get ambassadorWelcomeMessage =>
      'Congratulations! You\'ve been promoted to Ambassador. Start sharing your link to earn rewards and help grow the APP-OINT community.';

  @override
  String get ambassadorPromotionTitle =>
      '[JA] Congratulations! You\'re now an Ambassador! (Japanese)';

  @override
  String ambassadorPromotionBody(String tier) {
    return '[JA] Welcome to the $tier tier! Start sharing your referral link to earn rewards. (Japanese)';
  }

  @override
  String get tierUpgradeTitle => '[JA] Tier Upgrade! 🎉 (Japanese)';

  @override
  String tierUpgradeBody(
    String previousTier,
    String newTier,
    String totalReferrals,
  ) {
    return '[JA] Amazing! You\'ve been upgraded from $previousTier to $newTier with $totalReferrals referrals! (Japanese)';
  }

  @override
  String get monthlyReminderTitle => '[JA] Monthly Goal Reminder (Japanese)';

  @override
  String monthlyReminderBody(
    String currentReferrals,
    String targetReferrals,
    String daysRemaining,
  ) {
    return '[JA] You have $currentReferrals/$targetReferrals referrals this month. $daysRemaining days left to reach your goal! (Japanese)';
  }

  @override
  String get performanceWarningTitle =>
      '[JA] Ambassador Performance Alert (Japanese)';

  @override
  String performanceWarningBody(
    String currentReferrals,
    String minimumRequired,
  ) {
    return '[JA] Your monthly referrals ($currentReferrals) are below the minimum requirement ($minimumRequired). Your ambassador status may be affected. (Japanese)';
  }

  @override
  String get ambassadorDemotionTitle =>
      '[JA] Ambassador Status Update (Japanese)';

  @override
  String ambassadorDemotionBody(String reason) {
    return '[JA] Your ambassador status has been temporarily suspended due to: $reason. You can regain your status by meeting the requirements again. (Japanese)';
  }

  @override
  String get referralSuccessTitle => '[JA] New Referral! 🎉 (Japanese)';

  @override
  String referralSuccessBody(String referredUserName, String totalReferrals) {
    return '[JA] $referredUserName joined through your referral! You now have $totalReferrals total referrals. (Japanese)';
  }

  @override
  String get title => 'Title';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String get messageType => 'Message Type';

  @override
  String get pleaseEnterContent => 'Please enter content';

  @override
  String get imageSelected => 'Image selected';

  @override
  String get videoSelected => 'Video selected';

  @override
  String get externalLink => 'External Link';

  @override
  String get pleaseEnterLink => 'Please enter a link';

  @override
  String get estimatedRecipients => 'Estimated recipients';

  @override
  String get countries => 'Countries';

  @override
  String get cities => 'Cities';

  @override
  String get subscriptionTiers => 'Subscription Tiers';

  @override
  String get userRoles => 'User Roles';

  @override
  String get errorEstimatingRecipients => 'Error estimating recipients';

  @override
  String get errorPickingImage => 'Error picking image';

  @override
  String get errorPickingVideo => 'Error picking video';

  @override
  String get userNotAuthenticated => 'User not authenticated';

  @override
  String get failedToUploadImage => 'Failed to upload image';

  @override
  String get failedToUploadVideo => 'Failed to upload video';

  @override
  String get image => 'Image';

  @override
  String get video => 'Video';

  @override
  String get continue1 => 'Continue';

  @override
  String get getStarted => 'Get Started';

  @override
  String get analyticsDashboard => 'Analytics Dashboard';

  @override
  String get filters => 'Filters';

  @override
  String get broadcasts => 'Broadcasts';

  @override
  String get formAnalytics => 'Form Analytics';

  @override
  String get totalBroadcasts => 'Total Broadcasts';

  @override
  String get totalRecipients => 'Total Recipients';

  @override
  String get openRate => 'Open Rate';

  @override
  String get engagementRate => 'Engagement Rate';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get breakdown => 'Breakdown';

  @override
  String get byCountry => 'By Country';

  @override
  String get byType => 'By Type';

  @override
  String get noBroadcastsFound => 'No broadcasts found';

  @override
  String get sent => 'Sent';

  @override
  String get responses => 'Responses';

  @override
  String get clickRate => 'Click Rate';

  @override
  String get responseRate => 'Response Rate';

  @override
  String get viewFormAnalytics => 'View Form Analytics';

  @override
  String get pending => 'Pending';

  @override
  String get sending => 'Sending';

  @override
  String get failed => 'Failed';

  @override
  String get partialSent => 'Partial Sent';

  @override
  String get noFormBroadcasts => 'No form broadcasts';

  @override
  String get totalResponses => 'Total Responses';

  @override
  String get noFormData => 'No form data';

  @override
  String get average => 'Average';

  @override
  String get mostCommon => 'Most Common';

  @override
  String get errorLoadingData => 'Error loading data';

  @override
  String get today => 'Today';

  @override
  String get last7Days => 'Last 7 Days';

  @override
  String get last30Days => 'Last 30 Days';

  @override
  String get customRange => 'Custom Range';

  @override
  String get all => 'All';

  @override
  String get timeRange => 'Time Range';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get exportDataDescription =>
      'Export analytics data for the selected time range';

  @override
  String get exportComplete => 'Export complete';

  @override
  String get exportFailed => 'Export failed';

  @override
  String get export => 'Export';
}
