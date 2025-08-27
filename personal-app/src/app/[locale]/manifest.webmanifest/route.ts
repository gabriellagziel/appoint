import { isRTL, normalizeLocale } from '@/i18n';
import { NextResponse } from 'next/server';

export const dynamic = 'force-dynamic';

export async function GET(_: Request, { params }: { params: { locale: string } }) {
    const loc = normalizeLocale(params.locale);
    const dir = isRTL(loc) ? 'rtl' : 'ltr';

    // Localized strings (seed: extend or load from messages if desired)
    const NAMES: Record<string, { name: string; short: string }> = {
        en: { name: 'App-Oint Personal', short: 'App-Oint' },
        it: { name: 'App-Oint Personale', short: 'App-Oint' },
        he: { name: 'App-Oint אישי', short: 'App-Oint' }
    };
    const base = NAMES[loc] ?? NAMES.en;

    const manifest = {
        name: base.name,
        short_name: base.short,
        lang: loc,
        dir,
        start_url: `/${loc}/?source=pwa`,
        scope: `/${loc}/`,
        display: 'standalone',
        background_color: '#ffffff',
        theme_color: '#0ea5e9',
        description: 'Organize time. Set. Send. Done.',
        icons: [
            { src: '/icons/icon-192.png', sizes: '192x192', type: 'image/png', purpose: 'any' },
            { src: '/icons/icon-512.png', sizes: '512x512', type: 'image/png', purpose: 'any' },
            { src: '/icons/maskable-512.png', sizes: '512x512', type: 'image/png', purpose: 'maskable' }
        ]
    };

    return new NextResponse(JSON.stringify(manifest), {
        headers: {
            'Content-Type': 'application/manifest+json',
            'Cache-Control': 'no-cache'
        }
    });
}
