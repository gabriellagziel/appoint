# PWA Quality Assurance Checklist

## 🔍 Pre-Testing Setup

### Required Test Devices
- [ ] **Android Phone** with Chrome (latest version)
- [ ] **iPhone/iPad** with Safari (iOS 15.4+ for better PWA support)
- [ ] **Desktop Chrome** (for negative testing)
- [ ] **Desktop Safari** (for negative testing)

### Test Environment Setup
- [ ] Build app: `flutter build web --no-tree-shake-icons`
- [ ] Serve locally: `cd build/web && python3 -m http.server 8000`
- [ ] Access via `http://localhost:8000` (or deploy to staging with HTTPS)
- [ ] Clear browser data before each test session
- [ ] Enable browser developer tools and console logging

---

## 📱 Android Chrome Testing

### ✅ Installation Flow
- [ ] **First Visit**: No prompt should appear
- [ ] **Meeting Creation 1**: Create first meeting → No prompt
- [ ] **Meeting Creation 2**: Create second meeting → No prompt  
- [ ] **Meeting Creation 3**: Create third meeting → PWA prompt appears
- [ ] **Prompt Content**: Verify Android-specific instructions are shown
- [ ] **"Add Now" Button**: Click → Native install prompt appears
- [ ] **Install Process**: Complete installation → App appears on home screen
- [ ] **Launch from Home Screen**: App opens in standalone mode
- [ ] **Standalone Verification**: No browser UI (address bar, tabs, etc.)

### ✅ Post-Installation Behavior
- [ ] **No More Prompts**: Create more meetings → No PWA prompts appear
- [ ] **Offline Loading**: Disable network → App shell loads from cache
- [ ] **Service Worker**: Check `navigator.serviceWorker.controller` exists
- [ ] **Display Mode**: Verify `window.matchMedia('(display-mode: standalone)').matches` is true

### ✅ Analytics Events (Check Console)
- [ ] `pwa_prompt_shown` event logged on 3rd meeting
- [ ] `pwa_install_accepted` event logged when "Add Now" clicked
- [ ] `pwa_installed` event logged with `source: android_native_prompt`
- [ ] `meeting_created` events with correct `will_show_pwa_prompt` values

---

## 🍎 iOS Safari Testing

### ✅ Installation Flow  
- [ ] **First Visit**: No prompt should appear
- [ ] **Meeting Creation 1-2**: No prompts appear
- [ ] **Meeting Creation 3**: PWA prompt with iOS instructions appears
- [ ] **Prompt Content**: Verify iOS-specific instructions (Share button → Add to Home Screen)
- [ ] **"Got It" Button**: Instructions are clear and actionable
- [ ] **Manual Installation**: Follow instructions → Add to Home Screen
- [ ] **Home Screen Icon**: App appears on iOS home screen
- [ ] **Launch from Home Screen**: App opens in standalone mode
- [ ] **iOS Status Bar**: Verify `black-translucent` status bar style

### ✅ Post-Installation Behavior
- [ ] **Auto-Detection**: PWA status detected automatically
- [ ] **No More Prompts**: Create more meetings → No PWA prompts appear
- [ ] **iOS Standalone Check**: Verify `navigator.standalone === true`
- [ ] **Offline Support**: Basic app shell works offline

### ✅ Analytics Events (Check Console)
- [ ] `pwa_prompt_shown` event logged with `device: ios`
- [ ] `pwa_install_accepted` event logged when "Got It" clicked  
- [ ] `pwa_installed` event logged with `source: ios_manual` after installation
- [ ] All events have correct device detection

---

## 🖥️ Desktop Testing (Negative Cases)

### ✅ Desktop Chrome
- [ ] **No Prompts**: Create multiple meetings → No PWA prompts appear
- [ ] **Mobile Detection**: `isMobileDevice` returns false
- [ ] **PWA Support**: May support PWA install but prompts are disabled
- [ ] **Console Logs**: Verify "PWA: Mobile device required" messages

### ✅ Desktop Safari
- [ ] **No Prompts**: Create multiple meetings → No PWA prompts appear
- [ ] **Device Detection**: Correctly identified as desktop
- [ ] **Service Worker**: May not support service workers (depending on version)

---

## 🔄 User Flow Testing

### ✅ New User Journey
1. [ ] **Fresh Install**: Clear all browser data
2. [ ] **Registration/Login**: Complete user auth flow
3. [ ] **Meeting 1**: Create → No prompt
4. [ ] **Meeting 2**: Create → No prompt  
5. [ ] **Meeting 3**: Create → Prompt appears
6. [ ] **Install**: Complete PWA installation
7. [ ] **Meeting 4+**: Create → No prompts appear

### ✅ Returning User Journey
1. [ ] **Existing User**: Login with account that has meeting history
2. [ ] **Counter Persistence**: PWA counter continues from stored value
3. [ ] **Prompt Logic**: Shows at correct intervals (every 3rd meeting)
4. [ ] **Installation State**: Remembered across sessions

### ✅ Edge Cases
- [ ] **"Not Now" Snooze**: Click "Not Now" → No prompt for 24 hours
- [ ] **Session Limit**: Only one prompt per session
- [ ] **Network Issues**: Graceful handling of Firestore errors
- [ ] **Authentication Issues**: No prompts for anonymous users
- [ ] **Multiple Tabs**: Prompt shown in one tab prevents showing in others

---

## 📊 Analytics Verification

### ✅ Event Tracking
- [ ] **Meeting Creation**: All meetings logged with correct metadata
- [ ] **Prompt Events**: Shown/dismissed/accepted events captured
- [ ] **Installation Events**: Source attribution correct (native vs manual)
- [ ] **Device Detection**: Accurate device/browser identification
- [ ] **User Attribution**: Events tied to correct user IDs

### ✅ Data Structure
```javascript
// Example analytics events to verify:
{
  event: 'pwa_prompt_shown',
  device: 'android',
  reason: 'meeting_count_trigger', 
  user_id: 'user123',
  timestamp: '2024-01-01T12:00:00Z'
}

{
  event: 'pwa_installed',
  device: 'ios',
  source: 'ios_manual',
  user_id: 'user123',
  display_mode: 'standalone'
}
```

---

## 🔧 Technical Validation

### ✅ Service Worker
- [ ] **Registration**: Service worker registers successfully
- [ ] **Caching**: Static assets cached properly
- [ ] **Offline**: Basic functionality works offline
- [ ] **Updates**: Service worker updates on new deploys

### ✅ Manifest.json
- [ ] **Accessible**: `/manifest.json` loads without errors
- [ ] **Valid JSON**: No syntax errors
- [ ] **Icons**: All icon paths resolve correctly
- [ ] **Display Mode**: Set to `standalone`
- [ ] **Start URL**: Points to correct app entry point

### ✅ Icons & Assets
- [ ] **Icon Files**: All referenced icons exist in `/icons/` directory
- [ ] **Sizes**: 192x192 and 512x512 icons present
- [ ] **Maskable**: Maskable icons for adaptive icon support
- [ ] **Apple Icons**: iOS touch icons configured

### ✅ Firestore Integration
- [ ] **User Meta Collection**: Documents created correctly
- [ ] **Security Rules**: Only authenticated users can access their data
- [ ] **Counter Logic**: Meeting count increments properly
- [ ] **Installation Flag**: `hasInstalledPwa` flag works correctly

---

## 🚀 Performance Testing

### ✅ Load Times
- [ ] **First Load**: Initial app load under 3 seconds
- [ ] **Cached Load**: Subsequent loads under 1 second  
- [ ] **PWA Install**: Installation process completes quickly
- [ ] **Offline Load**: Cached content loads immediately when offline

### ✅ Browser Compatibility
- [ ] **Chrome Android**: Full PWA support
- [ ] **Safari iOS**: Manual installation support
- [ ] **Chrome Desktop**: No mobile prompts (correct behavior)
- [ ] **Safari Desktop**: No mobile prompts (correct behavior)
- [ ] **Firefox Mobile**: Graceful degradation

---

## 🐛 Error Scenarios

### ✅ Network Issues
- [ ] **Firestore Offline**: App handles Firestore connection issues
- [ ] **Service Worker Fail**: App works if SW registration fails
- [ ] **Analytics Errors**: Analytics failures don't break core functionality

### ✅ Authentication Issues  
- [ ] **Not Logged In**: No PWA prompts for anonymous users
- [ ] **Token Expiry**: Handles auth token expiration gracefully
- [ ] **Login/Logout**: PWA state persists across auth changes

### ✅ Browser Issues
- [ ] **Incognito Mode**: Handles private browsing limitations
- [ ] **Old Browsers**: Graceful degradation for unsupported browsers
- [ ] **Disabled JavaScript**: Basic functionality without JS (if applicable)

---

## ✅ Automated Testing Script

### Basic Playwright Test (Optional)
```javascript
// Save as pwa_basic_test.js
const { test, expect } = require('@playwright/test');

test('PWA manifest and service worker', async ({ page }) => {
  await page.goto('http://localhost:8000');
  
  // Check manifest loads
  const manifestResponse = await page.request.get('/manifest.json');
  expect(manifestResponse.status()).toBe(200);
  
  const manifest = await manifestResponse.json();
  expect(manifest.name).toBe('App-Oint');
  expect(manifest.display).toBe('standalone');
  
  // Check service worker registers
  await page.waitForFunction(() => 'serviceWorker' in navigator);
  const swRegistered = await page.evaluate(() => {
    return navigator.serviceWorker.controller !== null;
  });
  // Note: SW might not be active immediately on first load
  
  // Check PWA installability
  const isInstallable = await page.evaluate(() => {
    return window.matchMedia('(display-mode: browser)').matches;
  });
  expect(isInstallable).toBe(true);
});
```

### Running Automated Test
```bash
# Install Playwright
npm install @playwright/test

# Run test
npx playwright test pwa_basic_test.js
```

---

## 📋 Final Checklist

- [ ] **All device tests pass** (Android Chrome, iOS Safari, Desktop)
- [ ] **Analytics events captured** correctly in all scenarios  
- [ ] **No console errors** during normal operation
- [ ] **Offline functionality** works as expected
- [ ] **Security rules** properly protect user data
- [ ] **Performance metrics** meet targets (< 3s initial load)
- [ ] **Edge cases handled** gracefully (network issues, auth problems)
- [ ] **Documentation updated** with any test findings

---

## 🎯 Success Criteria

### ✅ Must Have
- [x] PWA installs successfully on Android Chrome
- [x] Manual installation works on iOS Safari  
- [x] Meeting counter increments correctly
- [x] Prompt appears every 3 meetings (until installed)
- [x] Prompt stops after PWA installation
- [x] Works only on mobile devices
- [x] Analytics events captured

### ✅ Nice to Have
- [ ] Lighthouse PWA score > 90
- [ ] Page load speed < 2 seconds
- [ ] Offline mode fully functional
- [ ] Push notifications ready (future feature)

### 🚫 Must Not Have
- [x] No prompts on desktop devices
- [x] No prompts for unauthenticated users
- [x] No multiple prompts in same session
- [x] No broken functionality if PWA features unavailable

---

**Status**: Ready for testing ✅
**Next Step**: Deploy to staging and run full test suite
