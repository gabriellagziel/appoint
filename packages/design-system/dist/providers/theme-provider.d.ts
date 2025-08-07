import * as React from "react";
interface ThemeProviderProps {
    children: React.ReactNode;
    defaultTheme?: "light" | "dark";
    storageKey?: string;
}
interface ThemeProviderState {
    theme: "light" | "dark";
    setTheme: (theme: "light" | "dark") => void;
}
export declare function ThemeProvider({ children, defaultTheme, storageKey, ...props }: ThemeProviderProps): import("react/jsx-runtime").JSX.Element;
export declare const useTheme: () => ThemeProviderState;
export {};
//# sourceMappingURL=theme-provider.d.ts.map