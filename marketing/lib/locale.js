import fs from 'fs';
import path from 'path';

const LOCALES_DIR = path.join(process.cwd(), 'public', 'locales');

export function detectLocale(req) {
  // Priority: query ?lang=, cookie lang, Accept-Language, default 'en'
  try {
    const url = new URL(req.url, 'http://localhost');
    const q = url.searchParams.get('lang');
    if (q) return normalizeLocale(q);
  } catch {}

  const cookie = req.headers?.cookie || '';
  const m = cookie.match(/(?:^|; )lang=([^;]+)/);
  if (m) return normalizeLocale(decodeURIComponent(m[1]));

  const al = req.headers['accept-language'];
  if (al) {
    const code = al.split(',')[0]?.trim();
    if (code) return normalizeLocale(code);
  }
  return 'en';
}

export function normalizeLocale(code) {
  if (!code) return 'en';
  return code.replace('_', '-').toLowerCase();
}

export function loadCommonMessages(locale) {
  const candidates = uniqueCandidates(locale);
  for (const c of candidates) {
    const folder = path.join(LOCALES_DIR, mapLocaleFolder(c));
    if (!fs.existsSync(folder)) continue;
    try {
      const files = fs.readdirSync(folder).filter((f) => f.endsWith('.json'));
      const merged = {};
      for (const f of files) {
        try {
          const obj = JSON.parse(fs.readFileSync(path.join(folder, f), 'utf8'));
          deepMerge(merged, obj);
        } catch {}
      }
      return { locale: c, messages: merged };
    } catch {}
  }
  return { locale: 'en', messages: {} };
}

function uniqueCandidates(locale) {
  const list = [];
  if (locale) list.push(locale);
  const short = locale?.split('-')[0];
  if (short && short !== locale) list.push(short);
  if (!list.includes('en')) list.push('en');
  return list;
}

function mapLocaleFolder(code) {
  // Map hyphen to underscore variants if needed, prefer exact folder
  const exact = path.join(LOCALES_DIR, code);
  if (fs.existsSync(exact)) return code;
  const underscore = code.replace('-', '_');
  const underscorePath = path.join(LOCALES_DIR, underscore);
  if (fs.existsSync(underscorePath)) return underscore;
  const short = code.split('-')[0];
  if (fs.existsSync(path.join(LOCALES_DIR, short))) return short;
  return 'en';
}

function deepMerge(target, source) {
  for (const key of Object.keys(source || {})) {
    const src = source[key];
    if (src && typeof src === 'object' && !Array.isArray(src)) {
      if (!target[key] || typeof target[key] !== 'object') target[key] = {};
      deepMerge(target[key], src);
    } else {
      target[key] = src;
    }
  }
}


