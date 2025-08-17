#!/usr/bin/env node
// Copy marketing/public/locales to business/public/locales and enterprise-app/public/locales
// Does not modify admin per constraints

const fs = require('fs');
const path = require('path');

const repoRoot = path.resolve(__dirname, '..', '..');
const source = path.join(repoRoot, 'marketing', 'public', 'locales');
const targets = [
  path.join(repoRoot, 'business', 'public', 'locales'),
  path.join(repoRoot, 'enterprise-app', 'public', 'locales'),
];

if (!fs.existsSync(source)) {
  console.error('Source locales not found:', source);
  process.exit(1);
}

function copyDir(src, dest) {
  if (!fs.existsSync(dest)) fs.mkdirSync(dest, { recursive: true });
  for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
    const s = path.join(src, entry.name);
    const d = path.join(dest, entry.name);
    if (entry.isDirectory()) {
      copyDir(s, d);
    } else if (entry.isFile()) {
      fs.mkdirSync(path.dirname(d), { recursive: true });
      fs.copyFileSync(s, d);
    }
  }
}

for (const target of targets) {
  copyDir(source, target);
  console.log('Synced locales to', path.relative(repoRoot, target));
}


