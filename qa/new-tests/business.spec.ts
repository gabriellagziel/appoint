import { test, expect } from "@playwright/test";
const BASE = "http://localhost:3002";

test("Dashboard shell + create client/meeting", async ({ page }) => {
  await page.goto(BASE + "/");
  await expect(page.getByRole("navigation")).toBeVisible();
  await expect(page.getByRole("banner")).toBeVisible();
  await page.getByRole("button", { name: /new client/i }).click();
  await page.getByPlaceholder(/name/i).fill("Client QA");
  await page.getByRole("button", { name: /save/i }).click();
  await page.getByRole("button", { name: /new meeting/i }).click();
  await page.getByPlaceholder(/title/i).fill("Biz Sync");
  await page.getByRole("button", { name: /create/i }).click();
  await expect(page.getByText(/Biz Sync/i)).toBeVisible();
});
