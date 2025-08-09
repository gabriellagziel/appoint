import pluginImport from "eslint-plugin-import";
import tseslint from "@typescript-eslint/eslint-plugin";
import tsParser from "@typescript-eslint/parser";

export default [
  // TS + import resolver layer (typed) for src only
  {
    files: ["src/**/*.{ts,tsx}"],
    languageOptions: {
      parser: tsParser,
      parserOptions: { project: ["./tsconfig.eslint.json"] },
    },
    plugins: {
      import: pluginImport,
      "@typescript-eslint": tseslint,
    },
    settings: {
      "import/resolver": {
        typescript: { project: "./tsconfig.json" },
      },
    },
    rules: {
      "no-console": ["warn", { allow: ["warn", "error"] }],
      "react/no-unescaped-entities": "off",
      "@typescript-eslint/no-explicit-any": "warn",
      "import/no-unresolved": "error",
    },
  },
  // Non-typed TS linting for root/config/test files to avoid project include errors
  {
    files: [
      "*.ts",
      "*.tsx",
      "sentry.*.ts",
      "next.config.ts",
      "tailwind.config.ts",
      "middleware.ts",
      "tests/**/*.{ts,tsx}",
    ],
    languageOptions: {
      parser: tsParser,
      parserOptions: { project: [] },
    },
    plugins: {
      "@typescript-eslint": tseslint,
    },
    rules: {
      "no-console": ["warn", { allow: ["warn", "error"] }],
      "@typescript-eslint/no-var-requires": "off",
    },
  },
  // Ignores for flat config
  {
    ignores: [".next/**", "dist/**", "build/**", "public/**", "node_modules/**"],
  },
];
