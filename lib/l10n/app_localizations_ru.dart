// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get refresh => 'Обновить';

  @override
  String get home => 'Главная';

  @override
  String get noSessionsYet => 'Сессий пока нет';

  @override
  String get ok => 'ОК';

  @override
  String get playtimeLandingChooseMode => 'Выберите режим';

  @override
  String get signUp => 'Регистрация';

  @override
  String get scheduleMessage => 'Запланировать сообщение';

  @override
  String get decline => 'Отклонить';

  @override
  String get adminBroadcast => 'Вещание администратора';

  @override
  String get login => 'Войти';

  @override
  String get playtimeChooseFriends => 'Выберите друзей';

  @override
  String get noInvites => 'Нет приглашений';

  @override
  String get playtimeChooseTime => 'Выберите время';

  @override
  String get success => 'Успех';

  @override
  String get undo => 'Отменить';

  @override
  String get opened => 'Открыто';

  @override
  String get createVirtualSession => 'Создать виртуальную сессию';

  @override
  String get messageSentSuccessfully => 'Сообщение успешно отправлено';

  @override
  String get redo => 'Повторить';

  @override
  String get next => 'Далее';

  @override
  String get search => 'Поиск';

  @override
  String get cancelInviteConfirmation => 'Отменить подтверждение приглашения';

  @override
  String created(Object date) {
    return 'Создано';
  }

  @override
  String get revokeAccess => 'Отозвать доступ';

  @override
  String get saveGroupForRecognition => 'Сохранить группу для распознавания';

  @override
  String get playtimeLiveScheduled => 'Живая сессия запланирована';

  @override
  String get revokeAccessConfirmation => 'Подтверждение отзыва доступа';

  @override
  String get download => 'Загрузить';

  @override
  String get password => 'Пароль';

  @override
  String errorLoadingFamilyLinks(Object error) {
    return 'Ошибка загрузки семейных ссылок';
  }

  @override
  String get cancel => 'Отмена';

  @override
  String get playtimeCreate => 'Создать Playtime';

  @override
  String failedToActionPrivacyRequest(Object action, Object error) {
    return 'Не удалось обработать запрос приватности';
  }

  @override
  String get appTitle => 'Название приложения';

  @override
  String get accept => 'Принять';

  @override
  String get playtimeModeVirtual => 'Виртуальный режим';

  @override
  String get playtimeDescription => 'Описание Playtime';

  @override
  String get delete => 'Удалить';

  @override
  String get playtimeVirtualStarted => 'Виртуальная сессия начата';

  @override
  String get createYourFirstGame => 'Создайте свою первую игру';

  @override
  String get participants => 'Участники';

  @override
  String recipients(Object count) {
    return 'Получатели';
  }

  @override
  String get noResults => 'Нет результатов';

  @override
  String get yes => 'Да';

  @override
  String get invite => 'Пригласить';

  @override
  String get playtimeModeLive => 'Живой режим';

  @override
  String get done => 'Готово';

  @override
  String get defaultShareMessage => 'Стандартное сообщение для обмена';

  @override
  String get no => 'Нет';

  @override
  String get playtimeHub => 'Центр Playtime';

  @override
  String get error => 'Ошибка';

  @override
  String get createLiveSession => 'Создать живую сессию';

  @override
  String get enableNotifications => 'Включить уведомления';

  @override
  String invited(Object date) {
    return 'Приглашено';
  }

  @override
  String content(Object content) {
    return 'Содержимое';
  }

  @override
  String get meetingSharedSuccessfully => 'Встреча успешно поделена';

  @override
  String get welcomeToPlaytime => 'Добро пожаловать в Playtime';

  @override
  String get viewAll => 'Посмотреть все';

  @override
  String get playtimeVirtual => 'Виртуальный Playtime';

  @override
  String get staffScreenTBD => 'Экран персонала будет определён позже';

  @override
  String get cut => 'Вырезать';

  @override
  String get inviteCancelledSuccessfully => 'Приглашение успешно отменено';

  @override
  String get retry => 'Повторить попытку';

  @override
  String get composeBroadcastMessage => 'Составить трансляционное сообщение';

  @override
  String get sendNow => 'Отправить сейчас';

  @override
  String get noGamesYet => 'Игр пока нет';

  @override
  String get select => 'Выбрать';

  @override
  String get about => 'О приложении';

  @override
  String get choose => 'Выбрать';

  @override
  String get profile => 'Профиль';

  @override
  String get removeChild => 'Удалить ребёнка';

  @override
  String status(Object status) {
    return 'Статус';
  }

  @override
  String get logout => 'Выйти';

  @override
  String get paste => 'Вставить';

  @override
  String get welcome => 'Добро пожаловать';

  @override
  String get playtimeCreateSession => 'Создать сессию';

  @override
  String get familyMembers => 'Члены семьи';

  @override
  String get upload => 'Загрузить';

  @override
  String get upcomingSessions => 'Предстоящие сессии';

  @override
  String get enterGroupName => 'Введите название группы';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get playtimeLive => 'Живой Playtime';

  @override
  String errorLoadingInvites(Object error) {
    return 'Ошибка загрузки приглашений';
  }

  @override
  String get targetingFilters => 'Фильтры таргетинга';

  @override
  String get pickVideo => 'Выбрать видео';

  @override
  String get playtimeGameDeleted => 'Игра удалена';

  @override
  String get scheduleForLater => 'Запланировать на потом';

  @override
  String get accessRevokedSuccessfully => 'Доступ успешно отозван';

  @override
  String get type => 'Тип';

  @override
  String get checkingPermissions => 'Проверка разрешений';

  @override
  String get copy => 'Копировать';

  @override
  String get yesCancel => 'Да, отменить';

  @override
  String get email => 'Электронная почта';

  @override
  String get shareOnWhatsApp => 'Поделиться в WhatsApp';

  @override
  String get notificationSettings => 'Настройки уведомлений';

  @override
  String get myProfile => 'Мой профиль';

  @override
  String get revoke => 'Отозвать';

  @override
  String get noBroadcastMessages => 'Нет трансляционных сообщений';

  @override
  String requestType(Object type) {
    return 'Тип запроса';
  }

  @override
  String get notifications => 'Уведомления';

  @override
  String get details => 'Подробности';

  @override
  String get cancelInvite => 'Отменить приглашение';

  @override
  String get createNew => 'Создать новое';

  @override
  String get settings => 'Настройки';

  @override
  String get playtimeReject => 'Отклонить Playtime';

  @override
  String errorLoadingProfile(Object error) {
    return 'Ошибка загрузки профиля';
  }

  @override
  String get edit => 'Редактировать';

  @override
  String get add => 'Добавить';

  @override
  String get playtimeGameApproved => 'Игра утверждена';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get familyDashboard => 'Панель семьи';

  @override
  String get loading => 'Загрузка';

  @override
  String get quickActions => 'Быстрые действия';

  @override
  String get playtimeTitle => 'Заголовок Playtime';

  @override
  String get otpResentSuccessfully => 'OTP успешно отправлен повторно';

  @override
  String errorCheckingPermissions(Object error) {
    return 'Ошибка проверки разрешений';
  }

  @override
  String get clientScreenTBD => 'Экран клиента будет определён позже';

  @override
  String fcmToken(Object token) {
    return 'FCM токен';
  }

  @override
  String get pickImage => 'Выбрать изображение';

  @override
  String get previous => 'Предыдущий';

  @override
  String get noProfileFound => 'Профиль не найден';

  @override
  String get noFamilyMembersYet => 'Членов семьи пока нет';

  @override
  String get mediaOptional => 'Медиа (необязательно)';

  @override
  String get messageSavedSuccessfully => 'Сообщение успешно сохранено';

  @override
  String get scheduledFor => 'Запланировано на';

  @override
  String get dashboard => 'Панель управления';

  @override
  String get noPermissionForBroadcast => 'Нет разрешения на трансляцию';

  @override
  String get playtimeAdminPanelTitle =>
      'Заголовок панели администратора Playtime';

  @override
  String get inviteDetail => 'Детали приглашения';

  @override
  String scheduled(Object date) {
    return 'Запланировано';
  }

  @override
  String failedToResendOtp(Object error) {
    return 'Не удалось повторно отправить OTP';
  }

  @override
  String get scheduling => 'Планирование';

  @override
  String errorSavingMessage(Object error) {
    return 'Ошибка сохранения сообщения';
  }

  @override
  String get save => 'Сохранить';

  @override
  String get playtimeApprove => 'Утвердить Playtime';

  @override
  String get createYourFirstSession => 'Создайте свою первую сессию';

  @override
  String get playtimeGameRejected => 'Игра отклонена';

  @override
  String failedToRevokeAccess(Object error) {
    return 'Не удалось отозвать доступ';
  }

  @override
  String get recentGames => 'Недавние игры';

  @override
  String get customizeMessage => 'Настроить сообщение';

  @override
  String failedToCancelInvite(Object error) {
    return 'Не удалось отменить приглашение';
  }

  @override
  String errorSendingMessage(Object error) {
    return 'Ошибка отправки сообщения';
  }

  @override
  String get confirmPassword => 'Подтвердите пароль';

  @override
  String errorLoadingPrivacyRequests(Object error) {
    return 'Ошибка загрузки запросов приватности';
  }

  @override
  String get connectedChildren => 'Связанные дети';

  @override
  String get share => 'Поделиться';

  @override
  String get playtimeEnterGameName => 'Введите название игры';

  @override
  String get pleaseLoginForFamilyFeatures =>
      'Пожалуйста, войдите, чтобы получить доступ к семейным функциям';

  @override
  String get myInvites => 'Мои приглашения';

  @override
  String get createGame => 'Создать игру';

  @override
  String get groupNameOptional => 'Название группы (необязательно)';

  @override
  String get playtimeNoSessions => 'Сессии Playtime не найдены.';

  @override
  String get adminScreenTBD => 'Экран администратора скоро будет доступен';

  @override
  String get playtimeParentDashboardTitle => 'Панель управления Playtime';

  @override
  String get close => 'Закрыть';

  @override
  String get knownGroupDetected => 'Обнаружена известная группа';

  @override
  String get back => 'Назад';

  @override
  String get playtimeChooseGame => 'Выберите игру';

  @override
  String get managePermissions => 'Управление разрешениями';

  @override
  String get pollOptions => 'Варианты опроса';

  @override
  String clicked(Object count) {
    return 'Нажато';
  }

  @override
  String link(Object link) {
    return 'Ссылка';
  }

  @override
  String get meetingReadyMessage =>
      'Ваша встреча готова! Присоединяйтесь сейчас';

  @override
  String get pendingInvites => 'Ожидающие приглашения';

  @override
  String statusColon(Object status) {
    return 'Статус:';
  }

  @override
  String get pleaseLoginToViewProfile =>
      'Пожалуйста, войдите, чтобы просмотреть профиль';
}
