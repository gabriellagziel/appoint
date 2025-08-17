import { request } from "undici";
import { mkdir, writeFile } from "node:fs/promises";
import apps from "../apps.json" with { type: "json" };

const paths = {
  marketing: ["/", "/health"],
  business: ["/", "/health"],
  enterprise: ["/", "/health", "/keys"],
  admin: ["/", "/health", "/ambassadors", "/analytics"],
  personal: ["/#/home"]
};

const results = {};
await mkdir("qa/output/linkcheck", { recursive: true });

for (const [name, cfg] of Object.entries(apps)) {
  const list = [];
  for (const p of paths[name] || ["/"]) {
    const url = `http://localhost:${cfg.port}${p}`;
    try {
      const res = await request(url);
      list.push({ url, status: res.statusCode });
      if (res.statusCode >= 400) throw new Error(`${url} → ${res.statusCode}`);
    } catch (e) {
      list.push({ url, error: e.message });
      process.exitCode = 1;
    }
  }
  results[name] = list;
}
await writeFile("qa/output/linkcheck/report.json", JSON.stringify(results, null, 2));
