import { Globe } from "lucide-react"
import * as React from "react"
import { cn } from "../lib/utils"
import { Button } from "./button"

export interface Language {
  code: string
  name: string
  flag?: string
}

export interface LanguageSwitcherProps extends React.HTMLAttributes<HTMLDivElement> {
  languages?: Language[]
  currentLanguage?: string
  onLanguageChange?: (language: string) => void
  className?: string
}

const LanguageSwitcher = React.forwardRef<HTMLDivElement, LanguageSwitcherProps>(
  ({
    className,
    languages = [
      { code: 'en', name: 'English' },
      { code: 'es', name: 'Español' },
      { code: 'fr', name: 'Français' },
      { code: 'de', name: 'Deutsch' },
    ],
    currentLanguage = 'en',
    onLanguageChange,
    ...props
  }, ref) => {
    const [isOpen, setIsOpen] = React.useState(false)

    const handleLanguageSelect = (languageCode: string) => {
      onLanguageChange?.(languageCode)
      setIsOpen(false)
    }

    const currentLang = languages.find(lang => lang.code === currentLanguage) || languages[0]

    return (
      <div ref={ref} className={cn("relative", className)} {...props}>
        <Button
          variant="ghost"
          size="sm"
          onClick={() => setIsOpen(!isOpen)}
          className="flex items-center gap-2"
        >
          <Globe className="h-4 w-4" />
          <span className="hidden sm:inline">{currentLang.name}</span>
        </Button>

        {isOpen && (
          <div className="absolute right-0 top-full mt-2 w-48 rounded-md border bg-white shadow-lg z-50">
            <div className="py-1 max-h-96 overflow-y-auto language-switcher">
              {languages.map((language) => (
                <button
                  key={language.code}
                  onClick={() => handleLanguageSelect(language.code)}
                  className={cn(
                    "block w-full text-left px-4 py-2 text-sm hover:bg-gray-100 transition-colors",
                    language.code === currentLanguage && "bg-blue-50 text-blue-700"
                  )}
                >
                  {language.flag && <span className="mr-2">{language.flag}</span>}
                  {language.name}
                </button>
              ))}
            </div>
          </div>
        )}
      </div>
    )
  }
)
LanguageSwitcher.displayName = "LanguageSwitcher"

export { LanguageSwitcher }
