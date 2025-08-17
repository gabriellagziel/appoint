#!/usr/bin/env node
// Validate ARB files in appoint/l10n for key consistency across locales
const fs = require('fs');
const path = require('path');

const arbDir = path.resolve(__dirname, '../../appoint/l10n');
if (!fs.existsSync(arbDir)) {
  console.error('ARB directory not found:', arbDir);
  process.exit(1);
}

const files = fs.readdirSync(arbDir).filter((f) => f.endsWith('.arb'));
if (!files.length) {
  console.error('No ARB files found in', arbDir);
  process.exit(1);
}

function loadKeys(file) {
  const json = JSON.parse(fs.readFileSync(path.join(arbDir, file), 'utf8'));
  return Object.keys(json).filter((k) => !k.startsWith('@@') && !k.startsWith('@'));
}

const localeToKeys = {};
for (const f of files) {
  const locale = f.replace(/^.*app_|\.arb$/g, '') || 'en';
  try {
    localeToKeys[locale] = new Set(loadKeys(f));
  } catch (e) {
    console.error('Failed to parse', f, e.message);
    process.exitCode = 2;
  }
}

const locales = Object.keys(localeToKeys);
const base = localeToKeys['en'] || localeToKeys[locales[0]];
if (!base) {
  console.error('No base locale keys found. Ensure app_en.arb exists.');
  process.exit(1);
}

let hasIssues = false;
for (const loc of locales) {
  const keys = localeToKeys[loc];
  const missing = [...base].filter((k) => !keys.has(k));
  const extra = [...keys].filter((k) => !base.has(k));
  if (missing.length || extra.length) {
    hasIssues = true;
    console.log(`Locale ${loc} issues:`);
    if (missing.length) console.log('  Missing keys:', missing.join(', '));
    if (extra.length) console.log('  Extra keys:', extra.join(', '));
  }
}

if (!hasIssues) {
  console.log('All ARB locales have consistent keys.');
}

process.exit(hasIssues ? 1 : 0);



