#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import json
import re

# Traditional Chinese translations provided by the user
REDACTED_TOKEN = {
    "appTitle": "Appoint",
    "welcome": "歡迎",
    "home": "主頁",
    "menu": "選單",
    "profile": "個人資料",
    "signOut": "登出",
    "login": "登入",
    "email": "電子郵件",
    "password": "密碼",
    "signIn": "登入",
    "bookMeeting": "預約會議",
    "bookAppointment": "預約服務",
    "bookingRequest": "預約請求",
    "confirmBooking": "確認預約",
    "chatBooking": "聊天預約",
    "bookViaChat": "透過聊天預約",
    "submitBooking": "提交預約",
    "next": "下一步",
    "selectStaff": "選擇工作人員",
    "pickDate": "選擇日期",
    "staff": "工作人員",
    "service": "服務",
    "dateTime": "日期與時間",
    "duration": "時長：{duration} 分鐘",
    "notSelected": "尚未選擇",
    "noSlots": "無可預約時段",
    "bookingConfirmed": "預約已確認",
    "failedToConfirmBooking": "無法確認預約",
    "noBookingsFound": "找不到預約",
    "errorLoadingBookings": "讀取預約錯誤：{error}",
    "shareOnWhatsApp": "分享到 WhatsApp",
    "shareMeetingInvitation": "分享您的會議邀請：",
    "meetingReadyMessage": "會議已就緒！是否要發送給您的群組？",
    "customizeMessage": "自訂您的訊息...",
    "saveGroupForRecognition": "儲存群組以供未來辨識",
    "groupNameOptional": "群組名稱（選填）",
    "enterGroupName": "輸入群組名稱以便辨識",
    "knownGroupDetected": "偵測到已知群組",
    "meetingSharedSuccessfully": "會議已成功分享！",
    "bookingConfirmedShare": "預約已確認！您現在可以分享邀請。",
    "defaultShareMessage": "嗨！我透過 APP‑OINT 安排了一次會議。點此確認或提出其他時間：",
    "dashboard": "儀表板",
    "businessDashboard": "商業儀表板",
    "myProfile": "我的個人資料",
    "noProfileFound": "找不到個人資料",
    "errorLoadingProfile": "讀取個人資料錯誤",
    "myInvites": "我的邀請",
    "inviteDetail": "邀請詳情",
    "inviteContact": "邀請聯絡人",
    "noInvites": "無邀請",
    "errorLoadingInvites": "讀取邀請錯誤",
    "accept": "接受",
    "decline": "拒絕",
    "sendInvite": "發送邀請",
    "name": "姓名",
    "phoneNumber": "電話號碼",
    "emailOptional": "電子郵件（選填）",
    "requiresInstallFallback": "需要安裝",
    "notifications": "通知",
    "notificationSettings": "通知設定",
    "enableNotifications": "啟用通知",
    "errorFetchingToken": "無法取得令牌",
    "fcmToken": "FCM 令牌：{token}",
    "familyDashboard": "家庭儀表板",
    "pleaseLoginForFamilyFeatures": "請登入以存取家庭功能",
    "familyMembers": "家庭成員",
    "invite": "邀請",
    "pendingInvites": "待處理邀請",
    "connectedChildren": "已連結子女",
    "noFamilyMembersYet": "尚無家庭成員。邀請多人開始使用吧！",
    "errorLoadingFamilyLinks": "讀取家庭連結錯誤：{error}",
    "inviteChild": "邀請孩童",
    "managePermissions": "管理權限",
    "removeChild": "移除孩童",
    "loading": "載入中...",
    "childEmail": "孩童電子郵件",
    "childEmailOrPhone": "孩童郵件或電話",
    "enterChildEmail": "輸入孩童電子郵件",
    "otpCode": "OTP 驗證碼",
    "enterOtp": "輸入 OTP",
    "verify": "驗證",
    "otpResentSuccessfully": "OTP 已重新發送成功！",
    "failedToResendOtp": "重新發送 OTP 失敗：{error}",
    "childLinkedSuccessfully": "孩童已成功連結！",
    "invitationSentSuccessfully": "邀請已發送成功！",
    "failedToSendInvitation": "發送邀請失敗：{error}",
    "pleaseEnterValidEmail": "請輸入有效電子郵件",
    "pleaseEnterValidEmailOrPhone": "請輸入有效電子郵件或電話",
    "invalidCode": "無效的代碼，請再試一次",
    "cancelInvite": "取消邀請",
    "cancelInviteConfirmation": "您確定要取消此邀請嗎？",
    "no": "否",
    "yesCancel": "是，取消",
    "inviteCancelledSuccessfully": "邀請已成功取消！",
    "failedToCancelInvite": "取消邀請失敗：{error}",
    "revokeAccess": "撤銷存取權",
    "revokeAccessConfirmation": "您確定要撤銷此孩童的存取權嗎？此操作無法還原。",
    "revoke": "撤銷",
    "accessRevokedSuccessfully": "存取權已撤銷成功！",
    "failedToRevokeAccess": "撤銷存取權失敗：{error}",
    "grantConsent": "授予同意",
    "revokeConsent": "撤銷同意",
    "consentGrantedSuccessfully": "同意已成功授予！",
    "consentRevokedSuccessfully": "同意已成功撤銷！",
    "failedToUpdateConsent": "更新同意失敗：{error}",
    "checkingPermissions": "正在檢查權限...",
    "cancel": "取消",
    "close": "關閉",
    "save": "儲存",
    "sendNow": "立即發送",
    "details": "詳細資訊",
    "noBroadcastMessages": "尚無廣播訊息",
    "errorCheckingPermissions": "檢查權限錯誤：{error}",
    "mediaOptional": "媒體（選填）",
    "pickImage": "選擇圖片",
    "pickVideo": "選擇影片",
    "pollOptions": "投票選項：",
    "targetingFilters": "目標篩選",
    "scheduling": "排程",
    "scheduleForLater": "稍後安排",
    "errorEstimatingRecipients": "預估收件人失敗：{error}",
    "errorPickingImage": "選擇圖片錯誤：{error}",
    "errorPickingVideo": "選擇影片錯誤：{error}",
    "noPermissionForBroadcast": "您無權建立廣播訊息。",
    "messageSavedSuccessfully": "訊息已成功儲存",
    "errorSavingMessage": "儲存訊息失敗：{error}",
    "messageSentSuccessfully": "訊息已成功發送",
    "errorSendingMessage": "發送訊息失敗：{error}",
    "content": "內容：{content}",
    "type": "類型：{type}",
    "link": "連結：{link}",
    "status": "狀態：{status}",
    "recipients": "收件人：{count}",
    "opened": "已開啟：{count}",
    "clicked": "已點擊：{count}",
    "created": "建立於：{date}",
    "scheduled": "已排程：{date}",
    "organizations": "組織",
    "noOrganizations": "無組織",
    "errorLoadingOrganizations": "讀取組織錯誤",
    "members": "{count} 名成員",
    "users": "使用者",
    "noUsers": "無使用者",
    "errorLoadingUsers": "讀取使用者錯誤",
    "changeRole": "更改角色",
    "totalAppointments": "預約總數",
    "completedAppointments": "完成的預約",
    "revenue": "收入",
    "errorLoadingStats": "載入統計資料錯誤",
    "appointment": "預約：{id}",
    "from": "來自：{name}",
    "phone": "電話：{number}",
    "noRouteDefined": "未為 {route} 定義路由",
    "meetingDetails": "會議詳情",
    "meetingId": "會議 ID：{id}",
    "creator": "建立者：{id}",
    "context": "上下文：{id}",
    "group": "群組：{id}",
    "requestPrivateSession": "請求私人會議",
    "privacyRequestSent": "隱私請求已發送給您的家長！",
    "failedToSendPrivacyRequest": "發送隱私請求失敗：{error}",
    "errorLoadingPrivacyRequests": "讀取隱私請求錯誤：{error}",
    "requestType": "{type} 請求",
    "statusColon": "狀態：{status}",
    "failedToActionPrivacyRequest": "{action} 隱私請求失敗：{error}",
    "yes": "是",
    "send": "發送",
    "permissions": "權限",
    "permissionsFor": "{childId} 的權限",
    "errorLoadingPermissions": "讀取權限錯誤：{error}",
    "none": "無",
    "readOnly": "僅讀",
    "readWrite": "可讀寫",
    "permissionUpdated": "權限 {category} 已更新為 {newValue}",
    "failedToUpdatePermission": "更新權限失敗：{error}",
    "invited": "已邀請：{date}",
    "adminBroadcast": "管理員廣播",
    "composeBroadcastMessage": "撰寫廣播訊息",
    "adminScreenTBD": "管理員畫面 – 開發中",
    "staffScreenTBD": "員工畫面 – 開發中",
    "clientScreenTBD": "客戶畫面 – 開發中"
}

def update_traditional_chinese_file():
    """Update the Traditional Chinese ARB file with the new translations"""
    
    # Read the current Traditional Chinese file
    with open('lib/l10n/app_zh_Hant.arb', 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Parse the JSON content
    try:
        data = json.loads(content)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON: {e}")
        return
    
    # Update translations
    updated_count = 0
    for key, chinese_text in REDACTED_TOKEN.items():
        if key in data:
            old_value = data[key]
            data[key] = chinese_text
            if old_value != chinese_text:
                updated_count += 1
                print(f"Updated: {key} = {chinese_text}")
        else:
            print(f"Warning: Key '{key}' not found in the file")
    
    # Write back to file
    with open('lib/l10n/app_zh_Hant.arb', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    
    print(f"\n✅ Successfully updated {updated_count} translations in app_zh_Hant.arb")
    print("📝 File has been saved with proper UTF-8 encoding")

if __name__ == "__main__":
    print("🔧 Updating Traditional Chinese translations...")
    update_traditional_chinese_file()
    print("\n✅ Traditional Chinese translation update completed!") 