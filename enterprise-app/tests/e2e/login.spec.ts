import { test, expect } from '@playwright/test';

test('login page renders', async ({ page }) => {
  await page.goto('http://localhost:5000/login');
  await expect(page.getByRole('heading', { name: /login/i })).toBeVisible();
});



