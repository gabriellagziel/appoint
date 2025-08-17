import { spawn } from "node:child_process";
import { createServer } from "http";
import { readFile } from "node:fs/promises";
import path from "node:path";
import apps from "../apps.json" with { type: "json" };
import sirv from "sirv";

const procs = [];
for (const [name, cfg] of Object.entries(apps)) {
  if (cfg.static) {
    const serve = sirv(cfg.cwd, { dev: true });
    const srv = createServer((req, res) => serve(req, res));
    srv.listen(cfg.port, () => console.log(`[serve] ${name} → http://localhost:${cfg.port}`));
  } else {
    const [cmd, ...args] = cfg.start.split(" ");
    const p = spawn(cmd, args, { cwd: path.resolve(cfg.cwd), stdio: "inherit", env: { ...process.env, PORT: String(cfg.port) } });
    procs.push(p);
    console.log(`[start] ${name} → http://localhost:${cfg.port}`);
  }
}
process.on("SIGINT", () => { procs.forEach(p => p.kill()); process.exit(0); });
