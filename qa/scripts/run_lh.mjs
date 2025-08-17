import { execSync } from 'node:child_process';
import fs from 'node:fs';

const targets = [
  ['MAIN', 'https://www.app-oint.com/'],
  ['PERSONAL', 'https://app.app-oint.com/'],
  ['BUSINESS', 'https://business.app-oint.com/'],
  ['ENTERPRISE', 'https://enterprise.app-oint.com/'],
  ['API_PORTAL', 'https://api.app-oint.com/'],
  ['ADMIN', 'https://admin.app-oint.com/login']
];

fs.mkdirSync('qa/lighthouse', { recursive: true });
for (const [name, url] of targets) {
  console.log(`LH ${name}: ${url}`);
  const outDir = `qa/lighthouse/${name.toLowerCase()}`;
  fs.mkdirSync(outDir, { recursive: true });
  const flags = "--quiet --throttling-method=provided --screenEmulation.disabled --no-enable-error-reporting";
  execSync(`npx --yes lighthouse ${url} --output=json --output=html ${flags} --chrome-flags='--headless=new --disable-dev-shm-usage --no-sandbox' --preset=desktop --output-path=${outDir}/desktop`, { stdio: 'inherit' });
  execSync(`npx --yes lighthouse ${url} --output=json --output=html ${flags} --chrome-flags='--headless=new --disable-dev-shm-usage --no-sandbox' --preset=mobile --output-path=${outDir}/mobile`, { stdio: 'inherit' });
}

