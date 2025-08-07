export declare const colors: {
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
export type ColorToken = typeof colors;
export type ColorScale = keyof typeof colors.primary;
export type ColorShade = keyof typeof colors.primary.blue;
//# sourceMappingURL=colors.d.ts.map