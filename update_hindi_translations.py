#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import re

# Hindi translations provided by the user
hindi_translations = {
    "appTitle": "Appoint",
    "welcome": "स्वागत है",
    "home": "होम",
    "menu": "मेनू",
    "profile": "प्रोफ़ाइल",
    "signOut": "साइन आउट",
    "login": "लॉगिन",
    "email": "ईमेल",
    "password": "पासवर्ड",
    "signIn": "साइन इन",
    "bookMeeting": "मीटिंग बुक करें",
    "bookAppointment": "अपॉइंटमेंट बुक करें",
    "bookingRequest": "बुकिंग अनुरोध",
    "confirmBooking": "बुकिंग की पुष्टि करें",
    "chatBooking": "चैट बुकिंग",
    "bookViaChat": "चैट के माध्यम से बुक करें",
    "submitBooking": "बुकिंग सबमिट करें",
    "next": "अगला",
    "selectStaff": "स्टाफ चुनें",
    "pickDate": "तारीख चुनें",
    "staff": "स्टाफ",
    "service": "सेवा",
    "dateTime": "दिनांक और समय",
    "duration": "अवधि: {duration} मिनट",
    "notSelected": "चयन नहीं किया गया",
    "noSlots": "कोई स्लॉट उपलब्ध नहीं",
    "bookingConfirmed": "बुकिंग की पुष्टि हो गई",
    "failedToConfirmBooking": "बुकिंग की पुष्टि विफल रही",
    "noBookingsFound": "कोई बुकिंग नहीं मिली",
    "errorLoadingBookings": "बुकिंग लोड करने में त्रुटि: {error}",
    "shareOnWhatsApp": "व्हाट्सएप पर साझा करें",
    "shareMeetingInvitation": "अपनी मीटिंग निमंत्रण साझा करें:",
    "meetingReadyMessage": "मीटिंग तैयार है! क्या आप इसे अपने समूह को भेजना चाहते हैं?",
    "customizeMessage": "अपना संदेश अनुकूलित करें...",
    "saveGroupForRecognition": "भविष्य की पहचान के लिए समूह सहेजें",
    "groupNameOptional": "समूह का नाम (वैकल्पिक)",
    "enterGroupName": "पहचान के लिए समूह का नाम दर्ज करें",
    "knownGroupDetected": "ज्ञात समूह पाया गया",
    "meetingSharedSuccessfully": "मीटिंग सफलतापूर्वक साझा की गई!",
    "bookingConfirmedShare": "बुकिंग की पुष्टि हो गई! अब आप निमंत्रण साझा कर सकते हैं।",
    "defaultShareMessage": "हाय! मैंने APP-OINT के माध्यम से आपके साथ एक मीटिंग शेड्यूल की है। पुष्टि करने या अन्य समय सुझाने के लिए यहां क्लिक करें:",
    "dashboard": "डैशबोर्ड",
    "businessDashboard": "व्यापार डैशबोर्ड",
    "myProfile": "मेरी प्रोफ़ाइल",
    "noProfileFound": "कोई प्रोफ़ाइल नहीं मिली",
    "errorLoadingProfile": "प्रोफ़ाइल लोड करने में त्रुटि",
    "myInvites": "मेरे निमंत्रण",
    "inviteDetail": "निमंत्रण विवरण",
    "inviteContact": "संपर्क को आमंत्रित करें",
    "noInvites": "कोई निमंत्रण नहीं",
    "errorLoadingInvites": "निमंत्रण लोड करने में त्रुटि",
    "accept": "स्वीकार करें",
    "decline": "अस्वीकार करें",
    "sendInvite": "निमंत्रण भेजें",
    "name": "नाम",
    "phoneNumber": "फ़ोन नंबर",
    "emailOptional": "ईमेल (वैकल्पिक)",
    "requiresInstallFallback": "स्थापना की आवश्यकता है",
    "notifications": "सूचनाएं",
    "notificationSettings": "अधिसूचना सेटिंग्स",
    "enableNotifications": "सूचनाएं सक्षम करें",
    "errorFetchingToken": "टोकन प्राप्त करने में त्रुटि",
    "fcmToken": "FCM टोकन: {token}",
    "familyDashboard": "पारिवारिक डैशबोर्ड",
    "pleaseLoginForFamilyFeatures": "पारिवारिक सुविधाओं के लिए कृपया लॉगिन करें",
    "familyMembers": "परिवार के सदस्य",
    "invite": "आमंत्रित करें",
    "pendingInvites": "लंबित निमंत्रण",
    "connectedChildren": "जुड़े हुए बच्चे",
    "noFamilyMembersYet": "अभी तक कोई परिवार सदस्य नहीं है। शुरू करने के लिए किसी को आमंत्रित करें!",
    "errorLoadingFamilyLinks": "पारिवारिक लिंक लोड करने में त्रुटि: {error}",
    "inviteChild": "बच्चे को आमंत्रित करें",
    "managePermissions": "अनुमतियाँ प्रबंधित करें",
    "removeChild": "बच्चे को हटाएं",
    "loading": "लोड हो रहा है...",
    "childEmail": "बच्चे का ईमेल",
    "childEmailOrPhone": "बच्चे का ईमेल या फ़ोन",
    "enterChildEmail": "बच्चे का ईमेल दर्ज करें",
    "otpCode": "ओटीपी कोड",
    "enterOtp": "ओटीपी दर्ज करें",
    "verify": "सत्यापित करें",
    "otpResentSuccessfully": "ओटीपी सफलतापूर्वक पुनः भेजा गया!",
    "failedToResendOtp": "ओटीपी पुनः भेजने में विफल: {error}",
    "childLinkedSuccessfully": "बच्चा सफलतापूर्वक लिंक हो गया!",
    "invitationSentSuccessfully": "निमंत्रण सफलतापूर्वक भेजा गया!",
    "failedToSendInvitation": "निमंत्रण भेजने में विफल: {error}",
    "pleaseEnterValidEmail": "कृपया मान्य ईमेल दर्ज करें",
    "pleaseEnterValidEmailOrPhone": "कृपया मान्य ईमेल या फ़ोन दर्ज करें",
    "invalidCode": "अमान्य कोड, कृपया पुनः प्रयास करें",
    "cancelInvite": "निमंत्रण रद्द करें",
    "cancelInviteConfirmation": "क्या आप वाकई इस निमंत्रण को रद्द करना चाहते हैं?",
    "no": "नहीं",
    "yesCancel": "हाँ, रद्द करें",
    "inviteCancelledSuccessfully": "निमंत्रण सफलतापूर्वक रद्द किया गया!",
    "failedToCancelInvite": "निमंत्रण रद्द करने में विफल: {error}",
    "revokeAccess": "पहुंच रद्द करें",
    "revokeAccessConfirmation": "क्या आप वाकई इस बच्चे की पहुंच रद्द करना चाहते हैं? यह क्रिया पूर्ववत नहीं की जा सकती।",
    "revoke": "रद्द करें",
    "accessRevokedSuccessfully": "पहुंच सफलतापूर्वक रद्द की गई!",
    "failedToRevokeAccess": "पहुंच रद्द करने में विफल: {error}",
    "grantConsent": "सहमति दें",
    "revokeConsent": "सहमति रद्द करें",
    "consentGrantedSuccessfully": "सहमति सफलतापूर्वक दी गई!",
    "consentRevokedSuccessfully": "सहमति सफलतापूर्वक रद्द की गई!",
    "failedToUpdateConsent": "सहमति अपडेट करने में विफल: {error}",
    "checkingPermissions": "अनुमतियाँ जांची जा रही हैं...",
    "cancel": "रद्द करें",
    "close": "बंद करें",
    "save": "सहेजें",
    "sendNow": "अभी भेजें",
    "details": "विवरण",
    "noBroadcastMessages": "अभी तक कोई प्रसारण संदेश नहीं हैं",
    "errorCheckingPermissions": "अनुमतियाँ जांचने में त्रुटि: {error}",
    "mediaOptional": "मीडिया (वैकल्पिक)",
    "pickImage": "छवि चुनें",
    "pickVideo": "वीडियो चुनें",
    "pollOptions": "मतदान विकल्प:",
    "targetingFilters": "लक्षित फ़िल्टर",
    "scheduling": "अनुसूची",
    "scheduleForLater": "बाद के लिए शेड्यूल करें",
    "errorEstimatingRecipients": "प्राप्तकर्ताओं का अनुमान लगाने में त्रुटि: {error}",
    "errorPickingImage": "छवि चुनने में त्रुटि: {error}",
    "errorPickingVideo": "वीडियो चुनने में त्रुटि: {error}",
    "noPermissionForBroadcast": "आपके पास प्रसारण संदेश बनाने की अनुमति नहीं है।",
    "messageSavedSuccessfully": "संदेश सफलतापूर्वक सहेजा गया",
    "errorSavingMessage": "संदेश सहेजने में त्रुटि: {error}",
    "messageSentSuccessfully": "संदेश सफलतापूर्वक भेजा गया",
    "errorSendingMessage": "संदेश भेजने में त्रुटि: {error}",
    "content": "सामग्री: {content}",
    "type": "प्रकार: {type}",
    "link": "लिंक: {link}",
    "status": "स्थिति: {status}",
    "recipients": "प्राप्तकर्ता: {count}",
    "opened": "खोला गया: {count}",
    "clicked": "क्लिक किया गया: {count}",
    "created": "बनाया गया: {date}",
    "scheduled": "अनुसूचित: {date}",
    "organizations": "संगठन",
    "noOrganizations": "कोई संगठन नहीं",
    "errorLoadingOrganizations": "संगठन लोड करने में त्रुटि",
    "members": "{count} सदस्य",
    "users": "उपयोगकर्ता",
    "noUsers": "कोई उपयोगकर्ता नहीं",
    "errorLoadingUsers": "उपयोगकर्ता लोड करने में त्रुटि",
    "changeRole": "भूमिका बदलें",
    "totalAppointments": "कुल अपॉइंटमेंट",
    "completedAppointments": "पूर्ण अपॉइंटमेंट",
    "revenue": "राजस्व",
    "errorLoadingStats": "आंकड़े लोड करने में त्रुटि",
    "appointment": "अपॉइंटमेंट: {id}",
    "from": "से: {name}",
    "phone": "फोन: {number}",
    "noRouteDefined": "{route} के लिए कोई रूट परिभाषित नहीं है",
    "meetingDetails": "मीटिंग विवरण",
    "meetingId": "मीटिंग आईडी: {id}",
    "creator": "निर्माता: {id}",
    "context": "संदर्भ: {id}",
    "group": "समूह: {id}",
    "requestPrivateSession": "निजी सत्र का अनुरोध करें",
    "privacyRequestSent": "आपकी गोपनीयता का अनुरोध आपके माता-पिता को भेजा गया है!",
    "failedToSendPrivacyRequest": "गोपनीयता अनुरोध भेजने में विफल: {error}",
    "errorLoadingPrivacyRequests": "गोपनीयता अनुरोध लोड करने में त्रुटि: {error}",
    "requestType": "{type} अनुरोध",
    "statusColon": "स्थिति: {status}",
    "failedToActionPrivacyRequest": "गोपनीयता अनुरोध {action} करने में विफल: {error}",
    "yes": "हाँ",
    "send": "भेजें",
    "permissions": "अनुमतियाँ",
    "permissionsFor": "अनुमतियाँ - {childId}",
    "errorLoadingPermissions": "अनुमतियाँ लोड करने में त्रुटि: {error}",
    "none": "कोई नहीं",
    "readOnly": "केवल पढ़ने के लिए",
    "readWrite": "पढ़ें और लिखें",
    "permissionUpdated": "अनुमति {category} को {newValue} में अपडेट किया गया",
    "failedToUpdatePermission": "अनुमति अपडेट करने में विफल: {error}",
    "invited": "आमंत्रित किया गया: {date}",
    "adminBroadcast": "व्यवस्थापक प्रसारण",
    "composeBroadcastMessage": "प्रसारण संदेश लिखें",
    "adminScreenTBD": "व्यवस्थापक स्क्रीन - विकासाधीन",
    "staffScreenTBD": "स्टाफ स्क्रीन - विकासाधीन",
    "clientScreenTBD": "क्लाइंट स्क्रीन - विकासाधीन"
}

def update_hindi_file():
    """Update the Hindi ARB file with the new translations"""
    
    # Read the current Hindi file
    with open('lib/l10n/app_hi.arb', 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Parse the JSON content
    try:
        data = json.loads(content)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON: {e}")
        return
    
    # Update translations
    updated_count = 0
    for key, hindi_text in hindi_translations.items():
        if key in data:
            old_value = data[key]
            data[key] = hindi_text
            if old_value != hindi_text:
                updated_count += 1
                print(f"Updated: {key} = {hindi_text}")
        else:
            print(f"Warning: Key '{key}' not found in the file")
    
    # Write back to file
    with open('lib/l10n/app_hi.arb', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"\n✅ Successfully updated {updated_count} translations in app_hi.arb")
    print("📝 File has been saved with proper UTF-8 encoding")

if __name__ == "__main__":
    print("🔧 Updating Hindi translations...")
    update_hindi_file()
    print("\n✅ Hindi translation update completed!") 