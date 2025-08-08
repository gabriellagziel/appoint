// App-Oint PWA Service Worker
const CACHE_NAME = 'app-oint-pwa-v1';
const STATIC_CACHE_URLS = [
  '/',
  '/index.html',
  '/manifest.json',
  '/flutter.js',
  '/main.dart.js',
  '/icons/Icon-192.png',
  '/icons/Icon-512.png',
  '/icons/Icon-maskable-192.png',
  '/icons/Icon-maskable-512.png',
  '/favicon.png'
];

// Install event - cache static resources
self.addEventListener('install', (event) => {
  console.log('Service Worker: Installing...');
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('Service Worker: Caching static files');
        return cache.addAll(STATIC_CACHE_URLS);
      })
      .then(() => {
        console.log('Service Worker: Static files cached successfully');
        return self.skipWaiting();
      })
      .catch((error) => {
        console.error('Service Worker: Error caching static files:', error);
      })
  );
});

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
  console.log('Service Worker: Activating...');
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            console.log('Service Worker: Deleting old cache:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    }).then(() => {
      console.log('Service Worker: Activated successfully');
      return self.clients.claim();
    })
  );
});

// Fetch event - serve from cache, fallback to network
self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request)
      .then((response) => {
        // Return cached version or fetch from network
        return response || fetch(event.request);
      })
      .catch(() => {
        // If offline and no cache, return offline page
        if (event.request.destination === 'document') {
          return caches.match('/index.html');
        }
      })
  );
});

// Handle PWA install prompt
let deferredPrompt;
let installPromptShown = false;

self.addEventListener('beforeinstallprompt', (event) => {
  console.log('Service Worker: beforeinstallprompt event fired');
  // Prevent Chrome 67 and earlier from automatically showing the prompt
  event.preventDefault();
  // Stash the event so it can be triggered later
  deferredPrompt = event;
  
  // Notify main thread about install availability
  self.clients.matchAll().then(clients => {
    clients.forEach(client => {
      client.postMessage({
        type: 'PWA_INSTALL_AVAILABLE',
        canInstall: true
      });
    });
  });
});

// Handle successful app install
self.addEventListener('appinstalled', (event) => {
  console.log('Service Worker: App was installed successfully');
  
  // Notify main thread about successful install
  self.clients.matchAll().then(clients => {
    clients.forEach(client => {
      client.postMessage({
        type: 'PWA_INSTALLED',
        installed: true
      });
    });
  });
  
  deferredPrompt = null;
});

// Handle messages from main thread
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SHOW_PWA_PROMPT') {
    if (deferredPrompt && !installPromptShown) {
      installPromptShown = true;
      deferredPrompt.prompt();
      
      deferredPrompt.userChoice.then((choiceResult) => {
        console.log('Service Worker: User choice:', choiceResult.outcome);
        
        // Notify main thread about user choice
        event.source.postMessage({
          type: 'PWA_PROMPT_RESULT',
          outcome: choiceResult.outcome
        });
        
        deferredPrompt = null;
      });
    }
  }
});

// Handle push notifications (for future use)
self.addEventListener('push', (event) => {
  console.log('Service Worker: Push notification received');
  
  const options = {
    body: event.data ? event.data.text() : 'New notification from App-Oint',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    vibrate: [100, 50, 100],
    data: {
      dateOfArrival: Date.now(),
      primaryKey: 1
    }
  };
  
  event.waitUntil(
    self.registration.showNotification('App-Oint', options)
  );
});

// Handle notification clicks
self.addEventListener('notificationclick', (event) => {
  console.log('Service Worker: Notification clicked');
  event.notification.close();
  
  event.waitUntil(
    clients.openWindow('/')
  );
});
