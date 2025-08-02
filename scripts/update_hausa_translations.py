#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import re

# Hausa translations provided by the user
hausa_translations = {
    "appTitle": "Appoint",
    "welcome": "Barka da zuwa",
    "home": "Farko",
    "menu": "Menu",
    "profile": "Bayani",
    "signOut": "Fice",
    "login": "Shiga",
    "email": "Imel",
    "password": "Kalmar wucewa",
    "signIn": "Shiga ciki",
    "bookMeeting": "Tanadi Taro",
    "bookAppointment": "Tanadi Haduwa",
    "bookingRequest": "Buƙatar tanadi",
    "confirmBooking": "Tabbatar da tanadi",
    "chatBooking": "Tanadi ta hira",
    "bookViaChat": "Tanadi ta hira",
    "submitBooking": "Miƙa tanadi",
    "next": "Gaba",
    "selectStaff": "Zaɓi ma'aikata",
    "pickDate": "Zaɓi Kwanan wata",
    "staff": "Ma'aikata",
    "service": "Sabis",
    "dateTime": "Kwanan wata & Lokaci",
    "duration": "Tsawon lokaci: {duration} minti",
    "notSelected": "Ba a zaɓi ba",
    "noSlots": "Babu wurare",
    "bookingConfirmed": "An tabbatar da tanadi",
    "failedToConfirmBooking": "An kasa tabbatar da tanadi",
    "noBookingsFound": "Ba a sami tanadi ba",
    "errorLoadingBookings": "Kuskure wajen ɗora tanadi: {error}",
    "shareOnWhatsApp": "Raba a WhatsApp",
    "shareMeetingInvitation": "Raba gayyatar taro:",
    "meetingReadyMessage": "An shirya taro! Kuna son a tura shi zuwa rukunin ku?",
    "customizeMessage": "Keɓance saƙonka...",
    "saveGroupForRecognition": "Ajiye rukuni don gane shi gaba",
    "groupNameOptional": "Sunan rukuni (zaɓi)",
    "enterGroupName": "Shigar da sunan rukuni don gane shi",
    "knownGroupDetected": "An sami sanannen rukuni",
    "meetingSharedSuccessfully": "An raba taron cikin nasara!",
    "bookingConfirmedShare": "An tabbatar da tanadi! Yanzu za ka iya raba gayyata.",
    "defaultShareMessage": "Sannu! Mun shirya taro tare da kai ta APP‑OINT. Danna nan don tabbatarwa ko ba da shawarar wata lokaci:",
    "dashboard": "Dashboard",
    "businessDashboard": "Dashboard na kasuwanci",
    "myProfile": "Bayana",
    "noProfileFound": "Ba a sami bayani ba",
    "errorLoadingProfile": "Kuskure wajen ɗora bayani",
    "myInvites": "Gayyatar da na samu",
    "inviteDetail": "Cikakken gayyata",
    "inviteContact": "Tuntuɓi gayyata",
    "noInvites": "Babu gayyata",
    "errorLoadingInvites": "Kuskure wajen ɗora gayyata",
    "accept": "Amince",
    "decline": "Kiɗe",
    "sendInvite": "Aika gayyata",
    "name": "Suna",
    "phoneNumber": "Lambar waya",
    "emailOptional": "Imel (zaɓi)",
    "requiresInstallFallback": "Yana buƙatar shigarwa",
    "notifications": "Sanarwa",
    "notificationSettings": "Saitunan sanarwa",
    "enableNotifications": "Kunna sanarwa",
    "errorFetchingToken": "Kuskure wajen samin token",
    "fcmToken": "FCM Token: {token}",
    "familyDashboard": "Dashboard na iyali",
    "pleaseLoginForFamilyFeatures": "Don Allah shiga don amfani da fasalolin iyali",
    "familyMembers": "'Yan uwa",
    "invite": "Gayyata",
    "pendingInvites": "Gayyata a tsaye",
    "connectedChildren": "Ɗalibai haɗe",
    "noFamilyMembersYet": "Babu membobin iyali tukuna. Aika gayyata don farawa!",
    "errorLoadingFamilyLinks": "Kuskure wajen ɗora alaƙar iyali: {error}",
    "inviteChild": "Gayyaci yaro",
    "managePermissions": "Sarrafa izini",
    "removeChild": "Cire yaro",
    "loading": "Ana ɗora...",
    "childEmail": "Imel ɗan yaro",
    "childEmailOrPhone": "Imel ko waya ɗan yaro",
    "enterChildEmail": "Shigar da imel ɗan yaro",
    "otpCode": "Lambar OTP",
    "enterOtp": "Shigar da OTP",
    "verify": "Tabbatar",
    "otpResentSuccessfully": "An sake aika OTP cikin nasara!",
    "failedToResendOtp": "An kasa sake aika OTP: {error}",
    "childLinkedSuccessfully": "An haɗa yaro cikin nasara!",
    "invitationSentSuccessfully": "An aika gayyata cikin nasara!",
    "failedToSendInvitation": "An kasa aikawa gayyata: {error}",
    "pleaseEnterValidEmail": "Da fatan a shigar da ingantaccen imel",
    "pleaseEnterValidEmailOrPhone": "Da fatan a shigar da ingantaccen imel ko waya",
    "invalidCode": "Lambar ba ta da inganci, sake gwadawa",
    "cancelInvite": "Soke gayyata",
    "cancelInviteConfirmation": "Kuna da tabbacin kuna son soke wannan gayyata?",
    "no": "A'a",
    "yesCancel": "Ee, a'aika",
    "inviteCancelledSuccessfully": "An soke gayyata cikin nasara!",
    "failedToCancelInvite": "An kasa soke gayyata: {error}",
    "revokeAccess": "Cire izini",
    "revokeAccessConfirmation": "Kuna da tabbacin cire izinin wannan yaron? Wannan aikin ba za a iya maida shi ba.",
    "revoke": "Cire",
    "accessRevokedSuccessfully": "An cire izini cikin nasara!",
    "failedToRevokeAccess": "An kasa cire izini: {error}",
    "grantConsent": "Ba da yarda",
    "revokeConsent": "Cire yarda",
    "consentGrantedSuccessfully": "An ba da yarda cikin nasara!",
    "consentRevokedSuccessfully": "An cire yarda cikin nasara!",
    "failedToUpdateConsent": "An kasa sabunta yarda: {error}",
    "checkingPermissions": "Ana duba izini...",
    "cancel": "Sokewa",
    "close": "Rufe",
    "save": "Ajiye",
    "sendNow": "Aika yanzu",
    "details": "Cikakkun bayanai",
    "noBroadcastMessages": "Babu saƙonnin faɗaɗa tukuna",
    "errorCheckingPermissions": "Kuskure wajen duba izini: {error}",
    "mediaOptional": "Kafofi (zaɓi)",
    "pickImage": "Zaɓi hoto",
    "pickVideo": "Zaɓi bidiyo",
    "pollOptions": "Zaɓuɓɓuka:",
    "targetingFilters": "Matattarar manufa",
    "scheduling": "Jadawalin lokaci",
    "scheduleForLater": "Saita zuwa gaba",
    "errorEstimatingRecipients": "Kuskure wajen hasashen masu karɓa: {error}",
    "errorPickingImage": "Kuskure wajen zaɓar hoto: {error}",
    "errorPickingVideo": "Kuskure wajen zaɓar bidiyo: {error}",
    "noPermissionForBroadcast": "Ba ku da izini don ƙirƙirar saƙonnin faɗaɗa.",
    "messageSavedSuccessfully": "Saƙon an ajiye cikin nasara",
    "errorSavingMessage": "Kuskure wajen ajiye saƙo: {error}",
    "messageSentSuccessfully": "Saƙon an aika cikin nasara",
    "errorSendingMessage": "Kuskure wajen aika saƙo: {error}",
    "content": "Abun ciki: {content}",
    "type": "Nau'i: {type}",
    "link": "Haɗi: {link}",
    "status": "Matsayi: {status}",
    "recipients": "Masu karɓa: {count}",
    "opened": "An buɗe: {count}",
    "clicked": "An danna: {count}",
    "created": "An ƙirƙira: {date}",
    "scheduled": "An tsara: {date}",
    "organizations": "Ƙungiyoyi",
    "noOrganizations": "Babu ƙungiyoyi",
    "errorLoadingOrganizations": "Kuskure wajen ɗora ƙungiyoyi",
    "members": "mambobi: {count}",
    "users": "Masu amfani",
    "noUsers": "Babu masu amfani",
    "errorLoadingUsers": "Kuskure wajen ɗora masu amfani",
    "changeRole": "Canza matsayi",
    "totalAppointments": "Jimlar haduwa",
    "completedAppointments": "An kammala haduwa",
    "revenue": "Kudaden shiga",
    "errorLoadingStats": "Kuskure wajen ɗora ƙididdiga",
    "appointment": "Haduwa: {id}",
    "from": "Daga: {name}",
    "phone": "Waya: {number}",
    "noRouteDefined": "Ba a ƙayyade hanya ba don {route}",
    "meetingDetails": "Cikakken bayani game da taro",
    "meetingId": "ID na taro: {id}",
    "creator": "Mai ƙirƙira: {id}",
    "context": "Mahallin: {id}",
    "group": "Rukuni: {id}",
    "requestPrivateSession": "Buƙaci zaman sirri",
    "privacyRequestSent": "An aika buƙatar sirri zuwa iyaye!",
    "failedToSendPrivacyRequest": "An kasa aika buƙatar sirri: {error}",
    "errorLoadingPrivacyRequests": "Kuskure wajen ɗora buƙatun sirri: {error}",
    "requestType": "Buƙatar {type}",
    "statusColon": "Matsayi: {status}",
    "failedToActionPrivacyRequest": "An kasa {action} buƙatar sirri: {error}",
    "yes": "I",
    "send": "Aika",
    "permissions": "Izini",
    "permissionsFor": "Izini – {childId}",
    "errorLoadingPermissions": "Kuskure wajen ɗora izini: {error}",
    "none": "Babu",
    "readOnly": "Karatu kawai",
    "readWrite": "Karatu & rubutu",
    "permissionUpdated": "An sabunta izini {category} zuwa {newValue}",
    "failedToUpdatePermission": "An kasa sabunta izini: {error}",
    "invited": "An gayyace: {date}",
    "adminBroadcast": "Faɗaɗa mai kulawa",
    "composeBroadcastMessage": "Rubuta saƙon faɗaɗa",
    "adminScreenTBD": "Fuskar mai kulawa – A ci gaba",
    "staffScreenTBD": "Fuskar ma'aikata – A ci gaba",
    "clientScreenTBD": "Fuskar abokin ciniki – A ci gaba"
}

def update_hausa_file():
    """Update the Hausa ARB file with the new translations"""
    
    # Read the current Hausa file
    with open('lib/l10n/app_ha.arb', 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Parse the JSON content
    try:
        data = json.loads(content)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON: {e}")
        return
    
    # Update translations
    updated_count = 0
    for key, hausa_text in hausa_translations.items():
        if key in data:
            old_value = data[key]
            data[key] = hausa_text
            if old_value != hausa_text:
                updated_count += 1
                print(f"Updated: {key} = {hausa_text}")
        else:
            print(f"Warning: Key '{key}' not found in the file")
    
    # Write back to file
    with open('lib/l10n/app_ha.arb', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"\n✅ Successfully updated {updated_count} translations in app_ha.arb")
    print("📝 File has been saved with proper UTF-8 encoding")

if __name__ == "__main__":
    print("🔧 Updating Hausa translations...")
    update_hausa_file()
    print("\n✅ Hausa translation update completed!") 