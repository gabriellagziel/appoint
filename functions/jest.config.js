module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  testMatch: [
    '<rootDir>/test/**/*.spec.ts',
    '<rootDir>/test/**/*.test.js',
    '<rootDir>/test/**/*.test.ts'
  ],
  collectCoverageFrom: [
    'index.js',
    'src/**/*.js',
    'src/**/*.ts',
    '!**/node_modules/**',
    '!**/test/**',
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
  setupFilesAfterEnv: ['<rootDir>/test/setup.js'],
}; 