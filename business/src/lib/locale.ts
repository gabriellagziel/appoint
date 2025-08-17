import fs from 'fs';
import path from 'path';
import { headers, cookies } from 'next/headers';

const LOCALES_DIR = path.join(process.cwd(), 'public', 'locales');

export function detectLocale(): string {
  const cookieStore = cookies();
  const langCookie = cookieStore.get('lang')?.value;
  if (langCookie) return normalize(langCookie);

  const h = headers();
  const al = h.get('accept-language') || '';
  const first = al.split(',')[0]?.trim();
  if (first) return normalize(first);
  return 'en';
}

export function normalize(code: string | undefined | null): string {
  if (!code) return 'en';
  return code.replace('_', '-').toLowerCase();
}

export function resolveLocaleFolder(code: string): string {
  const exact = path.join(LOCALES_DIR, code);
  if (fs.existsSync(exact)) return code;
  const underscore = code.replace('-', '_');
  if (fs.existsSync(path.join(LOCALES_DIR, underscore))) return underscore;
  const short = code.split('-')[0];
  if (fs.existsSync(path.join(LOCALES_DIR, short))) return short;
  return 'en';
}

export function loadCommon(locale: string): Record<string, unknown> {
  const folder = resolveLocaleFolder(locale);
  const file = path.join(LOCALES_DIR, folder, 'common.json');
  if (fs.existsSync(file)) {
    try { return JSON.parse(fs.readFileSync(file, 'utf8')); } catch {}
  }
  return {};
}


