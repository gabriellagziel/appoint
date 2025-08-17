#!/usr/bin/env node
// Ensure all Next.js locale JSON files are complete across locales by
// backfilling missing keys from English. Apps: marketing, business, enterprise-app.

const fs = require('fs');
const path = require('path');

const repoRoot = path.resolve(__dirname, '..', '..');
const apps = ['marketing', 'business', 'enterprise-app'];

function listLocales(dir) {
  if (!fs.existsSync(dir)) return [];
  return fs.readdirSync(dir).filter((d) => fs.statSync(path.join(dir, d)).isDirectory());
}

function deepKeys(obj, prefix = '') {
  const keys = [];
  for (const k of Object.keys(obj || {})) {
    const v = obj[k];
    const p = prefix ? `${prefix}.${k}` : k;
    if (v && typeof v === 'object' && !Array.isArray(v)) {
      keys.push(...deepKeys(v, p));
    } else {
      keys.push(p);
    }
  }
  return keys;
}

function get(obj, pathKey) {
  const parts = pathKey.split('.');
  let cur = obj;
  for (const part of parts) {
    if (cur == null) return undefined;
    cur = cur[part];
  }
  return cur;
}

function set(obj, pathKey, value) {
  const parts = pathKey.split('.');
  let cur = obj;
  for (let i = 0; i < parts.length; i += 1) {
    const part = parts[i];
    if (i === parts.length - 1) {
      cur[part] = value;
    } else {
      if (!cur[part] || typeof cur[part] !== 'object') cur[part] = {};
      cur = cur[part];
    }
  }
}

function ensureFileCompleteness(baseFile, localeFile) {
  const base = JSON.parse(fs.readFileSync(baseFile, 'utf8'));
  let target = {};
  if (fs.existsSync(localeFile)) {
    try { target = JSON.parse(fs.readFileSync(localeFile, 'utf8')); } catch {}
  }
  const baseKeyList = deepKeys(base);
  let added = 0;
  for (const k of baseKeyList) {
    if (get(target, k) === undefined) {
      set(target, k, get(base, k)); // backfill English text
      added += 1;
    }
  }
  if (added > 0) {
    fs.mkdirSync(path.dirname(localeFile), { recursive: true });
    fs.writeFileSync(localeFile, JSON.stringify(target, null, 2) + '\n');
  }
  return { added };
}

let totalAdded = 0;
for (const app of apps) {
  const localesDir = path.join(repoRoot, app, 'public', 'locales');
  const locales = listLocales(localesDir);
  if (!locales.includes('en')) continue;
  const enDir = path.join(localesDir, 'en');
  const baseFiles = fs.readdirSync(enDir).filter((f) => f.endsWith('.json'));
  for (const locale of locales) {
    if (locale === 'en') continue;
    for (const file of baseFiles) {
      const baseFile = path.join(enDir, file);
      const localeFile = path.join(localesDir, locale, file);
      const { added } = ensureFileCompleteness(baseFile, localeFile);
      if (added) {
        totalAdded += added;
        console.log(`[${app}] ${locale}/${file}: +${added} keys`);
      }
    }
  }
}

console.log(`Done. Backfilled ${totalAdded} keys across apps.`);


