import { test, expect } from "@playwright/test";
const BASE = "http://localhost:3000";

test("Landing explains system + links", async ({ page }) => {
  await page.goto(BASE + "/");
  await expect(page.getByText(/ultimate time organizer/i)).toBeVisible();
  for (const link of ["Personal","Business","Enterprise"]) {
    await expect(page.getByRole("link", { name: new RegExp(link, "i") })).toBeVisible();
  }
});
