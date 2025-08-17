import { test, expect } from "@playwright/test";
const BASE = "http://localhost:3001";

test("Docs-first onboarding + API key screen", async ({ page }) => {
  await page.goto(BASE + "/");
  await expect(page.getByText(/API onboarding/i)).toBeVisible();
  await expect(page.getByRole("link", { name: /docs/i })).toBeVisible();
  await page.goto(BASE + "/keys");
  await expect(page.getByText(/api key/i)).toBeVisible();
});
