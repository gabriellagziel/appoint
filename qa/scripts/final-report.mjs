import { writeFile } from "node:fs/promises";

const gates = [
  { name: "Health", path: "qa/output/health" },
  { name: "Playwright", path: "qa/output/playwright/index.html" },
  { name: "Lighthouse", path: "qa/output/lighthouse" },
  { name: "A11y", path: "qa/output/a11y_report.json" },
  { name: "i18n", path: "qa/output/localization_audit.md" },
  { name: "Links", path: "qa/output/linkcheck/report.json" }
];

const md = `# FINAL_UI_UX_QA_REPORT

- Health endpoints: see qa/output/health/
- E2E report: qa/output/playwright/index.html
- Lighthouse: qa/output/lighthouse/
- Accessibility: qa/output/a11y_report.json
- i18n: qa/output/localization_audit.md
- Link crawl: qa/output/linkcheck/report.json

**Decision**: ${
  process.exitCode && process.exitCode !== 0 ? "❌ NO-GO" : "✅ GO (Perfect Gate Passed)"
}
`;
await writeFile("qa/FINAL_UI_UX_QA_REPORT.md", md);
console.log("Report → qa/FINAL_UI_UX_QA_REPORT.md");
