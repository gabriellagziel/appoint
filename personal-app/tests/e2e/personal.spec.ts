import { expect, test } from '@playwright/test';

// Helpers
async function acceptA2HS(context: any) {
    // Simulate 3 sessions for A2HS logic based on localStorage counter
    await context.addInitScript(() => {
        try {
            localStorage.setItem('sessionsCount', '3');
        } catch { }
    });
}

test.describe('Personal PWA — Spec Compliance', () => {
    test.beforeEach(async ({ page, context }) => {
        await acceptA2HS(context);
    });

    test('Step 0 – Opening screen & Quick Actions', async ({ page }) => {
        await page.goto('/en');
        await expect(page.getByText(/Hi .*what would you like to do today\?/i)).toBeVisible();

        // Quick Actions
        await expect(page.getByRole('link', { name: /New Meeting/i })).toBeVisible();
        await expect(page.getByRole('link', { name: /⏰ Reminder/i })).toBeVisible();
        await expect(page.getByRole('link', { name: /🎮 Playtime/i })).toBeVisible();
        await expect(page.getByRole('link', { name: /👥 Groups/i })).toBeVisible();
        await expect(page.getByRole('link', { name: /👨‍👩‍👧 Family/i })).toBeVisible();

        // Bottom Nav
        for (const item of ['Home', 'Meetings', 'Reminders', 'Groups', 'Family', 'Settings']) {
            await expect(page.getByRole('link', { name: new RegExp(`^${item}$`, 'i') })).toBeVisible();
        }
    });

    test('Create Meeting — Conversational Flow presence', async ({ page }) => {
        await page.goto('/en');
        await page.getByRole('link', { name: /New Meeting/i }).click();

        // Step 1: Meeting type
        for (const type of ['Personal Meeting', 'Group Meeting', 'Virtual Meeting', 'With a Business', 'Playtime', 'Open Call']) {
            await expect(page.getByRole('button', { name: new RegExp(type, 'i') })).toBeVisible();
        }

        await page.getByRole('button', { name: /Personal Meeting|1:1/i }).click();

        // Step 2: Participants (search/import/invite/group)
        await expect(page.getByText(/Who would you like to meet with\?/i)).toBeVisible();
        for (const opt of ['Search', 'Contacts', 'Invite Link', 'Groups']) {
            await expect(page.getByText(new RegExp(opt, 'i'))).toBeVisible();
        }

        // Step 3: Dynamic extras (visible for group ≥4; here just assert component exists when >=4 is chosen)
        await page.getByRole('button', { name: /Group Meeting|Group Event/i }).click();
        await expect(page.getByText(/Forms|Checklists|Attachments|Group Chat/i)).toBeVisible();

        // Step 4: Details
        await expect(page.getByText(/Date & Time|smart suggestions/i)).toBeVisible();
        await expect(page.getByText(/Location/i)).toBeVisible();
        await expect(page.getByRole('button', { name: /Zoom|Meet|Phone/i })).toBeVisible();

        // Step 5: Review + Confirm (+ad-gate for free users)
        await expect(page.getByText(/Does that sound right\?/i)).toBeVisible();
        await expect(page.getByRole('button', { name: /Confirm/i })).toBeVisible();
    });

    test('Meeting Hub page elements', async ({ page }) => {
        // Navigate to a meeting (if deep-link is available, replace with actual id)
        await page.goto('/en/meetings');

        // Pick first meeting card
        const first = page.locator('[data-test="meeting-card"]').first();
        if (await first.count()) {
            await first.click();
        } else {
            test.skip(true, 'No meeting card found to open hub page');
        }

        await expect(page.getByTestId('meeting-header')).toBeVisible();
        await expect(page.getByTestId('meeting-details')).toBeVisible();
        await expect(page.getByTestId('participants-list')).toBeVisible();
        await expect(page.getByRole('button', { name: /I'm Late/i })).toBeVisible();
        await expect(page.getByRole('button', { name: /Go|Join/i })).toBeVisible();
        await expect(page.getByRole('button', { name: /I've Arrived/i })).toBeVisible();
        await expect(page.getByTestId('chat-panel')).toBeVisible();
    });

    test('Reminders, Groups, Family, Playtime routes exist', async ({ page }) => {
        for (const path of ['/en/reminders', '/en/groups', '/en/family', '/en/playtime']) {
            await page.goto(path);
            await expect(page.getByRole('heading')).toBeVisible();
        }
    });

    test('PWA A2HS prompt after 3 sessions', async ({ page }) => {
        await page.goto('/en');
        await expect(page.getByText(/Add App-Oint to your Home Screen/i)).toBeVisible();
    });
});
