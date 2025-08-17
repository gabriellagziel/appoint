import lighthouse from "lighthouse";
import chromeLauncher from "chrome-launcher";
import { mkdir, writeFile } from "node:fs/promises";

const targets = [
  { name: "marketing-mobile", url: "http://localhost:3000/", formFactor: "mobile" },
  { name: "marketing-desktop", url: "http://localhost:3000/", formFactor: "desktop" },
  { name: "personal-mobile", url: "http://localhost:3020/#/home", formFactor: "mobile" },
  { name: "personal-desktop", url: "http://localhost:3020/#/home", formFactor: "desktop" }
];

await mkdir("qa/output/lighthouse", { recursive: true });

const chrome = await chromeLauncher.launch({ chromeFlags: ["--headless"] });
for (const t of targets) {
  const config = {
    extends: "lighthouse:default",
    settings: { 
      formFactor: t.formFactor, 
      screenEmulation: { mobile: t.formFactor === "mobile" },
      throttlingMethod: "simulate",
      maxWaitForFcp: 60000,
      maxWaitForLoad: 90000
    }
  };
  const { lhr, report } = await lighthouse(t.url, { port: chrome.port }, config);
  await writeFile(`qa/output/lighthouse/${t.name}.html`, report);
  const { performance, seo, accessibility, "best-practices": best } = lhr.categories;
  if (performance.score < 0.9 || seo.score < 0.95 || accessibility.score < 0.95 || best.score < 0.95) {
    console.error(`[lighthouse] FAIL: ${t.name} scores too low`);
    process.exitCode = 1;
  } else {
    console.log(`[lighthouse] OK: ${t.name}`);
  }
}
await chrome.kill();
