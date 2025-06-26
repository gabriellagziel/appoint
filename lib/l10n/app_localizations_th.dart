// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get refresh => 'รีเฟรช';

  @override
  String get home => 'หน้าแรก';

  @override
  String get noSessionsYet => 'ยังไม่มีเซสชัน';

  @override
  String get ok => 'ตกลง';

  @override
  String get playtimeLandingChooseMode => 'เลือกโหมด';

  @override
  String get signUp => 'สมัครสมาชิก';

  @override
  String get scheduleMessage => 'กำหนดการข้อความ';

  @override
  String get decline => 'ปฏิเสธ';

  @override
  String get adminBroadcast => 'ออกอากาศผู้ดูแลระบบ';

  @override
  String get login => 'เข้าสู่ระบบ';

  @override
  String get playtimeChooseFriends => 'เลือกเพื่อน';

  @override
  String get noInvites => 'ไม่มีคำเชิญ';

  @override
  String get playtimeChooseTime => 'เลือกเวลา';

  @override
  String get success => 'สำเร็จ';

  @override
  String get undo => 'เลิกทำ';

  @override
  String get opened => 'เปิดแล้ว';

  @override
  String get createVirtualSession => 'สร้างเซสชันเสมือน';

  @override
  String get messageSentSuccessfully => 'ส่งข้อความสำเร็จ';

  @override
  String get redo => 'ทำซ้ำ';

  @override
  String get next => 'ถัดไป';

  @override
  String get search => 'ค้นหา';

  @override
  String get cancelInviteConfirmation => 'ยกเลิกการยืนยันคำเชิญ';

  @override
  String created(Object date) {
    return 'สร้างแล้ว';
  }

  @override
  String get revokeAccess => 'เพิกถอนสิทธิ์';

  @override
  String get saveGroupForRecognition => 'บันทึกกลุ่มเพื่อการจดจำ';

  @override
  String get playtimeLiveScheduled => 'เซสชันสดถูกกำหนดแล้ว';

  @override
  String get revokeAccessConfirmation => 'ยืนยันการเพิกถอนสิทธิ์';

  @override
  String get download => 'ดาวน์โหลด';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String errorLoadingFamilyLinks(Object error) {
    return 'ข้อผิดพลาดในการโหลดลิงก์ครอบครัว';
  }

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get playtimeCreate => 'สร้าง Playtime';

  @override
  String failedToActionPrivacyRequest(Object action, Object error) {
    return 'ไม่สามารถประมวลผลคำขอความเป็นส่วนตัว';
  }

  @override
  String get appTitle => 'ชื่อแอป';

  @override
  String get accept => 'ยอมรับ';

  @override
  String get playtimeModeVirtual => 'โหมดเสมือน';

  @override
  String get playtimeDescription => 'รายละเอียด Playtime';

  @override
  String get delete => 'ลบ';

  @override
  String get playtimeVirtualStarted => 'เซสชันเสมือนเริ่มแล้ว';

  @override
  String get createYourFirstGame => 'สร้างเกมแรกของคุณ';

  @override
  String get participants => 'ผู้เข้าร่วม';

  @override
  String recipients(Object count) {
    return 'ผู้รับ';
  }

  @override
  String get noResults => 'ไม่มีผลลัพธ์';

  @override
  String get yes => 'ใช่';

  @override
  String get invite => 'เชิญ';

  @override
  String get playtimeModeLive => 'โหมดสด';

  @override
  String get done => 'เสร็จสิ้น';

  @override
  String get defaultShareMessage => 'ข้อความแชร์เริ่มต้น';

  @override
  String get no => 'ไม่';

  @override
  String get playtimeHub => 'ศูนย์กลาง Playtime';

  @override
  String get error => 'ข้อผิดพลาด';

  @override
  String get createLiveSession => 'สร้างเซสชันสด';

  @override
  String get enableNotifications => 'เปิดใช้งานการแจ้งเตือน';

  @override
  String invited(Object date) {
    return 'เชิญแล้ว';
  }

  @override
  String content(Object content) {
    return 'เนื้อหา';
  }

  @override
  String get meetingSharedSuccessfully => 'แชร์การประชุมสำเร็จ';

  @override
  String get welcomeToPlaytime => 'ยินดีต้อนรับสู่ Playtime';

  @override
  String get viewAll => 'ดูทั้งหมด';

  @override
  String get playtimeVirtual => 'Playtime เสมือน';

  @override
  String get staffScreenTBD => 'หน้าจอพนักงานยังไม่ได้กำหนด';

  @override
  String get cut => 'ตัด';

  @override
  String get inviteCancelledSuccessfully => 'ยกเลิกคำเชิญสำเร็จ';

  @override
  String get retry => 'ลองใหม่';

  @override
  String get composeBroadcastMessage => 'เขียนข้อความออกอากาศ';

  @override
  String get sendNow => 'ส่งตอนนี้';

  @override
  String get noGamesYet => 'ยังไม่มีเกม';

  @override
  String get select => 'เลือก';

  @override
  String get about => 'เกี่ยวกับ';

  @override
  String get choose => 'เลือก';

  @override
  String get profile => 'โปรไฟล์';

  @override
  String get removeChild => 'ลบลูก';

  @override
  String status(Object status) {
    return 'สถานะ';
  }

  @override
  String get logout => 'ออกจากระบบ';

  @override
  String get paste => 'วาง';

  @override
  String get welcome => 'ยินดีต้อนรับ';

  @override
  String get playtimeCreateSession => 'สร้างเซสชัน';

  @override
  String get familyMembers => 'สมาชิกในครอบครัว';

  @override
  String get upload => 'อัปโหลด';

  @override
  String get upcomingSessions => 'เซสชันที่กำลังจะมาถึง';

  @override
  String get enterGroupName => 'ป้อนชื่อกลุ่ม';

  @override
  String get confirm => 'ยืนยัน';

  @override
  String get playtimeLive => 'Playtime สด';

  @override
  String errorLoadingInvites(Object error) {
    return 'ข้อผิดพลาดในการโหลดคำเชิญ';
  }

  @override
  String get targetingFilters => 'ตัวกรองเป้าหมาย';

  @override
  String get pickVideo => 'เลือกวิดีโอ';

  @override
  String get playtimeGameDeleted => 'เกมถูกลบ';

  @override
  String get scheduleForLater => 'กำหนดสำหรับภายหลัง';

  @override
  String get accessRevokedSuccessfully => 'เพิกถอนสิทธิ์สำเร็จ';

  @override
  String get type => 'ประเภท';

  @override
  String get checkingPermissions => 'กำลังตรวจสอบสิทธิ์';

  @override
  String get copy => 'คัดลอก';

  @override
  String get yesCancel => 'ใช่ ยกเลิก';

  @override
  String get email => 'อีเมล';

  @override
  String get shareOnWhatsApp => 'แชร์ใน WhatsApp';

  @override
  String get notificationSettings => 'การตั้งค่าการแจ้งเตือน';

  @override
  String get myProfile => 'โปรไฟล์ของฉัน';

  @override
  String get revoke => 'เพิกถอน';

  @override
  String get noBroadcastMessages => 'ไม่มีข้อความออกอากาศ';

  @override
  String requestType(Object type) {
    return 'ประเภทคำขอ';
  }

  @override
  String get notifications => 'การแจ้งเตือน';

  @override
  String get details => 'รายละเอียด';

  @override
  String get cancelInvite => 'ยกเลิกคำเชิญ';

  @override
  String get createNew => 'สร้างใหม่';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get playtimeReject => 'ปฏิเสธ Playtime';

  @override
  String errorLoadingProfile(Object error) {
    return 'ข้อผิดพลาดในการโหลดโปรไฟล์';
  }

  @override
  String get edit => 'แก้ไข';

  @override
  String get add => 'เพิ่ม';

  @override
  String get playtimeGameApproved => 'เกมได้รับการอนุมัติ';

  @override
  String get forgotPassword => 'ลืมรหัสผ่าน?';

  @override
  String get familyDashboard => 'แดชบอร์ดครอบครัว';

  @override
  String get loading => 'กำลังโหลด';

  @override
  String get quickActions => 'การดำเนินการด่วน';

  @override
  String get playtimeTitle => 'ชื่อ Playtime';

  @override
  String get otpResentSuccessfully => 'ส่ง OTP ใหม่สำเร็จ';

  @override
  String errorCheckingPermissions(Object error) {
    return 'ข้อผิดพลาดในการตรวจสอบสิทธิ์';
  }

  @override
  String get clientScreenTBD => 'หน้าจอไคลเอนต์ยังไม่ได้กำหนด';

  @override
  String fcmToken(Object token) {
    return 'โทเค็น FCM';
  }

  @override
  String get pickImage => 'เลือกรูปภาพ';

  @override
  String get previous => 'ก่อนหน้า';

  @override
  String get noProfileFound => 'ไม่พบโปรไฟล์';

  @override
  String get noFamilyMembersYet => 'ยังไม่มีสมาชิกในครอบครัว';

  @override
  String get mediaOptional => 'สื่อ (ไม่บังคับ)';

  @override
  String get messageSavedSuccessfully => 'บันทึกข้อความสำเร็จ';

  @override
  String get scheduledFor => 'กำหนดสำหรับ';

  @override
  String get dashboard => 'แดชบอร์ด';

  @override
  String get noPermissionForBroadcast => 'ไม่มีสิทธิ์ออกอากาศ';

  @override
  String get playtimeAdminPanelTitle => 'ชื่อแผงผู้ดูแล Playtime';

  @override
  String get inviteDetail => 'รายละเอียดคำเชิญ';

  @override
  String scheduled(Object date) {
    return 'กำหนดเวลาแล้ว';
  }

  @override
  String failedToResendOtp(Object error) {
    return 'ไม่สามารถส่ง OTP ใหม่ได้';
  }

  @override
  String get scheduling => 'กำลังกำหนดเวลา';

  @override
  String errorSavingMessage(Object error) {
    return 'ข้อผิดพลาดในการบันทึกข้อความ';
  }

  @override
  String get save => 'บันทึก';

  @override
  String get playtimeApprove => 'อนุมัติ Playtime';

  @override
  String get createYourFirstSession => 'สร้างเซสชันแรกของคุณ';

  @override
  String get playtimeGameRejected => 'เกมถูกปฏิเสธ';

  @override
  String failedToRevokeAccess(Object error) {
    return 'ไม่สามารถเพิกถอนสิทธิ์ได้';
  }

  @override
  String get recentGames => 'เกมล่าสุด';

  @override
  String get customizeMessage => 'ปรับแต่งข้อความ';

  @override
  String failedToCancelInvite(Object error) {
    return 'ไม่สามารถยกเลิกคำเชิญได้';
  }

  @override
  String errorSendingMessage(Object error) {
    return 'ข้อผิดพลาดในการส่งข้อความ';
  }

  @override
  String get confirmPassword => 'ยืนยันรหัสผ่าน';

  @override
  String errorLoadingPrivacyRequests(Object error) {
    return 'ข้อผิดพลาดในการโหลดคำขอความเป็นส่วนตัว';
  }

  @override
  String get connectedChildren => 'เด็กที่เชื่อมต่อ';

  @override
  String get share => 'แชร์';

  @override
  String get playtimeEnterGameName => 'ป้อนชื่อเกม';

  @override
  String get pleaseLoginForFamilyFeatures =>
      'กรุณาเข้าสู่ระบบเพื่อเข้าถึงฟีเจอร์ครอบครัว';

  @override
  String get myInvites => 'คำเชิญของฉัน';

  @override
  String get createGame => 'สร้างเกม';

  @override
  String get groupNameOptional => 'ชื่อกลุ่ม (ไม่บังคับ)';

  @override
  String get playtimeNoSessions => 'ไม่พบเซสชัน Playtime';

  @override
  String get adminScreenTBD => 'หน้าจอผู้ดูแลจะมาเร็วๆ นี้';

  @override
  String get playtimeParentDashboardTitle => 'แดชบอร์ด Playtime';

  @override
  String get close => 'ปิด';

  @override
  String get knownGroupDetected => 'ตรวจพบกลุ่มที่รู้จัก';

  @override
  String get back => 'กลับ';

  @override
  String get playtimeChooseGame => 'เลือกเกม';

  @override
  String get managePermissions => 'จัดการสิทธิ์';

  @override
  String get pollOptions => 'ตัวเลือกการโหวต';

  @override
  String clicked(Object count) {
    return 'คลิกแล้ว';
  }

  @override
  String link(Object link) {
    return 'ลิงก์';
  }

  @override
  String get meetingReadyMessage => 'การประชุมของคุณพร้อมแล้ว! เข้าร่วมตอนนี้';

  @override
  String get pendingInvites => 'คำเชิญที่รอดำเนินการ';

  @override
  String statusColon(Object status) {
    return 'สถานะ:';
  }

  @override
  String get pleaseLoginToViewProfile => 'กรุณาเข้าสู่ระบบเพื่อดูโปรไฟล์';
}
