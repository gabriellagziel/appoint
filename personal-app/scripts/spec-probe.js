import fs from 'node:fs';
import path from 'node:path';

const mustHaveRoutes = ['/', '/meetings', '/reminders', '/groups', '/family', '/playtime', '/settings'];
const root = process.env.APP_DIR || path.resolve(process.cwd());

function has(p) { return fs.existsSync(p); }

// Check for App Router structure
const appDir = path.join(root, 'src', 'app');
const found = [];
const missing = [];

for (const r of mustHaveRoutes) {
  if (r === '/') {
    // Check for root page
    const rootPage = path.join(appDir, 'page.tsx');
    const localePage = path.join(appDir, '[locale]', 'page.tsx');
    if (has(rootPage) || has(localePage)) {
      found.push(`${r} -> ${has(rootPage) ? rootPage : localePage}`);
    } else {
      missing.push(r);
    }
  } else {
    // Check for locale-based routes
    const localeRoute = path.join(appDir, '[locale]', r.slice(1), 'page.tsx');
    if (has(localeRoute)) {
      found.push(`${r} -> ${localeRoute}`);
    } else {
      missing.push(r);
    }
  }
}

console.log('FOUND:\n' + found.join('\n'));
if (missing.length) {
  console.error('\nMISSING ROUTES:\n' + missing.join('\n'));
  process.exit(1);
} else {
  console.log('\n✅ All required routes found!');
}
