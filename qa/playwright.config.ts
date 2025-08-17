import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './qa/tests',
  testMatch: ['**/*.qa.spec.ts', '**/*.qa.spec.tsx'],
  testIgnore: ['**/*.spec.ts', '**/*.spec.tsx'], // ignore legacy tests
  timeout: 90_000,
  fullyParallel: true,
  reporter: [['list'], ['html', { outputFolder: './qa/output/playwright' }]],
  use: {
    baseURL: process.env.BASE_URL || 'http://localhost:3000',
    trace: 'on-first-retry',
    video: 'retain-on-failure',
    screenshot: 'only-on-failure'
  },
  projects: [
    { name: 'chromium', use: { ...devices['Desktop Chrome'] } },
    { name: 'mobile', use: { ...devices['Pixel 7'] } }
  ]
});

