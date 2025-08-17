import apps from "../apps.json" with { type: "json" };
import { writeFile, mkdir } from "node:fs/promises";
import { request } from "undici";

await mkdir("qa/output/health", { recursive: true });
for (const [name, cfg] of Object.entries(apps)) {
  const url = `http://localhost:${cfg.port}${cfg.health}`;
  try {
    const res = await request(url, { maxRedirections: 5 });
    const body = await res.body.text();
    if (res.statusCode !== 200) throw new Error(`${url} → ${res.statusCode}`);
    await writeFile(`qa/output/health/${name}.json`, body || '{"ok":true}');
    console.log(`[health] ${name} OK`);
  } catch (e) {
    console.error(`[health] ${name} FAIL: ${e.message}`);
    process.exitCode = 1;
  }
}
