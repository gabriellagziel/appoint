'use client';
import { useTranslations } from 'next-intl';

export function useT(ns?: string) {
    try {
        return useTranslations(ns);
    } catch {
        // Fallback no-op translator
        return ((key: string) => key) as unknown as ReturnType<typeof useTranslations>;
    }
}
