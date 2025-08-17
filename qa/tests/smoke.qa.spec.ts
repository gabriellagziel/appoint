import { test, expect } from "@playwright/test";

test("smoke test - basic page load", async ({ page }) => {
  await page.goto("http://localhost:3000/");
  await expect(page).toHaveTitle(/app-oint/i);
  await expect(page.getByRole("heading")).toBeVisible();
});

test("marketing page loads", async ({ page }) => {
  await page.goto("http://localhost:3000/");
  await expect(page.getByText(/ultimate time organizer/i)).toBeVisible();
});
