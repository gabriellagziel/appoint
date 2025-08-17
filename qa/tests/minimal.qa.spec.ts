import { test, expect } from '@playwright/test';

test('minimal test', async ({ page }) => {
  expect(true).toBe(true);
});
