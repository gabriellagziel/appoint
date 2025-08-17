import { chromium } from '@playwright/test';
import AxeBuilder from '@axe-core/playwright';

const pages = [
  'https://www.app-oint.com/',
  'https://app.app-oint.com/',
  'https://business.app-oint.com/',
  'https://enterprise.app-oint.com/',
  'https://api.app-oint.com/',
  'https://admin.app-oint.com/login'
];

async function run() {
  const browser = await chromium.launch();
  const context = await browser.newContext();
  const page = await context.newPage();
  let failures = 0;
  for (const url of pages) {
    await page.goto(url);
    const results = await new AxeBuilder({ page }).analyze();
    const out = `qa/output/a11y-${encodeURIComponent(url)}.json`;
    await Bun.write(out, JSON.stringify(results, null, 2)).catch(()=>{});
    const criticalOrSerious = results.violations.filter(v => ['critical', 'serious'].includes(v.impact || '')); 
    if (criticalOrSerious.length) {
      failures += criticalOrSerious.length;
    }
  }
  await browser.close();
  if (failures) {
    console.error(`A11y critical/serious violations: ${failures}`);
    process.exit(1);
  }
}

run();

