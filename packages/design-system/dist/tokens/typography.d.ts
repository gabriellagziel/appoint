export declare const typography: {
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
export type TypographyToken = typeof typography;
export type FontFamily = keyof typeof typography.fontFamilies;
export type FontSize = keyof typeof typography.fontSizes;
export type FontWeight = keyof typeof typography.fontWeights;
export type LineHeight = keyof typeof typography.lineHeights;
//# sourceMappingURL=typography.d.ts.map