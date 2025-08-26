'use client';
import { useEffect } from 'react';

const SW_VERSION = 'v1.0.0'; // bump to bust caches on deploy

export default function PWARegister({ locale }: { locale: string }) {
    useEffect(() => {
        if ('serviceWorker' in navigator) {
            const url = `/sw.js?v=${SW_VERSION}`;
            navigator.serviceWorker.register(url).catch(() => { });
        }
    }, []);

    return null;
}
