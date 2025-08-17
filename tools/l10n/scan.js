#!/usr/bin/env node
/*
  Lightweight l10n audit scanner.
  - Scans TS/TSX/JS/JSX in Next.js apps and Dart in Flutter app
  - Detects likely hard-coded user-facing strings
  - Respects common i18n allowlists (t(), useTranslations(), formatMessage(), AppLocalizations)
  - Outputs JSON report to tools/l10n/report.json
*/

const fs = require('fs');
const path = require('path');

const repoRoot = path.resolve(__dirname, '..', '..');

const APPS = [
  { name: 'admin', dir: 'admin', type: 'next' },
  { name: 'business', dir: 'business', type: 'next' },
  { name: 'enterprise-app', dir: 'enterprise-app', type: 'next' },
  { name: 'appoint', dir: 'appoint', type: 'flutter' },
];

const NEXT_EXTS = new Set(['.ts', '.tsx', '.js', '.jsx']);
const DART_EXTS = new Set(['.dart']);

function walkFiles(startDir, shouldIncludeFile) {
  const results = [];
  const stack = [startDir];
  while (stack.length) {
    const current = stack.pop();
    let entries;
    try {
      entries = fs.readdirSync(current, { withFileTypes: true });
    } catch (e) {
      continue;
    }
    for (const entry of entries) {
      const full = path.join(current, entry.name);
      if (entry.isDirectory()) {
        // Skip known heavy or irrelevant directories
        if (['node_modules', '.next', '.dart_tool', 'build', 'dist', 'out', 'coverage'].includes(entry.name)) continue;
        stack.push(full);
      } else if (entry.isFile()) {
        if (shouldIncludeFile(full)) results.push(full);
      }
    }
  }
  return results;
}

function detectHardcodedStringsInText(line) {
  const findings = [];
  const textBetweenTags = />\s*([^<>]{3,}?[A-Za-z][^<>]{2,})\s*</g; // JSX inner text
  let m;
  while ((m = textBetweenTags.exec(line)) !== null) {
    findings.push({ kind: 'jsx-text', text: m[1].trim() });
  }

  const propString = /\b(title|label|aria-label|placeholder|alt|buttonText|text|children|helperText|toast|tooltip)\s*[:=]\s*(["'])([^"']{3,}?)["']/gi;
  while ((m = propString.exec(line)) !== null) {
    findings.push({ kind: 'prop', text: m[3].trim() });
  }

  const bareString = /(["'])([^"']{3,}?)["']/g; // general strings
  while ((m = bareString.exec(line)) !== null) {
    const value = m[2];
    findings.push({ kind: 'literal', text: value.trim() });
  }
  return findings;
}

function isAllowlisted(line, appType) {
  if (appType === 'next') {
    if (/\b(t\(|useTranslations\(|getTranslations\(|formatMessage\(|intl\.)/i.test(line)) return true;
  } else if (appType === 'flutter') {
    if (/\b(AppLocalizations\.|S\.of\(|context\.l10n\b)/.test(line)) return true;
  }
  return false;
}

function looksNonUserFacing(text) {
  // Heuristics to filter technical strings
  if (text.length < 3) return true;
  if (/https?:\/\//i.test(text)) return true;
  if (/^[a-z0-9_.-]+\/[a-z0-9_.-]+/i.test(text)) return true; // paths
  if (/^[A-Z0-9_]{3,}$/.test(text)) return true; // constants/ENV
  if (/^[a-z0-9._-]+$/.test(text)) return true; // likely keys or identifiers
  if (/\{\{.*\}\}|\$\{.*\}/.test(text)) return true; // templates
  if (/^#[0-9a-fA-F]{3,6}$/.test(text)) return true; // colors
  if (/^\d[\d\s:.,/-]*$/.test(text)) return true; // pure numbers/dates
  return false;
}

function scanFile(filePath, appType) {
  const findings = [];
  let content;
  try {
    content = fs.readFileSync(filePath, 'utf8');
  } catch (e) {
    return findings;
  }
  const lines = content.split(/\r?\n/);
  for (let i = 0; i < lines.length; i += 1) {
    const line = lines[i];
    if (isAllowlisted(line, appType)) continue;
    if (/\b(import|from)\b\s+['"].+['"];?/.test(line)) continue;
    if (/\brequire\(\s*['"].+['"]\s*\)/.test(line)) continue;

    // Dart specific: skip generated/localizations files
    if (appType === 'flutter' && /(g\.dart|freezed\.dart|gen_l10n|generated|l10n)/.test(filePath)) continue;

    const candidates = detectHardcodedStringsInText(line)
      .filter(({ text }) => text && !looksNonUserFacing(text))
      .map(({ kind, text }) => ({
        kind,
        text: text.length > 120 ? text.slice(0, 117) + '…' : text,
        line: i + 1,
      }));
    // Additional Dart UI hint: Text('...')
    if (appType === 'flutter') {
      const m = line.match(/\bText\(\s*(["'])([^"']{3,}?)\1/);
      if (m && !looksNonUserFacing(m[2])) {
        candidates.push({ kind: 'dart-Text', text: m[2], line: i + 1 });
      }
    }
    findings.push(...candidates);
  }
  return findings;
}

function detectLocales() {
  const result = {};
  // Admin/business/enterprise-app (Next.js)
  for (const app of APPS) {
    if (app.type === 'next') {
      const appRoot = path.join(repoRoot, app.dir);
      const publicLocales = path.join(appRoot, 'public', 'locales');
      let locales = [];
      if (fs.existsSync(publicLocales)) {
        try {
          locales = fs.readdirSync(publicLocales).filter((d) => fs.statSync(path.join(publicLocales, d)).isDirectory());
        } catch {}
      }
      result[app.name] = {
        framework: locales.length ? 'Next.js i18n (static locales)' : 'None detected',
        locales,
        defaultLocale: locales.includes('en') ? 'en' : (locales[0] || 'en'),
      };
    } else if (app.type === 'flutter') {
      const arbDir = path.join(repoRoot, 'appoint', 'l10n');
      let locales = [];
      if (fs.existsSync(arbDir)) {
        locales = fs.readdirSync(arbDir)
          .filter((f) => f.endsWith('.arb'))
          .map((f) => f.replace(/^.*app_|\.arb$/g, '')) // crude: app_en.arb -> en
          .filter((code) => code);
      }
      result[app.name] = {
        framework: 'Flutter gen-l10n',
        locales,
        defaultLocale: locales.includes('en') ? 'en' : (locales[0] || 'en'),
      };
    }
  }
  return result;
}

function main() {
  const startedAt = new Date().toISOString();
  const report = {
    startedAt,
    repoRoot,
    apps: {},
    summary: {},
    locales: detectLocales(),
  };

  for (const app of APPS) {
    const appRoot = path.join(repoRoot, app.dir);
    const includeFile = (file) => {
      const ext = path.extname(file);
      if (app.type === 'next') return NEXT_EXTS.has(ext);
      if (app.type === 'flutter') return DART_EXTS.has(ext) && file.includes(path.join('appoint', 'lib'));
      return false;
    };

    const files = walkFiles(appRoot, includeFile);
    const findings = [];
    for (const file of files) {
      const fileFindings = scanFile(file, app.type);
      if (fileFindings.length) {
        findings.push({ file: path.relative(repoRoot, file), findings: fileFindings });
      }
    }
    const totalFindings = findings.reduce((acc, f) => acc + f.findings.length, 0);
    report.apps[app.name] = {
      app: app.name,
      type: app.type,
      root: path.relative(repoRoot, appRoot),
      filesScanned: files.length,
      filesWithFindings: findings.length,
      totalFindings,
      findings,
    };
  }

  // Build summary
  for (const app of APPS) {
    const a = report.apps[app.name];
    report.summary[app.name] = {
      filesScanned: a.filesScanned,
      filesWithFindings: a.filesWithFindings,
      totalFindings: a.totalFindings,
      locales: report.locales[app.name],
    };
  }

  const outDir = path.join(repoRoot, 'tools', 'l10n');
  if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });
  const outPath = path.join(outDir, 'report.json');
  fs.writeFileSync(outPath, JSON.stringify(report, null, 2));

  // Console summary
  console.log('l10n scan summary:');
  for (const app of APPS) {
    const s = report.summary[app.name];
    const loc = s.locales.locales.length ? s.locales.locales.join(', ') : 'none';
    console.log(`- ${app.name}: ${s.filesWithFindings}/${s.filesScanned} files with findings, ${s.totalFindings} strings. Locales: ${loc}`);
  }
  console.log(`Report written to ${path.relative(repoRoot, outPath)}`);
}

main();



