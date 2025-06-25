const fs = require('fs');
const path = require('path');

function checkFile(filePath, patterns) {
  const result = { file: filePath, exists: false, patternResults: [] };
  if (fs.existsSync(filePath)) {
    result.exists = true;
    const content = fs.readFileSync(filePath, 'utf8');
    result.patternResults = patterns.map(p => {
      const ok = p.test(content);
      return { pattern: p, ok };
    });
  }
  return result;
}

const checks = [
  {
    file: 'integration_test/app_test.dart',
    patterns: [
      /IntegrationTestWidgetsFlutterBinding/,
      /seed.*Firestore|Firestore.*seed/i,
      /Book/
    ]
  },
  {
    file: '.github/workflows/ci.yml',
    patterns: [
      /flutter\s+test/,
      /flutter\s+build\s+web/,
      /firebase\s+deploy\s+--only\s+functions\s+--token/
    ]
  },
  {
    file: 'scripts/run_tests.sh',
    patterns: [
      /case/,
      /unit\)/,
      /integration\)/,
      /all\)/,
      /firebase\s+emulators:start/,
      /emulators?:stop|kill/i
    ]
  },
  {
    file: 'scripts/smoke_test.sh',
    patterns: [
      /curl .*\$APP_URL/,
      /curl .*firestore.*googleapis\.com/i
    ]
  },
  {
    file: 'DEPLOYMENT_GUIDE.md',
    patterns: [
      /1\.\s*Prerequisites/i,
      /3\.\s*Build\s*&\s*Deploy/i,
      /Post-Deployment Smoke Test/i
    ]
  },
  {
    file: 'TESTING_AND_DEPLOYMENT.md',
    patterns: [
      /Unit/i,
      /Integration/i,
      /Smoke/i,
      /CI/i
    ]
  }
];

let allPassed = true;
for (const check of checks) {
  const result = checkFile(check.file, check.patterns);
  const passed = result.exists && result.patternResults.every(p => p.ok);
  allPassed = allPassed && passed;
  const status = passed ? '✅ PASS' : '❌ FAIL';
  console.log(`${check.file}: ${status}`);
}

process.exitCode = allPassed ? 0 : 1;
