import { colors } from "../tokens/colors";
import { typography } from "../tokens/typography";
import { spacing, borderRadius, breakpoints } from "../tokens/spacing";
import { shadows, transitions } from "../tokens/shadows";
export function useDesignTokens() {
    return {
        colors,
        typography,
        spacing,
        borderRadius,
        breakpoints,
        shadows,
        transitions,
    };
}
