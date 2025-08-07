module.exports = {
  testEnvironment: 'node',
  collectCoverageFrom: [
    'public/**/*.{js,jsx}',
    'test/**/*.{js,jsx}',
    '!**/node_modules/**',
    '!**/coverage/**'
  ],
  testMatch: [
    '**/test/**/*.test.js',
    '**/test/**/*.spec.js'
  ],
  testTimeout: 10000,
  verbose: true,
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  setupFilesAfterEnv: ['<rootDir>/test/setup.js'],
  testPathIgnorePatterns: [
    '/node_modules/',
    '/out/',
    '/dist/'
  ]
};