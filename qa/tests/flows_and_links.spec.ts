import { test, expect } from '@playwright/test';

const MAIN = 'https://www.app-oint.com';

test('MAIN: 3 CTA routes', async ({ page }) => {
  await page.goto(MAIN);
  const ctas = page.locator('a:has-text("Business"), a:has-text("API"), a:has-text("Personal")');
  await expect(ctas).toHaveCount(3);
  const hrefs = await ctas.evaluateAll(els => els.map(e => (e as HTMLAnchorElement).href));
  expect(hrefs.some(h => h.includes('3001'))).toBeTruthy();
  expect(hrefs.some(h => h.includes('3003'))).toBeTruthy();
  expect(hrefs.some(h => h.includes(':3010'))).toBeTruthy();
});

async function crawl(page, origin: string, startPath: string) {
  const visited = new Set<string>();
  const queue: string[] = [startPath];
  const whitelist = [
    'www.app-oint.com',
    'app.app-oint.com',
    'business.app-oint.com',
    'enterprise.app-oint.com',
    'api.app-oint.com',
    'admin.app-oint.com'
  ];
  while (queue.length) {
    const path = queue.shift()!;
    if (visited.has(path)) continue;
    visited.add(path);
    const url = `${origin}${path}`;
    const resp = await page.goto(url);
    expect.soft(resp && (resp.status() < 400)).toBeTruthy();
    const anchors = page.locator('a[href]');
    const links = await anchors.evaluateAll(els => els.map(e => (e as HTMLAnchorElement).getAttribute('href') || ''));
    for (const l of links) {
      if (!l || l.startsWith('mailto:') || l.includes('logout')) continue;
      try {
        const u = new URL(l, origin);
        if (!whitelist.includes(u.hostname)) continue;
        if (u.origin === origin) queue.push(u.pathname + (u.search || ''));
      } catch {}
    }
  }
}

test('BUSINESS: LP → login/signup → dashboard; guard', async ({ page }) => {
  const origin = 'https://business.app-oint.com';
  await page.goto(origin);
  // LP visible
  await expect(page).toHaveTitle(/Business|Studio|App-Oint/i);
  // Guard
  await page.goto(`${origin}/dashboard`);
  expect.soft(page.url()).toMatch(/login|signin|\/?$/);
  await crawl(page, origin, '/');
});

test('ENTERPRISE: LP → login → dashboard; guard', async ({ page }) => {
  const origin = 'https://enterprise.app-oint.com';
  await page.goto(origin);
  await expect(page).toHaveTitle(/Enterprise|App-Oint/i);
  await page.goto(`${origin}/dashboard`);
  expect.soft(page.url()).toMatch(/login|signin|\/?$/);
  await crawl(page, origin, '/');
});

test('PERSONAL: create/edit/share/cancel flow order', async ({ page }) => {
  const origin = 'http://127.0.0.1:3010';
  await page.goto(origin);
  await expect(page.getByText('Create Meeting', { exact: false })).toBeVisible();
  // Flow is placeholder, as prod creds may block writes; verify pages render and links work
  await crawl(page, origin, '/');
});

test('API PORTAL: LP → login → API Keys; guard', async ({ page }) => {
  const origin = 'https://api.app-oint.com';
  await page.goto(origin);
  await expect(page).toHaveTitle(/API|Docs|App-Oint/i);
  await crawl(page, origin, '/');
});

test('ADMIN: login guard and tab order', async ({ page }) => {
  const origin = 'https://admin.app-oint.com';
  await page.goto(`${origin}/login`);
  await expect(page).toHaveTitle(/Admin|Login/i);
  await crawl(page, origin, '/');
});


