import { test, expect } from "@playwright/test";
const BASE = "http://localhost:3003";

test("Ambassadors approve/reject + ads rule checkpoints", async ({ page }) => {
  await page.goto(BASE + "/ambassadors");
  await expect(page.getByText(/pending/i)).toBeVisible();
  await page.getByRole("button", { name: /approve/i }).click();
  await expect(page.getByText(/approved/i)).toBeVisible();

  await page.goto(BASE + "/ads");
  for (const p of ["create_meeting","preview_meeting","pre_start"]) {
    await expect(page.getByText(new RegExp(p, "i"))).toBeVisible();
  }
});

test("Users/Groups + Analytics present", async ({ page }) => {
  await page.goto(BASE + "/users");
  await expect(page.getByRole("table")).toBeVisible();
  await page.goto(BASE + "/analytics");
  await expect(page.getByText(/events|traffic|errors/i)).toBeVisible();
});
