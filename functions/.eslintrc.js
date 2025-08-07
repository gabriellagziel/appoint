module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
    jest: true,
  },
  extends: [
    'eslint:recommended',
  ],
  parserOptions: {
    ecmaVersion: 2018,
    sourceType: 'module',
  },
  ignorePatterns: [
    '/lib/**/*', // Ignore built files
    '/node_modules/**/*',
    '**/*.ts', // Ignore TypeScript files for now
  ],
  rules: {
    'no-console': 'off', // Allow console.log in functions
    'quotes': ['error', 'single'],
    'semi': ['error', 'always'],
    'comma-dangle': ['error', 'always-multiline'],
    'no-unused-vars': 'warn',
  },
};
