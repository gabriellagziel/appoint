import { test, expect } from '@playwright/test';

const roots = [
  'http://127.0.0.1:3000/',
  'http://127.0.0.1:3001/',
  'http://127.0.0.1:3002/',
  'http://127.0.0.1:3003/',
  'http://127.0.0.1:3004/',
  'http://127.0.0.1:3005/login'
];

test('Link crawl local whitelist', async ({ page }) => {
  const whitelist = ['127.0.0.1'];
  const ports = ['3000','3001','3002','3003','3004','3005'];
  const visited = new Set<string>();

  for (const start of roots) {
    const queue: string[] = [start];
    while (queue.length) {
      const url = queue.shift()!;
      if (visited.has(url)) continue;
      visited.add(url);
      const resp = await page.goto(url);
      expect.soft(resp && resp.status() < 400).toBeTruthy();
      const anchors = page.locator('a[href]');
      const links = await anchors.evaluateAll(els => els.map(e => (e as HTMLAnchorElement).href));
      for (const l of links) {
        if (!l || l.startsWith('mailto:') || l.toLowerCase().includes('logout')) continue;
        try {
          const u = new URL(l);
          if (whitelist.includes(u.hostname) && ports.includes(u.port)) queue.push(u.toString());
        } catch {}
      }
      if (visited.size > 200) break; // sanity cap
    }
  }
});



