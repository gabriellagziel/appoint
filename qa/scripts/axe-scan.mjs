import { chromium } from "@playwright/test";
import { mkdir, writeFile } from "node:fs/promises";
import apps from "../apps.json" with { type: "json" };

const targets = [
  { name: "marketing", path: "/" },
  { name: "business", path: "/" },
  { name: "admin", path: "/" },
  { name: "personal", path: "/#/home" }
];

await mkdir("qa/output", { recursive: true });
const browser = await chromium.launch();
const page = await browser.newPage();
const results = [];

for (const t of targets) {
  const cfg = apps[t.name];
  const url = `http://localhost:${cfg.port}${t.path}`;
  await page.goto(url);
  await page.addScriptTag({
    url: "https://cdnjs.cloudflare.com/ajax/libs/axe-core/4.9.1/axe.min.js",
    type: "text/javascript"
  });
  const res = await page.evaluate(async () => {
    // @ts-ignore
    return await axe.run(document, { resultTypes: ["violations"] });
  });
  results.push({ name: t.name, url, violations: res.violations });
  if (res.violations.some(v => v.impact === "critical")) {
    console.error(`[axe] FAIL: ${t.name} has critical violations`);
    process.exitCode = 1;
  } else {
    console.log(`[axe] OK: ${t.name}`);
  }
}
await writeFile("qa/output/a11y_report.json", JSON.stringify(results, null, 2));
await browser.close();
