'use client';

import { useEffect, useState } from 'react';

interface BeforeInstallPromptEvent extends Event {
    prompt(): Promise<void>;
    userChoice: Promise<{ outcome: 'accepted' | 'dismissed' }>;
}

export default function InstallPrompt() {
    const [deferredPrompt, setDeferredPrompt] = useState<BeforeInstallPromptEvent | null>(null);
    const [showInstallPrompt, setShowInstallPrompt] = useState(false);

    useEffect(() => {
        const handler = (e: Event) => {
            e.preventDefault();
            setDeferredPrompt(e as BeforeInstallPromptEvent);
            setShowInstallPrompt(true);
        };

        window.addEventListener('beforeinstallprompt', handler);

        return () => {
            window.removeEventListener('beforeinstallprompt', handler);
        };
    }, []);

    const handleInstallClick = async () => {
        if (!deferredPrompt) return;

        deferredPrompt.prompt();
        const { outcome } = await deferredPrompt.userChoice;

        if (outcome === 'accepted') {
            console.log('User accepted the install prompt');
        } else {
            console.log('User dismissed the install prompt');
        }

        setDeferredPrompt(null);
        setShowInstallPrompt(false);
    };

    const handleDismiss = () => {
        setShowInstallPrompt(false);
    };

    if (!showInstallPrompt) return null;

    return (
        <div className="fixed bottom-20 left-4 right-4 bg-blue-600 text-white p-4 rounded-lg shadow-lg z-50">
            <div className="flex items-center justify-between">
                <div>
                    <h3 className="font-semibold">התקן אפליקציה</h3>
                    <p className="text-sm opacity-90">הוסף את App-Oint Personal למסך הבית שלך</p>
                </div>
                <div className="flex gap-2">
                    <button
                        onClick={handleInstallClick}
                        className="bg-white text-blue-600 px-4 py-2 rounded font-medium"
                        aria-label="התקן אפליקציה"
                    >
                        התקן
                    </button>
                    <button
                        onClick={handleDismiss}
                        className="text-white opacity-70 hover:opacity-100"
                        aria-label="סגור"
                    >
                        ✕
                    </button>
                </div>
            </div>
        </div>
    );
}
