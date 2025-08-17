/* eslint-disable */
const { execSync } = require('node:child_process');
const fs = require('node:fs');

const targets = [
  ['main', 'http://127.0.0.1:3000/'],
  ['business_root', 'http://127.0.0.1:3001/'],
  ['business_dashboard', 'http://127.0.0.1:3001/dashboard'],
  ['enterprise_root', 'http://127.0.0.1:3002/'],
  ['enterprise_dashboard', 'http://127.0.0.1:3002/dashboard'],
  ['api_portal_root', 'http://127.0.0.1:3003/'],
  ['admin_login', 'http://127.0.0.1:3005/login'],
  ['personal_root', 'http://127.0.0.1:3010/']
];

fs.mkdirSync('qa/lighthouse', { recursive: true });

for (const [name, url] of targets) {
  const outDir = `qa/lighthouse/${name}`;
  fs.mkdirSync(outDir, { recursive: true });
  const flags = "--quiet --throttling-method=provided --screenEmulation.disabled --no-enable-error-reporting";
  try {
    execSync(`npx --yes lighthouse ${url} --output=json --output=html ${flags} --chrome-flags='--headless=new --disable-dev-shm-usage --no-sandbox' --preset=desktop --output-path=${outDir}/desktop`, { stdio: 'inherit' });
  } catch {}
  try {
    execSync(`npx --yes lighthouse ${url} --output=json --output=html ${flags} --chrome-flags='--headless=new --disable-dev-shm-usage --no-sandbox' --preset=mobile --output-path=${outDir}/mobile`, { stdio: 'inherit' });
  } catch {}
}


