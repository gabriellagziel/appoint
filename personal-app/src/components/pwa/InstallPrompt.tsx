'use client';
import { useEffect, useRef, useState } from 'react';
import { normalizeLocale } from '../../i18n';

type BIP = Event & { prompt: () => Promise<void>; userChoice?: Promise<any> };

const COOKIE = 'A2HS_SESSIONS';
const HIDE_KEY = 'appoint.pwa.banner.hide';
const MIN_SESSIONS = 3;

function getCookie(name: string) {
    const m = document.cookie.match(new RegExp('(^| )' + name + '=([^;]+)'));
    return m ? decodeURIComponent(m[2]) : '';
}
function setCookie(name: string, value: string, days = 180) {
    const exp = new Date(Date.now() + days * 864e5).toUTCString();
    document.cookie = `${name}=${encodeURIComponent(value)}; Path=/; Expires=${exp}; SameSite=Lax`;
}

export default function InstallPrompt({ locale }: { locale: string }) {
    const loc = normalizeLocale(locale);
    const [ready, setReady] = useState(false);
    const deferred = useRef<BIP | null>(null);

    useEffect(() => {
        // Count sessions
        let n = Number(getCookie(COOKIE) || '0');
        n = isNaN(n) ? 0 : n + 1;
        setCookie(COOKIE, String(n));

        // iOS Safari does not support beforeinstallprompt; show "how to install" tip instead
        const isIOS = /iphone|ipad|ipod/i.test(navigator.userAgent);
        const isStandalone = (window.matchMedia && window.matchMedia('(display-mode: standalone)').matches) || (window.navigator as any).standalone;
        if (isStandalone || localStorage.getItem(HIDE_KEY) === '1') return;

        if (isIOS) {
            if (n >= MIN_SESSIONS) setReady(true);
            return;
        }

        const handler = (e: Event) => {
            e.preventDefault();
            deferred.current = e as BIP;
            if (n >= MIN_SESSIONS) setReady(true);
        };
        window.addEventListener('beforeinstallprompt', handler);
        return () => window.removeEventListener('beforeinstallprompt', handler);
    }, []);

      if (!ready) return null;

  const translations = {
    en: { title: 'Add App-Oint to Home', body: 'Install the app for a faster, full-screen experience.', btn: 'Install', later: 'Later', ios: 'Tap Share → "Add to Home Screen"' },
    it: { title: 'Aggiungi App-Oint alla Home', body: "Installa l'app per un'esperienza migliore a schermo intero.", btn: 'Installa', later: 'Più tardi', ios: 'Tocca Condividi → "Aggiungi a Home"' },
    he: { title: 'להוספה למסך הבית', body: 'התקינו את האפליקציה לחוויה מלאה ומהירה.', btn: 'התקנה', later: 'אחר כך', ios: 'שתף → הוסף למסך הבית' }
  };

  const copy = translations[loc as keyof typeof translations] ?? copyFallback();

  function copyFallback() {
    return { title: 'Add to Home Screen', body: 'Install the app for a faster, full-screen experience.', btn: 'Install', later: 'Later', ios: 'Use your browser menu → Add to Home Screen' };
  }

    const isIOS = /iphone|ipad|ipod/i.test(navigator.userAgent);

    async function onInstall() {
        if (isIOS) {
            // Show how-to text only; user must use Share sheet
            localStorage.setItem(HIDE_KEY, '1');
            setReady(false);
            return;
        }
        const ev = deferred.current;
        if (!ev) return;
        await ev.prompt();
        localStorage.setItem(HIDE_KEY, '1');
        setReady(false);
    }

    return (
        <div className="fixed bottom-4 left-0 right-0 z-40">
            <div className="mx-auto max-w-screen-sm rounded-2xl border bg-white p-4 shadow">
                <div className="font-semibold mb-1">{copy.title}</div>
                <div className="text-sm opacity-80 mb-3">{isIOS ? copy.ios : copy.body}</div>
                <div className="flex gap-3">
                    <button onClick={onInstall} className="rounded-xl border px-4 py-2 hover:shadow">{copy.btn}</button>
                    <button onClick={() => { localStorage.setItem(HIDE_KEY, '1'); setReady(false); }} className="rounded-xl border px-4 py-2 hover:shadow">{copy.later}</button>
                </div>
            </div>
        </div>
    );
}
