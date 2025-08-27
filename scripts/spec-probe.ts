import fs from 'node:fs';
import path from 'node:path';

const mustHaveRoutes = ['/', '/meetings', '/reminders', '/groups', '/family', '/playtime', '/settings'];
const root = process.env.APP_DIR || path.resolve(process.cwd());

function has(p: string) { return fs.existsSync(p); }

const candidates = ['app', 'pages'].map(dir => path.join(root, dir));

const found: string[] = [];
const missing: string[] = [];

for (const c of candidates) {
    for (const r of mustHaveRoutes) {
        const ap = path.join(c, r === '/' ? 'page.tsx' : r.slice(1), 'page.tsx');
        const pp = path.join(c, r === '/' ? 'index.tsx' : r.slice(1) + '.tsx');
        if (has(ap) || has(pp)) found.push(`${r} -> ${ap} | ${pp}`); else missing.push(r);
    }
}

console.log('FOUND:\n' + found.join('\n'));
if (missing.length) {
    console.error('\nMISSING ROUTES:\n' + missing.join('\n'));
    process.exit(1);
}
