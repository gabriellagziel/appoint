import { test, expect } from '@playwright/test';

const domains = [
  'http://127.0.0.1:3000',
  'http://127.0.0.1:3001',
  'http://127.0.0.1:3002'
];

const adPatterns = [
  /doubleclick\.net/i,
  /googletagservices\.com/i,
  /googleads\.g\.doubleclick\.net/i,
  /adservice\.google\.com/i,
  /taboola\.com/i,
  /criteo\.com/i,
  /adsystem\.com/i,
  /ads?\/|[?&]ad[sx]?=/i
];

for (const origin of domains) {
  test(`No ads network requests: ${origin}`, async ({ page }) => {
    const seen: string[] = [];
    page.on('request', (req) => {
      const url = req.url();
      if (adPatterns.some((re) => re.test(url))) {
        seen.push(url);
      }
    });
    await page.goto(origin);
    await page.waitForLoadState('networkidle');
    expect.soft(seen, `Ad requests detected on ${origin}`).toHaveLength(0);
  });
}

