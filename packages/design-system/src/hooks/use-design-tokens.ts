import { colors } from "../tokens/colors"
import { shadows, transitions } from "../tokens/shadows"
import { borderRadius, breakpoints, spacing } from "../tokens/spacing"
import { typography } from "../tokens/typography"

export function useDesignTokens() {
  return {
    colors,
    typography,
    spacing,
    borderRadius,
    breakpoints,
    shadows,
    transitions,
  }
} 