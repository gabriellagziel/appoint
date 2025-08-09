import { test, expect } from '@playwright/test';

test('landing loads and nav works', async ({ page }) => {
  await page.goto('http://localhost:3000/');
  await expect(page).toHaveTitle(/App-Oint/i);
  const link = page.getByRole('link', { name: /Get Started|Dashboard|Login/i }).first();
  if (await link.isVisible()) {
    await link.click();
    await expect(page).toHaveURL(/(dashboard|login)/i);
  }
});



