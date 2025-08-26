'use client';
import { LOCALES, normalizeLocale } from '../../i18n';
import { useParams } from 'next/navigation';

export default function LocaleSwitcher() {
  const { locale } = useParams<{locale:string}>();
  const cur = normalizeLocale(locale || 'en');

  function setLocale(l: string) {
    // 6 months
    document.cookie = `NEXT_LOCALE=${l}; Path=/; Max-Age=${60*60*24*180}; SameSite=Lax`;
    const parts = location.pathname.split('/');
    parts[1] = l; // swap locale segment
    location.href = parts.join('/') + location.search + location.hash;
  }

  return (
    <label className="flex items-center gap-2 text-sm">
      <span>🌐</span>
      <select
        value={cur}
        onChange={e => setLocale(e.target.value)}
        className="rounded-md border px-2 py-1"
      >
        {LOCALES.map(l => <option key={l} value={l}>{l}</option>)}
      </select>
    </label>
  );
}
