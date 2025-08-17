import { readFile, readdir, stat, mkdir, writeFile } from "node:fs/promises";
import path from "node:path";

const roots = [
  { name: "marketing", dir: "marketing" },
  { name: "business", dir: "business" },
  { name: "enterprise", dir: "enterprise-app" },
  { name: "personal", dir: "appoint" } // Flutter ARB
];

async function walk(dir, files=[]) {
  for (const f of await readdir(dir)) {
    const p = path.join(dir, f);
    const s = await stat(p);
    if (s.isDirectory()) await walk(p, files);
    else files.push(p);
  }
  return files;
}

const report = [];
for (const app of roots) {
  const entry = { app: app.name, locales: [], missing: [], hardcoded: [] };
  try {
    const files = await walk(app.dir);
    // detect locales
    const jsons = files.filter(f => f.match(/locales?\/.*\.(json|arb)$/i));
    entry.locales = jsons.map(f => path.basename(f));
    // hard-coded detection (simple heuristic)
    const code = files.filter(f => f.match(/\.(ts|tsx|js|dart)$/));
    for (const f of code) {
      const txt = (await readFile(f, "utf8"));
      if (txt.match(/Lorem ipsum|TODO|TBD|Placeholder|Mock/i)) entry.hardcoded.push(f);
    }
  } catch {}
  report.push(entry);
}
await mkdir("qa/output", { recursive: true });
await writeFile("qa/output/localization_audit.md", `# i18n Audit\n\n\`\`\`json\n${JSON.stringify(report, null, 2)}\n\`\`\`\n`);
if (report.some(r => r.hardcoded.length)) { console.error("[i18n] FAIL: placeholders/hard-coded strings found"); process.exitCode = 1; }
else console.log("[i18n] OK");
