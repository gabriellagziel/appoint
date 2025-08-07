#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import re

# Urdu translations provided by the user
urdu_translations = {
    "appTitle": "Appoint",
    "welcome": "خوش آمدید",
    "home": "ہوم",
    "menu": "مینو",
    "profile": "پروفائل",
    "signOut": "سائن آؤٹ",
    "login": "لاگ ان",
    "email": "ای میل",
    "password": "پاس ورڈ",
    "signIn": "سائن ان کریں",
    "bookMeeting": "ملاقات بُک کریں",
    "bookAppointment": "وقت بُک کریں",
    "bookingRequest": "بُکنگ کی درخواست",
    "confirmBooking": "بُکنگ کی تصدیق کریں",
    "chatBooking": "چیٹ بُکنگ",
    "bookViaChat": "چیٹ کے ذریعے بُک کریں",
    "submitBooking": "بُکنگ جمع کروائیں",
    "next": "اگلا",
    "selectStaff": "اسٹاف منتخب کریں",
    "pickDate": "تاریخ منتخب کریں",
    "staff": "اسٹاف",
    "service": "سروس",
    "dateTime": "تاریخ اور وقت",
    "duration": "دورانیہ: {duration} منٹ",
    "notSelected": "منتخب نہیں ہوا",
    "noSlots": "کوئی دستیاب وقت نہیں",
    "bookingConfirmed": "بُکنگ کی تصدیق ہو گئی ہے",
    "failedToConfirmBooking": "بُکنگ کی تصدیق ناکام رہی",
    "noBookingsFound": "کوئی بُکنگ نہیں ملی",
    "errorLoadingBookings": "بُکنگ لوڈ کرنے میں خرابی: {error}",
    "shareOnWhatsApp": "واٹس ایپ پر شیئر کریں",
    "shareMeetingInvitation": "اپنی ملاقات کی دعوت شیئر کریں:",
    "meetingReadyMessage": "ملاقات تیار ہے! کیا آپ اسے اپنے گروپ کو بھیجنا چاہتے ہیں؟",
    "customizeMessage": "اپنا پیغام حسبِ ضرورت بنائیں...",
    "saveGroupForRecognition": "گروپ کو شناخت کے لیے محفوظ کریں",
    "groupNameOptional": "گروپ کا نام (اختیاری)",
    "enterGroupName": "شناخت کے لیے گروپ کا نام درج کریں",
    "knownGroupDetected": "معروف گروپ شناخت ہو گیا",
    "meetingSharedSuccessfully": "ملاقات کامیابی سے شیئر کی گئی!",
    "bookingConfirmedShare": "بُکنگ کی تصدیق ہو گئی! اب آپ دعوت شیئر کر سکتے ہیں۔",
    "defaultShareMessage": "ہیلو! میں نے APP-OINT کے ذریعے آپ کے ساتھ ملاقات شیڈول کی ہے۔ تصدیق کرنے یا دوسرا وقت تجویز کرنے کے لیے یہاں کلک کریں:",
    "dashboard": "ڈیش بورڈ",
    "businessDashboard": "کاروباری ڈیش بورڈ",
    "myProfile": "میری پروفائل",
    "noProfileFound": "کوئی پروفائل نہیں ملی",
    "errorLoadingProfile": "پروفائل لوڈ کرنے میں خرابی",
    "myInvites": "میرے دعوت نامے",
    "inviteDetail": "دعوت کی تفصیل",
    "inviteContact": "رابطہ دعوت دیں",
    "noInvites": "کوئی دعوت نہیں",
    "errorLoadingInvites": "دعوت نامے لوڈ کرنے میں خرابی",
    "accept": "قبول کریں",
    "decline": "مسترد کریں",
    "sendInvite": "دعوت بھیجیں",
    "name": "نام",
    "phoneNumber": "فون نمبر",
    "emailOptional": "ای میل (اختیاری)",
    "requiresInstallFallback": "انسٹالیشن درکار ہے",
    "notifications": "اطلاعات",
    "notificationSettings": "اطلاع کی ترتیبات",
    "enableNotifications": "اطلاعات فعال کریں",
    "errorFetchingToken": "ٹوکن حاصل کرنے میں خرابی",
    "fcmToken": "ایف سی ایم ٹوکن: {token}",
    "familyDashboard": "فیملی ڈیش بورڈ",
    "pleaseLoginForFamilyFeatures": "خاندانی خصوصیات کے لیے براہ کرم لاگ ان کریں",
    "familyMembers": "خاندان کے افراد",
    "invite": "دعوت دیں",
    "pendingInvites": "زیر التواء دعوتیں",
    "connectedChildren": "منسلک بچے",
    "noFamilyMembersYet": "ابھی تک کوئی خاندانی رکن نہیں۔ شروع کرنے کے لیے کسی کو مدعو کریں!",
    "errorLoadingFamilyLinks": "خاندانی روابط لوڈ کرنے میں خرابی: {error}",
    "inviteChild": "بچے کو دعوت دیں",
    "managePermissions": "اجازتوں کا نظم کریں",
    "removeChild": "بچے کو ہٹائیں",
    "loading": "لوڈ ہو رہا ہے...",
    "childEmail": "بچے کا ای میل",
    "childEmailOrPhone": "بچے کا ای میل یا فون",
    "enterChildEmail": "بچے کا ای میل درج کریں",
    "otpCode": "او ٹی پی کوڈ",
    "enterOtp": "او ٹی پی درج کریں",
    "verify": "تصدیق کریں",
    "otpResentSuccessfully": "او ٹی پی کامیابی سے دوبارہ بھیجا گیا!",
    "failedToResendOtp": "او ٹی پی دوبارہ بھیجنے میں ناکامی: {error}",
    "childLinkedSuccessfully": "بچہ کامیابی سے منسلک ہو گیا!",
    "invitationSentSuccessfully": "دعوت کامیابی سے بھیج دی گئی!",
    "failedToSendInvitation": "دعوت بھیجنے میں ناکامی: {error}",
    "pleaseEnterValidEmail": "براہ کرم درست ای میل درج کریں",
    "pleaseEnterValidEmailOrPhone": "براہ کرم درست ای میل یا فون نمبر درج کریں",
    "invalidCode": "غلط کوڈ، دوبارہ کوشش کریں",
    "cancelInvite": "دعوت منسوخ کریں",
    "cancelInviteConfirmation": "کیا آپ واقعی اس دعوت کو منسوخ کرنا چاہتے ہیں؟",
    "no": "نہیں",
    "yesCancel": "ہاں، منسوخ کریں",
    "inviteCancelledSuccessfully": "دعوت کامیابی سے منسوخ ہو گئی!",
    "failedToCancelInvite": "دعوت منسوخ کرنے میں ناکامی: {error}",
    "revokeAccess": "رسائی منسوخ کریں",
    "revokeAccessConfirmation": "کیا آپ واقعی اس بچے کی رسائی منسوخ کرنا چاہتے ہیں؟ یہ عمل ناقابل واپسی ہے۔",
    "revoke": "منسوخ کریں",
    "accessRevokedSuccessfully": "رسائی کامیابی سے منسوخ ہو گئی!",
    "failedToRevokeAccess": "رسائی منسوخ کرنے میں ناکامی: {error}",
    "grantConsent": "اجازت دیں",
    "revokeConsent": "اجازت واپس لیں",
    "consentGrantedSuccessfully": "اجازت کامیابی سے دی گئی!",
    "consentRevokedSuccessfully": "اجازت کامیابی سے واپس لے لی گئی!",
    "failedToUpdateConsent": "اجازت کو اپ ڈیٹ کرنے میں ناکامی: {error}",
    "checkingPermissions": "اجازتیں چیک کی جا رہی ہیں...",
    "cancel": "منسوخ کریں",
    "close": "بند کریں",
    "save": "محفوظ کریں",
    "sendNow": "ابھی بھیجیں",
    "details": "تفصیلات",
    "noBroadcastMessages": "ابھی تک کوئی نشریاتی پیغام نہیں",
    "errorCheckingPermissions": "اجازتیں چیک کرنے میں خرابی: {error}",
    "mediaOptional": "میڈیا (اختیاری)",
    "pickImage": "تصویر منتخب کریں",
    "pickVideo": "ویڈیو منتخب کریں",
    "pollOptions": "پول آپشنز:",
    "targetingFilters": "ہدف سازی کے فلٹرز",
    "scheduling": "شیڈولنگ",
    "scheduleForLater": "بعد میں شیڈول کریں",
    "errorEstimatingRecipients": "وصول کنندگان کا اندازہ لگانے میں خرابی: {error}",
    "errorPickingImage": "تصویر منتخب کرنے میں خرابی: {error}",
    "errorPickingVideo": "ویڈیو منتخب کرنے میں خرابی: {error}",
    "noPermissionForBroadcast": "آپ کو نشریاتی پیغامات بنانے کی اجازت نہیں ہے۔",
    "messageSavedSuccessfully": "پیغام کامیابی سے محفوظ ہو گیا",
    "errorSavingMessage": "پیغام محفوظ کرنے میں خرابی: {error}",
    "messageSentSuccessfully": "پیغام کامیابی سے بھیجا گیا",
    "errorSendingMessage": "پیغام بھیجنے میں خرابی: {error}",
    "content": "مواد: {content}",
    "type": "قسم: {type}",
    "link": "لنک: {link}",
    "status": "حیثیت: {status}",
    "recipients": "وصول کنندگان: {count}",
    "opened": "کھولا گیا: {count}",
    "clicked": "کلک کیا گیا: {count}",
    "created": "بنایا گیا: {date}",
    "scheduled": "شیڈول: {date}",
    "organizations": "تنظیمیں",
    "noOrganizations": "کوئی تنظیم نہیں",
    "errorLoadingOrganizations": "تنظیمیں لوڈ کرنے میں خرابی",
    "members": "{count} اراکین",
    "users": "صارفین",
    "noUsers": "کوئی صارف نہیں",
    "errorLoadingUsers": "صارفین لوڈ کرنے میں خرابی",
    "changeRole": "کردار تبدیل کریں",
    "totalAppointments": "کل ملاقاتیں",
    "completedAppointments": "مکمل ملاقاتیں",
    "revenue": "آمدنی",
    "errorLoadingStats": "اعدادوشمار لوڈ کرنے میں خرابی",
    "appointment": "ملاقات: {id}",
    "from": "سے: {name}",
    "phone": "فون: {number}",
    "noRouteDefined": "{route} کے لیے کوئی راستہ متعین نہیں",
    "meetingDetails": "ملاقات کی تفصیلات",
    "meetingId": "ملاقات کی شناخت: {id}",
    "creator": "تخلیق کار: {id}",
    "context": "سیاق و سباق: {id}",
    "group": "گروپ: {id}",
    "requestPrivateSession": "نجی سیشن کی درخواست کریں",
    "privacyRequestSent": "نجی سیشن کی درخواست والدین کو بھیج دی گئی!",
    "failedToSendPrivacyRequest": "نجی درخواست بھیجنے میں ناکامی: {error}",
    "errorLoadingPrivacyRequests": "پرائیویسی درخواستیں لوڈ کرنے میں خرابی: {error}",
    "requestType": "{type} درخواست",
    "statusColon": "حیثیت: {status}",
    "failedToActionPrivacyRequest": "{action} پرائیویسی درخواست پر عملدرآمد میں ناکامی: {error}",
    "yes": "جی ہاں",
    "send": "بھیجیں",
    "permissions": "اجازتیں",
    "permissionsFor": "اجازتیں - {childId}",
    "errorLoadingPermissions": "اجازتیں لوڈ کرنے میں خرابی: {error}",
    "none": "کوئی نہیں",
    "readOnly": "صرف پڑھنے کے لیے",
    "readWrite": "پڑھنے اور لکھنے کی اجازت",
    "permissionUpdated": "اجازت {category} کو {newValue} پر اپ ڈیٹ کیا گیا",
    "failedToUpdatePermission": "اجازت کو اپ ڈیٹ کرنے میں ناکامی: {error}",
    "invited": "مدعو: {date}",
    "adminBroadcast": "ایڈمن نشریات",
    "composeBroadcastMessage": "نشریاتی پیغام لکھیں",
    "adminScreenTBD": "ایڈمن اسکرین - تیار ہونا باقی ہے",
    "staffScreenTBD": "اسٹاف اسکرین - تیار ہونا باقی ہے",
    "clientScreenTBD": "کلائنٹ اسکرین - تیار ہونا باقی ہے"
}

def update_urdu_file():
    """Update the Urdu ARB file with the new translations"""
    
    # Read the current Urdu file
    with open('lib/l10n/app_ur.arb', 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Parse the JSON content
    try:
        data = json.loads(content)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON: {e}")
        return
    
    # Update translations
    updated_count = 0
    for key, urdu_text in urdu_translations.items():
        if key in data:
            old_value = data[key]
            data[key] = urdu_text
            if old_value != urdu_text:
                updated_count += 1
                print(f"Updated: {key} = {urdu_text}")
        else:
            print(f"Warning: Key '{key}' not found in the file")
    
    # Write back to file
    with open('lib/l10n/app_ur.arb', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"\n✅ Successfully updated {updated_count} translations in app_ur.arb")
    print("📝 File has been saved with proper UTF-8 encoding")

if __name__ == "__main__":
    print("🔧 Updating Urdu translations...")
    update_urdu_file()
    print("\n✅ Urdu translation update completed!") 