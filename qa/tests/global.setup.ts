import { chromium } from '@playwright/test';
import fs from 'node:fs';

const creds = {
  user: process.env.SUPER_LOGIN_USERNAME || '',
  pass: process.env.SUPER_LOGIN_PASSWORD || ''
};

async function tryLogin(base: string, paths: string[], storage: string) {
  const browser = await chromium.launch();
  const context = await browser.newContext();
  const page = await context.newPage();
  for (const p of paths) {
    try {
      await page.goto(base + p, { waitUntil: 'domcontentloaded', timeout: 5000 });
      const emailSel = 'input[type="email"], input[name*="email" i], input[name*="username" i]';
      const passSel = 'input[type="password" i]';
      const btnSel = 'button:has-text("Login"), button[type="submit"], [role="button"]:has-text("Login")';
      if (await page.locator(emailSel).first().count()) {
        await page.locator(emailSel).first().fill(creds.user);
      }
      if (await page.locator(passSel).first().count()) {
        await page.locator(passSel).first().fill(creds.pass);
      }
      if (await page.locator(btnSel).first().count()) {
        await page.locator(btnSel).first().click();
      }
      await page.waitForLoadState('networkidle', { timeout: 5000 }).catch(() => {});
      break;
    } catch {
      // try next path or proceed
    }
  }
  await context.storageState({ path: storage });
  await browser.close();
}

export default async function globalSetup() {
  fs.mkdirSync('.auth', { recursive: true });
  const tasks = [
    tryLogin('http://127.0.0.1:3001', ['/login', '/auth/login'], '.auth/business.json'),
    tryLogin('http://127.0.0.1:3002', ['/login', '/auth/login'], '.auth/enterprise.json'),
    tryLogin('http://127.0.0.1:3003', ['/login', '/auth/login'], '.auth/api_portal.json'),
    tryLogin('http://127.0.0.1:3010', ['/login', '/auth/login'], '.auth/personal.json'),
    tryLogin('http://127.0.0.1:3005', ['/login', '/auth/login'], '.auth/admin.json')
  ];
  await Promise.allSettled(tasks);
}


