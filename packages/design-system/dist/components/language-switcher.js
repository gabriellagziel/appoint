import { jsx as _jsx, jsxs as _jsxs } from "react/jsx-runtime";
import * as React from "react";
import { Globe } from "lucide-react";
import { cn } from "../lib/utils";
import { Button } from "./button";
const LanguageSwitcher = React.forwardRef(({ className, languages = [
    { code: 'en', name: 'English' },
    { code: 'es', name: 'Español' },
    { code: 'fr', name: 'Français' },
    { code: 'de', name: 'Deutsch' },
], currentLanguage = 'en', onLanguageChange, ...props }, ref) => {
    const [isOpen, setIsOpen] = React.useState(false);
    const handleLanguageSelect = (languageCode) => {
        onLanguageChange?.(languageCode);
        setIsOpen(false);
    };
    const currentLang = languages.find(lang => lang.code === currentLanguage) || languages[0];
    return (_jsxs("div", { ref: ref, className: cn("relative", className), ...props, children: [_jsxs(Button, { variant: "ghost", size: "sm", onClick: () => setIsOpen(!isOpen), className: "flex items-center gap-2", children: [_jsx(Globe, { className: "h-4 w-4" }), _jsx("span", { className: "hidden sm:inline", children: currentLang.name })] }), isOpen && (_jsx("div", { className: "absolute right-0 top-full mt-2 w-48 rounded-md border bg-white shadow-lg z-50", children: _jsx("div", { className: "py-1 max-h-96 overflow-y-auto language-switcher", children: languages.map((language) => (_jsxs("button", { onClick: () => handleLanguageSelect(language.code), className: cn("block w-full text-left px-4 py-2 text-sm hover:bg-gray-100 transition-colors", language.code === currentLanguage && "bg-blue-50 text-blue-700"), children: [language.flag && _jsx("span", { className: "mr-2", children: language.flag }), language.name] }, language.code))) }) }))] }));
});
LanguageSwitcher.displayName = "LanguageSwitcher";
export { LanguageSwitcher };
