#!/usr/bin/env node
// Sync Flutter ARB locales with the list under marketing/public/locales
// For each locale folder in marketing, ensure appoint/l10n/app_<locale>.arb exists
// Populate with English placeholders based on app_en.arb keys

const fs = require('fs');
const path = require('path');

const repoRoot = path.resolve(__dirname, '..', '..');
const marketingLocalesDir = path.join(repoRoot, 'marketing', 'public', 'locales');
const arbDir = path.join(repoRoot, 'appoint', 'l10n');
const templateFile = path.join(arbDir, 'app_en.arb');

if (!fs.existsSync(marketingLocalesDir)) {
  console.error('Locales source not found:', marketingLocalesDir);
  process.exit(1);
}
if (!fs.existsSync(templateFile)) {
  console.error('Flutter template ARB not found:', templateFile);
  process.exit(1);
}

const template = JSON.parse(fs.readFileSync(templateFile, 'utf8'));
const templateKeys = Object.keys(template).filter((k) => !k.startsWith('@@') && !k.startsWith('@'));

const locales = fs.readdirSync(marketingLocalesDir).filter((d) => fs.statSync(path.join(marketingLocalesDir, d)).isDirectory());

let created = 0;
for (const locale of locales) {
  if (locale === 'en') continue; // en already exists
  const arbPath = path.join(arbDir, `app_${locale}.arb`);
  if (fs.existsSync(arbPath)) continue;

  const obj = { "@@locale": locale };
  for (const key of templateKeys) {
    obj[key] = template[key]; // English placeholder
  }
  fs.writeFileSync(arbPath, JSON.stringify(obj, null, 2) + '\n');
  created += 1;
}

console.log(`Ensured Flutter ARBs for ${locales.length} locales. Created ${created} new files.`);


