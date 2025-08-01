import * as React from "react"

interface ThemeProviderProps {
  children: React.ReactNode
  defaultTheme?: "light" | "dark"
  storageKey?: string
}

interface ThemeProviderState {
  theme: "light" | "dark"
  setTheme: (theme: "light" | "dark") => void
}

const initialState: ThemeProviderState = {
  theme: "light",
  setTheme: () => null,
}

const ThemeProviderContext = React.createContext<ThemeProviderState>(initialState)

export function ThemeProvider({
  children,
  defaultTheme = "light",
  storageKey = "app-oint-ui-theme",
  ...props
}: ThemeProviderProps) {
  const [theme, setTheme] = React.useState<"light" | "dark">(
    () => (localStorage?.getItem(storageKey) as "light" | "dark") || defaultTheme
  )

  React.useEffect(() => {
    const root = window.document.documentElement

    root.classList.remove("light", "dark")
    root.classList.add(theme)
  }, [theme])

  const value = {
    theme,
    setTheme: (theme: "light" | "dark") => {
      localStorage?.setItem(storageKey, theme)
      setTheme(theme)
    },
  }

  return (
    <ThemeProviderContext.Provider {...props} value={value}>
      {children}
    </ThemeProviderContext.Provider>
  )
}

export const useTheme = () => {
  const context = React.useContext(ThemeProviderContext)

  if (context === undefined)
    throw new Error("useTheme must be used within a ThemeProvider")

  return context
} 