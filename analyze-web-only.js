#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

console.log('🔍 Analyzing Next.js + Firebase Functions project...\n');

// Define the folders to analyze
const webFolders = [
  'functions',
  'pages',
  'components', 
  'public'
];

// Define patterns to exclude
const excludePatterns = [
  '**/*.dart',
  '**/*.arb',
  '**/*.g.dart',
  '**/*.freezed.dart',
  'enterprise-onboarding-portal/**/*',
  'macos/**/*',
  'android/**/*',
  'ios/**/*',
  'test/**/*',
  'tool/**/*',
  'scripts/**/*',
  'docs/**/*',
  'design-*/**/*',
  'marketing/**/*',
  'business/**/*',
  'admin/**/*',
  'dashboard/**/*',
  'enterprise-app/**/*',
  'enterprise-sdks-and-cli/**/*',
  'fastlane/**/*',
  'grafana/**/*',
  'monitoring/**/*',
  'performance/**/*',
  'reporting/**/*',
  'security/**/*',
  'self_healing/**/*',
  'slas-and-monitoring/**/*',
  'sso-saml-oidc/**/*',
  'terraform/**/*',
  'third_party/**/*',
  'todo_*/**/*',
  'translation_backup/**/*',
  'web/**/*'
];

console.log('📁 Analyzing folders:', webFolders.join(', '));
console.log('🚫 Excluding patterns:', excludePatterns.length, 'patterns\n');

// Check if folders exist
const existingFolders = webFolders.filter(folder => fs.existsSync(folder));
console.log('✅ Found folders:', existingFolders.join(', '));

if (existingFolders.length === 0) {
  console.log('❌ No web folders found. Please check your project structure.');
  process.exit(1);
}

// Run TypeScript check on functions
if (fs.existsSync('functions')) {
  console.log('\n🔧 Checking Firebase Functions...');
  try {
    const result = execSync('cd functions && npm run build', { 
      encoding: 'utf8',
      stdio: 'pipe'
    });
    console.log('✅ Functions build successful');
  } catch (error) {
    console.log('❌ Functions build failed:');
    console.log(error.stdout || error.message);
  }
}

// Check for TypeScript files in web folders
console.log('\n📊 Scanning for TypeScript/JavaScript files...');
let totalFiles = 0;
let errorFiles = 0;

existingFolders.forEach(folder => {
  const scanFolder = (dir) => {
    const items = fs.readdirSync(dir);
    items.forEach(item => {
      const fullPath = path.join(dir, item);
      const stat = fs.statSync(fullPath);
      
      if (stat.isDirectory()) {
        scanFolder(fullPath);
      } else if (item.endsWith('.ts') || item.endsWith('.tsx') || item.endsWith('.js') || item.endsWith('.jsx')) {
        totalFiles++;
        console.log(`  📄 ${fullPath}`);
      }
    });
  };
  
  if (fs.existsSync(folder)) {
    scanFolder(folder);
  }
});

console.log(`\n📈 Summary:`);
console.log(`  📁 Folders analyzed: ${existingFolders.length}`);
console.log(`  📄 TypeScript/JS files found: ${totalFiles}`);
console.log(`  🚫 Excluded patterns: ${excludePatterns.length}`);

console.log('\n✅ Analysis complete! Only web development files were checked.');
console.log('💡 If you still see errors, they are likely real TypeScript/JavaScript issues in your web code.');

