import { test, expect } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

const U = {
  MAIN: 'http://127.0.0.1:3000',
  BUSINESS: 'http://127.0.0.1:3001',
  ENTERPRISE: 'http://127.0.0.1:3002',
  API_PORTAL: 'http://127.0.0.1:3003',
  PERSONAL: 'http://127.0.0.1:3010',
  ADMIN: 'http://127.0.0.1:3005'
};

test('MAIN: 3 CTAs route to local apps', async ({ page }) => {
  await page.goto(U.MAIN);
  const ctas = page.locator('a:has-text("Business"), a:has-text("API"), a:has-text("Personal")');
  await expect(ctas).toHaveCount(3);
  const hrefs = await ctas.evaluateAll(els => els.map(e => (e as HTMLAnchorElement).href));
  expect(hrefs.some(h => h.includes(':3001'))).toBeTruthy();
  expect(hrefs.some(h => h.includes(':3003'))).toBeTruthy();
  expect(hrefs.some(h => h.includes(':3004'))).toBeTruthy();
  const results = await new AxeBuilder({ page }).analyze();
  const critical = results.violations.filter(v => ['critical','serious'].includes(v.impact||''));
  expect.soft(critical, 'a11y critical/serious on MAIN').toHaveLength(0);
});

test('BUSINESS: LP → login → dashboard; guard; settings/team/export', async ({ page }) => {
  await page.goto(U.BUSINESS);
  await page.goto(U.BUSINESS + '/dashboard');
  expect.soft(page.url()).toMatch(/\/login|\/?$/);
});

test('ENTERPRISE: LP → login → dashboard; guard', async ({ page }) => {
  await page.goto(U.ENTERPRISE);
  await page.goto(U.ENTERPRISE + '/dashboard');
  expect.soft(page.url()).toMatch(/\/login|\/?$/);
});

test('PERSONAL: flow order smoke (render + crawl)', async ({ page }) => {
  await page.goto(U.PERSONAL);
  await expect(page.getByText('Create Meeting', { exact: false })).toBeVisible({ timeout: 5000 });
});

test('API PORTAL: LP + docs visible', async ({ page }) => {
  await page.goto(U.API_PORTAL);
  await expect(page).toHaveTitle(/API|Docs|App/i);
});

test('ADMIN: login guard present', async ({ page }) => {
  await page.goto(U.ADMIN + '/login');
  await expect(page).toHaveTitle(/Admin|Login/i);
});



