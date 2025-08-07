export declare function useDesignTokens(): {
    colors: {
        readonly primary: {
            readonly blue: {
                readonly 50: "#eff6ff";
                readonly 100: "#dbeafe";
                readonly 600: "#2563eb";
                readonly 700: "#1d4ed8";
            };
            readonly green: {
                readonly 600: "#16a34a";
                readonly 700: "#15803d";
            };
            readonly purple: {
                readonly 600: "#9333ea";
                readonly 700: "#7c3aed";
            };
        };
        readonly gray: {
            readonly 50: "#f9fafb";
            readonly 100: "#f3f4f6";
            readonly 200: "#e5e7eb";
            readonly 400: "#9ca3af";
            readonly 500: "#6b7280";
            readonly 600: "#4b5563";
            readonly 700: "#374151";
            readonly 900: "#111827";
        };
        readonly white: "#ffffff";
        readonly black: "#000000";
        readonly success: {
            readonly 500: "#10b981";
        };
        readonly destructive: "#ef4444";
        readonly warning: "#f59e0b";
    };
    typography: {
        readonly fontFamilies: {
            readonly 'geist-sans': "Geist, system-ui, sans-serif";
            readonly 'geist-mono': "Geist Mono, monospace";
        };
        readonly fontSizes: {
            readonly xs: "0.75rem";
            readonly sm: "0.875rem";
            readonly base: "1rem";
            readonly lg: "1.125rem";
            readonly xl: "1.25rem";
            readonly '2xl': "1.5rem";
            readonly '3xl': "1.875rem";
            readonly '4xl': "2.25rem";
            readonly '5xl': "3rem";
        };
        readonly fontWeights: {
            readonly light: "300";
            readonly normal: "400";
            readonly medium: "500";
            readonly semibold: "600";
            readonly bold: "700";
        };
        readonly lineHeights: {
            readonly none: "1";
            readonly tight: "1.25";
            readonly normal: "1.5";
            readonly relaxed: "1.75";
        };
        readonly letterSpacing: {
            readonly tight: "-0.025em";
            readonly normal: "0em";
            readonly wide: "0.025em";
        };
    };
    spacing: {
        readonly 0: "0";
        readonly 1: "0.25rem";
        readonly 2: "0.5rem";
        readonly 3: "0.75rem";
        readonly 4: "1rem";
        readonly 6: "1.5rem";
        readonly 8: "2rem";
        readonly 12: "3rem";
        readonly 16: "4rem";
        readonly 20: "5rem";
    };
    borderRadius: {
        readonly sm: "0.125rem";
        readonly md: "0.375rem";
        readonly lg: "0.5rem";
        readonly xl: "0.75rem";
        readonly full: "9999px";
    };
    breakpoints: {
        readonly sm: "640px";
        readonly md: "768px";
        readonly lg: "1024px";
        readonly xl: "1280px";
        readonly '2xl': "1536px";
    };
    shadows: {
        readonly sm: "0 1px 2px 0 rgb(0 0 0 / 0.05)";
        readonly md: "0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)";
        readonly lg: "0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)";
        readonly xl: "0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)";
    };
    transitions: {
        readonly default: "150ms cubic-bezier(0.4, 0, 0.2, 1)";
        readonly fast: "100ms cubic-bezier(0.4, 0, 0.2, 1)";
        readonly slow: "300ms cubic-bezier(0.4, 0, 0.2, 1)";
    };
};
//# sourceMappingURL=use-design-tokens.d.ts.map