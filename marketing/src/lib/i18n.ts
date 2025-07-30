import { createContext, useContext } from 'react'

export type Messages = Record<string, string>

interface I18nContextValue {
  t: (key: string) => string
}

export const I18nContext = createContext<I18nContextValue>({ t: (k) => k })

export function useI18n() {
  return useContext(I18nContext)
}