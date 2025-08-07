import * as React from "react";
export interface Language {
    code: string;
    name: string;
    flag?: string;
}
export interface LanguageSwitcherProps extends React.HTMLAttributes<HTMLDivElement> {
    languages?: Language[];
    currentLanguage?: string;
    onLanguageChange?: (language: string) => void;
    className?: string;
}
declare const LanguageSwitcher: React.ForwardRefExoticComponent<LanguageSwitcherProps & React.RefAttributes<HTMLDivElement>>;
export { LanguageSwitcher };
//# sourceMappingURL=language-switcher.d.ts.map