import { test, expect } from '@playwright/test';

// Always navigate relative to baseURL
async function goto(page, path: string) {
  await page.goto(path, { waitUntil: 'domcontentloaded' });
}
function escapeRegex(str: string) {
  return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

test.describe('Personal PWA — Conversational UI/UX acceptance', () => {
  test('Step 0: Home greeting + Quick Actions + Bottom Nav', async ({ page }) => {
    await goto(page, '/');
    await expect(page.getByText(/Hi .*what would you like to do today\?/i)).toBeVisible();

    // Quick Actions
    for (const label of ['New Meeting','Reminder','Playtime','Groups','Family']) {
      await expect(page.getByRole('button', { name: new RegExp(escapeRegex(label), 'i') })).toBeVisible();
    }

    // Bottom Nav
    for (const item of ['Home','Meetings','Reminders','Groups','Family','Settings']) {
      await expect(page.getByRole('link', { name: new RegExp(`^${escapeRegex(item)}$`, 'i') })).toBeVisible();
    }
  });

  test('Create Meeting: conversational steps present', async ({ page }) => {
    await goto(page, '/');
    const start = page.getByRole('button', { name: /New Meeting|Create Meeting/i });
    await expect(start).toBeVisible();
    await start.click();

    // Step 1: meeting types
    const types = [
      'Personal Meeting (1:1)',
      'Group Meeting / Event',
      'Virtual Meeting',
      'With a Business',
      'Playtime',
      'Open Call'
    ];
    for (const t of types) {
      await expect(page.getByRole('button', { name: new RegExp(escapeRegex(t), 'i') })).toBeVisible();
    }
  });

  test('Key routes exist', async ({ page }) => {
    for (const path of ['/', '/meetings', '/reminders', '/groups', '/family', '/playtime']) {
      await goto(page, path);
      await expect(page).toHaveTitle(/App|Personal|Meetings|Reminders|Groups|Family|Playtime/i);
    }
  });

  test('PWA A2HS prompt after 3 sessions', async ({ page, context }) => {
    await context.addInitScript(() => {
      try { localStorage.setItem('sessionsCount', '3'); } catch {}
    });
    await goto(page, '/');
    await expect(page.getByText(/Add App[- ]Oint to your Home Screen/i)).toBeVisible();
  });
});
