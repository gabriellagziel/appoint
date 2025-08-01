export const typography = {
  fontFamilies: {
    'geist-sans': 'Geist, system-ui, sans-serif',
    'geist-mono': 'Geist Mono, monospace',
  },
  fontSizes: {
    xs: '0.75rem',    // 12px
    sm: '0.875rem',   // 14px
    base: '1rem',     // 16px
    lg: '1.125rem',   // 18px
    xl: '1.25rem',    // 20px
    '2xl': '1.5rem',  // 24px
    '3xl': '1.875rem', // 30px
    '4xl': '2.25rem',  // 36px
    '5xl': '3rem',     // 48px
  },
  fontWeights: {
    light: '300',
    normal: '400',
    medium: '500',
    semibold: '600',
    bold: '700',
  },
  lineHeights: {
    none: '1',
    tight: '1.25',
    normal: '1.5',
    relaxed: '1.75',
  },
  letterSpacing: {
    tight: '-0.025em',
    normal: '0em',
    wide: '0.025em',
  },
} as const

export type TypographyToken = typeof typography
export type FontFamily = keyof typeof typography.fontFamilies
export type FontSize = keyof typeof typography.fontSizes
export type FontWeight = keyof typeof typography.fontWeights
export type LineHeight = keyof typeof typography.lineHeights 