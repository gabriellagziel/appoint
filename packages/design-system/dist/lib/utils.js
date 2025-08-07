import { clsx } from "clsx";
import { twMerge } from "tailwind-merge";
export function cn(...inputs) {
    return twMerge(clsx(inputs));
}
export function formatCurrency(amount, currency = 'EUR') {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency,
    }).format(amount);
}
export function formatDate(date, locale = 'en') {
    return new Intl.DateTimeFormat(locale, {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
    }).format(date);
}
export function formatDateTime(date, locale = 'en') {
    return new Intl.DateTimeFormat(locale, {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
    }).format(date);
}
export function debounce(func, wait) {
    let timeout;
    return (...args) => {
        clearTimeout(timeout);
        timeout = setTimeout(() => func(...args), wait);
    };
}
export function throttle(func, limit) {
    let inThrottle;
    return (...args) => {
        if (!inThrottle) {
            func(...args);
            inThrottle = true;
            setTimeout(() => (inThrottle = false), limit);
        }
    };
}
