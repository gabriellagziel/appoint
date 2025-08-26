/* App-Oint SW — simple, safe cache with version bump */
const VERSION = 'v1.0.0'; // bump to invalidate old caches
const STATIC_CACHE = `ao-static-${VERSION}`;
const RUNTIME_CACHE = `ao-runtime-${VERSION}`;
const NEVER_CACHE = [/\/src\/messages\/.+\.json$/, /\/api\/.*$/];

self.addEventListener('install', (e) => {
    e.waitUntil(caches.open(STATIC_CACHE).then(c => c.addAll([
        '/', '/favicon.ico'
    ])).then(() => self.skipWaiting()));
});

self.addEventListener('activate', (e) => {
    e.waitUntil(caches.keys().then(keys =>
        Promise.all(keys.map(k => (!k.includes(VERSION) ? caches.delete(k) : Promise.resolve())))
    ).then(() => self.clients.claim()));
});

// Strategy:
// - i18n json & APIs: network-only (avoid stale translations/data)
// - same-origin static: cache-first
// - HTML/pages: network-first with cache fallback
self.addEventListener('fetch', (event) => {
    const req = event.request;
    const url = new URL(req.url);

    if (req.method !== 'GET' || url.origin !== location.origin) return;

    if (NEVER_CACHE.some(rx => rx.test(url.pathname))) {
        return; // network only
    }

    if (req.headers.get('accept')?.includes('text/html')) {
        event.respondWith(
            fetch(req).then(r => {
                const copy = r.clone();
                caches.open(RUNTIME_CACHE).then(c => c.put(req, copy));
                return r;
            }).catch(() => caches.match(req).then(r => r || caches.match('/')))
        );
        return;
    }

    if (/\.(png|jpg|jpeg|gif|svg|webp|ico|css|js|woff2?)$/.test(url.pathname)) {
        event.respondWith(
            caches.match(req).then(cached => cached || fetch(req).then(r => {
                const copy = r.clone();
                caches.open(STATIC_CACHE).then(c => c.put(req, copy));
                return r;
            }))
        );
        return;
    }
});
