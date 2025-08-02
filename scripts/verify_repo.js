const fs = require('fs');

const files = [
  { path: 'integration_test/app_test.dart', snippet: 'integration_test' },
  { path: '.github/workflows/ci.yml', snippet: 'Start Firebase emulator' },
  { path: 'scripts/run_tests.sh', snippet: 'firebase emulators:start' },
  { path: 'scripts/smoke_test.sh', snippet: 'curl "$APP_URL"' },
  { path: 'DEPLOYMENT_GUIDE.md', snippet: '1. Prerequisites' },
  { path: 'TESTING_AND_DEPLOYMENT.md', snippet: 'Unit' }
];

let allPassed = true;

for (const file of files) {
  let passed = false;
  if (fs.existsSync(file.path)) {
    const content = fs.readFileSync(file.path, 'utf8');
    const firstLine = content.split(/\r?\n/)[0];
    passed = firstLine.includes(file.snippet) || content.includes(file.snippet);
  }
  const status = passed ? '✅ PASS' : '❌ FAIL';
  console.log(`${status} ${file.path}`);
  allPassed = allPassed && passed;
}

process.exitCode = allPassed ? 0 : 1;
