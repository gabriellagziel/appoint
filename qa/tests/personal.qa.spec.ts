import { test, expect } from "@playwright/test";

const BASE = "http://localhost:3020";

test.describe("Personal PWA – critical flows", () => {
  test("Home has Quick Actions + full menu", async ({ page }) => {
    await page.goto(BASE + "/#/home");
    await expect(page.getByText(/Create Meeting/i)).toBeVisible();
    await expect(page.getByText(/Create Reminder/i)).toBeVisible();
    for (const item of ["Meetings","Reminders","Family","Groups","Playtime","Settings"]) {
      await expect(page.getByText(item, { exact: false })).toBeVisible();
    }
  });

  test("Create Meeting → Review → Create → Meeting page", async ({ page }) => {
    await page.goto(BASE + "/#/create/meeting");
    await page.getByRole("button", { name: /personal/i }).click();
    await page.getByPlaceholder(/add participants/i).fill("John");
    await page.getByPlaceholder(/description/i).fill("QA meeting");
    await page.getByRole("button", { name: /review/i }).click();
    await page.getByRole("button", { name: /create/i }).click();
    await expect(page).toHaveURL(/\/#\/meeting\/.+/);
    await expect(page.getByText(/participants/i)).toBeVisible();
    await expect(page.getByRole("button", { name: /i'm late/i })).toBeVisible();
  });

  test("Reminders create + list", async ({ page }) => {
    await page.goto(BASE + "/#/reminders/create");
    await page.getByPlaceholder(/title/i).fill("Groceries");
    await page.getByRole("button", { name: /save/i }).click();
    await page.goto(BASE + "/#/reminders");
    await expect(page.getByText(/Groceries/i)).toBeVisible();
  });

  test("Groups create + invite link appears", async ({ page }) => {
    await page.goto(BASE + "/#/groups/create");
    await page.getByPlaceholder(/group name/i).fill("QA Family");
    await page.getByRole("button", { name: /create group/i }).click();
    await expect(page.getByText(/invite link/i)).toBeVisible();
  });

  test("Playtime exists in menu", async ({ page }) => {
    await page.goto(BASE + "/#/home");
    await expect(page.getByText(/Playtime/i)).toBeVisible();
  });
});
