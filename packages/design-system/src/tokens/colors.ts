export const colors = {
  primary: {
    blue: {
      50: '#eff6ff',
      100: '#dbeafe',
      600: '#2563eb',
      700: '#1d4ed8',
    },
    green: {
      600: '#16a34a',
      700: '#15803d',
    },
    purple: {
      600: '#9333ea',
      700: '#7c3aed',
    }
  },
  gray: {
    50: '#f9fafb',
    100: '#f3f4f6',
    200: '#e5e7eb',
    400: '#9ca3af',
    500: '#6b7280',
    600: '#4b5563',
    700: '#374151',
    900: '#111827',
  },
  white: '#ffffff',
  black: '#000000',
  success: {
    500: '#10b981',
  },
  destructive: '#ef4444',
  warning: '#f59e0b',
} as const

export type ColorToken = typeof colors
export type ColorScale = keyof typeof colors.primary
export type ColorShade = keyof typeof colors.primary.blue 