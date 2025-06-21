#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import re

# Persian translations provided by the user
persian_translations = {
    "appTitle": "Appoint",
    "welcome": "خوش آمدید",
    "home": "خانه",
    "menu": "منو",
    "profile": "پروفایل",
    "signOut": "خروج",
    "login": "ورود",
    "email": "ایمیل",
    "password": "رمز عبور",
    "signIn": "ورود به سیستم",
    "bookMeeting": "رزرو جلسه",
    "bookAppointment": "رزرو نوبت",
    "bookingRequest": "درخواست رزرو",
    "confirmBooking": "تأیید رزرو",
    "chatBooking": "رزرو از طریق چت",
    "bookViaChat": "رزرو با چت",
    "submitBooking": "ارسال رزرو",
    "next": "بعدی",
    "selectStaff": "انتخاب کارمند",
    "pickDate": "انتخاب تاریخ",
    "staff": "کارکنان",
    "service": "خدمت",
    "dateTime": "تاریخ و زمان",
    "duration": "مدت زمان: {duration} دقیقه",
    "notSelected": "انتخاب نشده",
    "noSlots": "وقت خالی موجود نیست",
    "bookingConfirmed": "رزرو تأیید شد",
    "failedToConfirmBooking": "تأیید رزرو با شکست مواجه شد",
    "noBookingsFound": "هیچ رزروی یافت نشد",
    "errorLoadingBookings": "خطا در بارگذاری رزروها: {error}",
    "shareOnWhatsApp": "اشتراک‌گذاری در واتساپ",
    "shareMeetingInvitation": "اشتراک‌گذاری دعوت جلسه:",
    "meetingReadyMessage": "جلسه آماده است! می‌خواهید آن را برای گروه ارسال کنید؟",
    "customizeMessage": "پیام خود را سفارشی کنید...",
    "saveGroupForRecognition": "ذخیره گروه برای شناسایی در آینده",
    "groupNameOptional": "نام گروه (اختیاری)",
    "enterGroupName": "نام گروه را وارد کنید برای شناسایی",
    "knownGroupDetected": "گروه شناخته‌شده شناسایی شد",
    "meetingSharedSuccessfully": "جلسه با موفقیت به اشتراک گذاشته شد!",
    "bookingConfirmedShare": "رزرو تأیید شد! اکنون می‌توانید دعوت را به اشتراک بگذارید.",
    "defaultShareMessage": "سلام! من یک جلسه با شما از طریق APP-OINT برنامه‌ریزی کرده‌ام. برای تأیید یا پیشنهاد زمان دیگر کلیک کنید:",
    "dashboard": "داشبورد",
    "businessDashboard": "داشبورد کسب‌وکار",
    "myProfile": "پروفایل من",
    "noProfileFound": "پروفایلی یافت نشد",
    "errorLoadingProfile": "خطا در بارگذاری پروفایل",
    "myInvites": "دعوت‌نامه‌های من",
    "inviteDetail": "جزئیات دعوت",
    "inviteContact": "تماس دعوت",
    "noInvites": "دعوتی موجود نیست",
    "errorLoadingInvites": "خطا در بارگذاری دعوت‌ها",
    "accept": "پذیرش",
    "decline": "رد کردن",
    "sendInvite": "ارسال دعوت",
    "name": "نام",
    "phoneNumber": "شماره تلفن",
    "emailOptional": "ایمیل (اختیاری)",
    "requiresInstallFallback": "نیاز به نصب دارد",
    "notifications": "اعلان‌ها",
    "notificationSettings": "تنظیمات اعلان",
    "enableNotifications": "فعال‌سازی اعلان‌ها",
    "errorFetchingToken": "خطا در دریافت توکن",
    "fcmToken": "توکن FCM: {token}",
    "familyDashboard": "داشبورد خانواده",
    "pleaseLoginForFamilyFeatures": "برای استفاده از قابلیت‌های خانوادگی وارد شوید",
    "familyMembers": "اعضای خانواده",
    "invite": "دعوت",
    "pendingInvites": "دعوت‌های در انتظار",
    "connectedChildren": "کودکان متصل شده",
    "noFamilyMembersYet": "هنوز هیچ عضو خانواده‌ای اضافه نشده است. برای شروع کسی را دعوت کنید!",
    "errorLoadingFamilyLinks": "خطا در بارگذاری ارتباطات خانوادگی: {error}",
    "inviteChild": "دعوت کودک",
    "managePermissions": "مدیریت دسترسی‌ها",
    "removeChild": "حذف کودک",
    "loading": "در حال بارگذاری...",
    "childEmail": "ایمیل کودک",
    "childEmailOrPhone": "ایمیل یا تلفن کودک",
    "enterChildEmail": "ایمیل کودک را وارد کنید",
    "otpCode": "کد OTP",
    "enterOtp": "کد OTP را وارد کنید",
    "verify": "تأیید",
    "otpResentSuccessfully": "کد OTP با موفقیت دوباره ارسال شد!",
    "failedToResendOtp": "ارسال مجدد OTP با شکست مواجه شد: {error}",
    "childLinkedSuccessfully": "کودک با موفقیت متصل شد!",
    "invitationSentSuccessfully": "دعوت‌نامه با موفقیت ارسال شد!",
    "failedToSendInvitation": "ارسال دعوت‌نامه با شکست مواجه شد: {error}",
    "pleaseEnterValidEmail": "لطفاً یک ایمیل معتبر وارد کنید",
    "pleaseEnterValidEmailOrPhone": "لطفاً ایمیل یا شماره تلفن معتبر وارد کنید",
    "invalidCode": "کد نامعتبر است، دوباره امتحان کنید",
    "cancelInvite": "لغو دعوت",
    "cancelInviteConfirmation": "آیا مطمئن هستید که می‌خواهید این دعوت را لغو کنید؟",
    "no": "خیر",
    "yesCancel": "بله، لغو",
    "inviteCancelledSuccessfully": "دعوت با موفقیت لغو شد!",
    "failedToCancelInvite": "لغو دعوت با شکست مواجه شد: {error}",
    "revokeAccess": "لغو دسترسی",
    "revokeAccessConfirmation": "آیا مطمئن هستید که می‌خواهید دسترسی این کودک را لغو کنید؟ این عمل قابل بازگشت نیست.",
    "revoke": "لغو",
    "accessRevokedSuccessfully": "دسترسی با موفقیت لغو شد!",
    "failedToRevokeAccess": "لغو دسترسی با شکست مواجه شد: {error}",
    "grantConsent": "اعطای رضایت",
    "revokeConsent": "لغو رضایت",
    "consentGrantedSuccessfully": "رضایت با موفقیت اعطا شد!",
    "consentRevokedSuccessfully": "رضایت با موفقیت لغو شد!",
    "failedToUpdateConsent": "به‌روزرسانی رضایت با شکست مواجه شد: {error}",
    "checkingPermissions": "در حال بررسی مجوزها...",
    "cancel": "لغو",
    "close": "بستن",
    "save": "ذخیره",
    "sendNow": "ارسال اکنون",
    "details": "جزئیات",
    "noBroadcastMessages": "هنوز پیامی برای پخش وجود ندارد",
    "errorCheckingPermissions": "خطا در بررسی دسترسی‌ها: {error}",
    "mediaOptional": "رسانه (اختیاری)",
    "pickImage": "انتخاب تصویر",
    "pickVideo": "انتخاب ویدئو",
    "pollOptions": "گزینه‌های نظرسنجی:",
    "targetingFilters": "فیلترهای هدف‌گذاری",
    "scheduling": "زمان‌بندی",
    "scheduleForLater": "برنامه‌ریزی برای بعد",
    "errorEstimatingRecipients": "خطا در برآورد گیرندگان: {error}",
    "errorPickingImage": "خطا در انتخاب تصویر: {error}",
    "errorPickingVideo": "خطا در انتخاب ویدئو: {error}",
    "noPermissionForBroadcast": "شما مجاز به ایجاد پیام‌های پخش نیستید.",
    "messageSavedSuccessfully": "پیام با موفقیت ذخیره شد",
    "errorSavingMessage": "خطا در ذخیره پیام: {error}",
    "messageSentSuccessfully": "پیام با موفقیت ارسال شد",
    "errorSendingMessage": "خطا در ارسال پیام: {error}",
    "content": "محتوا: {content}",
    "type": "نوع: {type}",
    "link": "لینک: {link}",
    "status": "وضعیت: {status}",
    "recipients": "گیرندگان: {count}",
    "opened": "باز شده: {count}",
    "clicked": "کلیک شده: {count}",
    "created": "ایجاد شده: {date}",
    "scheduled": "زمان‌بندی شده: {date}",
    "organizations": "سازمان‌ها",
    "noOrganizations": "هیچ سازمانی وجود ندارد",
    "errorLoadingOrganizations": "خطا در بارگذاری سازمان‌ها",
    "members": "{count} عضو",
    "users": "کاربران",
    "noUsers": "کاربری وجود ندارد",
    "errorLoadingUsers": "خطا در بارگذاری کاربران",
    "changeRole": "تغییر نقش",
    "totalAppointments": "مجموع نوبت‌ها",
    "completedAppointments": "نوبت‌های تکمیل‌شده",
    "revenue": "درآمد",
    "errorLoadingStats": "خطا در بارگذاری آمار",
    "appointment": "نوبت: {id}",
    "from": "از: {name}",
    "phone": "تلفن: {number}",
    "noRouteDefined": "مسیری برای {route} تعریف نشده است",
    "meetingDetails": "جزئیات جلسه",
    "meetingId": "شناسه جلسه: {id}",
    "creator": "سازنده: {id}",
    "context": "زمینه: {id}",
    "group": "گروه: {id}",
    "requestPrivateSession": "درخواست جلسه خصوصی",
    "privacyRequestSent": "درخواست حریم خصوصی به والدین شما ارسال شد!",
    "failedToSendPrivacyRequest": "ارسال درخواست حریم خصوصی با شکست مواجه شد: {error}",
    "errorLoadingPrivacyRequests": "خطا در بارگذاری درخواست‌های حریم خصوصی: {error}",
    "requestType": "درخواست {type}",
    "statusColon": "وضعیت: {status}",
    "failedToActionPrivacyRequest": "انجام {action} درخواست حریم خصوصی با شکست مواجه شد: {error}",
    "yes": "بله",
    "send": "ارسال",
    "permissions": "دسترسی‌ها",
    "permissionsFor": "دسترسی‌ها - {childId}",
    "errorLoadingPermissions": "خطا در بارگذاری دسترسی‌ها: {error}",
    "none": "هیچ‌کدام",
    "readOnly": "فقط خواندنی",
    "readWrite": "خواندن و نوشتن",
    "permissionUpdated": "دسترسی {category} به {newValue} به‌روزرسانی شد",
    "failedToUpdatePermission": "به‌روزرسانی دسترسی با شکست مواجه شد: {error}",
    "invited": "دعوت‌شده: {date}",
    "adminBroadcast": "پخش ادمین",
    "composeBroadcastMessage": "نگارش پیام پخش",
    "adminScreenTBD": "صفحه مدیر - در حال توسعه",
    "staffScreenTBD": "صفحه کارکنان - در حال توسعه",
    "clientScreenTBD": "صفحه مشتری - در حال توسعه"
}

def update_persian_file():
    """Update the Persian ARB file with the new translations"""
    
    # Read the current Persian file
    with open('lib/l10n/app_fa.arb', 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Parse the JSON content
    try:
        data = json.loads(content)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON: {e}")
        return
    
    # Update translations
    updated_count = 0
    for key, persian_text in persian_translations.items():
        if key in data:
            old_value = data[key]
            data[key] = persian_text
            if old_value != persian_text:
                updated_count += 1
                print(f"Updated: {key} = {persian_text}")
        else:
            print(f"Warning: Key '{key}' not found in the file")
    
    # Write back to file
    with open('lib/l10n/app_fa.arb', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"\n✅ Successfully updated {updated_count} translations in app_fa.arb")
    print("📝 File has been saved with proper UTF-8 encoding")

if __name__ == "__main__":
    print("🔧 Updating Persian translations...")
    update_persian_file()
    print("\n✅ Persian translation update completed!") 