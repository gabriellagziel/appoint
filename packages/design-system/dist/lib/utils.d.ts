import { type ClassValue } from "clsx";
export declare function cn(...inputs: ClassValue[]): string;
export declare function formatCurrency(amount: number, currency?: string): string;
export declare function formatDate(date: Date, locale?: string): string;
export declare function formatDateTime(date: Date, locale?: string): string;
export declare function debounce<T extends (...args: any[]) => any>(func: T, wait: number): (...args: Parameters<T>) => void;
export declare function throttle<T extends (...args: any[]) => any>(func: T, limit: number): (...args: Parameters<T>) => void;
//# sourceMappingURL=utils.d.ts.map