import { test, expect } from '@playwright/test';

const SUPER_LOGIN_USERNAME = process.env.SUPER_LOGIN_USERNAME || '';
const SUPER_LOGIN_PASSWORD = process.env.SUPER_LOGIN_PASSWORD || '';

const targets = [
  { url: 'http://127.0.0.1:3004/login', name: 'personal' },
  { url: 'http://127.0.0.1:3001/login', name: 'business' },
  { url: 'http://127.0.0.1:3002/login', name: 'enterprise' },
  { url: 'http://127.0.0.1:3003/login', name: 'api' },
  { url: 'http://127.0.0.1:3005/login', name: 'admin' }
];

for (const t of targets) {
  test(`login session: ${t.name}`, async ({ page }) => {
    test.setTimeout(180_000);
    if (!SUPER_LOGIN_USERNAME || !SUPER_LOGIN_PASSWORD) {
      test.info().annotations.push({ type: 'BLOCKER', description: `Missing SUPER_LOGIN credentials for ${t.name}` });
      test.skip();
    }
    await page.goto(t.url, { waitUntil: 'domcontentloaded' });
    const emailSel = 'input[type="email"], input[name*="email" i], input[name*="username" i]';
    const passSel = 'input[type="password" i]';
    const btnSel = 'button:has-text("Login"), button[type="submit"], [role="button"]:has-text("Login")';
    await page.locator(emailSel).first().fill(SUPER_LOGIN_USERNAME);
    await page.locator(passSel).first().fill(SUPER_LOGIN_PASSWORD);
    await page.locator(btnSel).first().click();
    await page.waitForLoadState('networkidle');
    // save storage
    await page.context().storageState({ path: `.auth/${t.name}.json` });
    expect.soft((await page.url()).includes('/dashboard') || (await page.url()).includes('/keys') ).toBeTruthy();
  });
}


