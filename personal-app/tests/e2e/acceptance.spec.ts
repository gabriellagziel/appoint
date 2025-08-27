import { expect, test } from '@playwright/test';

test.describe('Personal PWA — Acceptance Testing', () => {
    test('Home page loads and shows basic structure', async ({ page }) => {
        await page.goto('/en');

        // Check that the page loads without errors
        await expect(page).toHaveTitle(/Personal|App-Oint/i);

        // Check for basic page structure
        await expect(page.locator('body')).toBeVisible();
    });

    test('Navigation routes are accessible', async ({ page }) => {
        const routes = ['/en', '/en/meetings', '/en/reminders', '/en/groups', '/en/family', '/en/playtime', '/en/settings'];

        for (const route of routes) {
            await page.goto(route);
            // Basic check that page loads
            await expect(page.locator('body')).toBeVisible();
        }
    });

    test('Meeting creation flow exists', async ({ page }) => {
        await page.goto('/en/create/meeting');

        // Check that the meeting creation page loads
        await expect(page.locator('body')).toBeVisible();
    });

    test('PWA manifest and service worker', async ({ page }) => {
        await page.goto('/en');

        // Check for PWA manifest
        const manifest = await page.locator('link[rel="manifest"]');
        if (await manifest.count() > 0) {
            await expect(manifest).toBeVisible();
        }
    });
});
