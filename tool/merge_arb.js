#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Configuration
const L10N_DIR = path.join(__dirname, '..', 'lib', 'l10n');
const MASTER_ARB = path.join(L10N_DIR, 'app_en.arb');
const SUPPORTED_LOCALES = [
  'ar', 'bg', 'cs', 'da', 'de', 'es', 'fi', 'fr', 'he', 'hu',
  'id', 'it', 'ja', 'ko', 'lt', 'ms', 'nl', 'no', 'pl', 'pt',
  'ro', 'ru', 'sk', 'sl', 'sr', 'sv', 'th', 'tr', 'uk', 'vi', 'zh'
];

function parseARB(filePath) {
  try {
    const content = fs.readFileSync(filePath, 'utf8');
    return JSON.parse(content);
  } catch (error) {
    console.error(`❌ Error parsing ${filePath}:`, error.message);
    return null;
  }
}

function writeARB(filePath, data) {
  try {
    const content = JSON.stringify(data, null, 2);
    fs.writeFileSync(filePath, content + '\n');
    console.log(`✅ Updated ${path.basename(filePath)}`);
  } catch (error) {
    console.error(`❌ Error writing ${filePath}:`, error.message);
  }
}

function mergeKeys() {
  console.log('🔄 Starting ARB key merge...');
  
  // Read master ARB file
  const masterARB = parseARB(MASTER_ARB);
  if (!masterARB) {
    console.error('❌ Failed to parse master ARB file');
    process.exit(1);
  }
  
  console.log(`📋 Master ARB has ${Object.keys(masterARB).filter(key => !key.startsWith('@')).length} keys`);
  
  // Process each locale
  SUPPORTED_LOCALES.forEach(locale => {
    const arbPath = path.join(L10N_DIR, `app_${locale}.arb`);
    
    if (!fs.existsSync(arbPath)) {
      console.log(`⚠️  Creating missing ARB file: app_${locale}.arb`);
      const newARB = {
        '@@locale': locale
      };
      
      // Add all keys from master with TODO defaults
      Object.keys(masterARB).forEach(key => {
        if (!key.startsWith('@')) {
          newARB[key] = `TODO: ${masterARB[key]}`;
          newARB[`@${key}`] = masterARB[`@${key}`];
        }
      });
      
      writeARB(arbPath, newARB);
      return;
    }
    
    const targetARB = parseARB(arbPath);
    if (!targetARB) return;
    
    let updated = false;
    const updatedARB = { ...targetARB };
    
    // Check for missing keys
    Object.keys(masterARB).forEach(key => {
      if (!key.startsWith('@') && !(key in targetARB)) {
        console.log(`➕ Adding missing key '${key}' to ${locale}`);
        updatedARB[key] = `TODO: ${masterARB[key]}`;
        updatedARB[`@${key}`] = masterARB[`@${key}`];
        updated = true;
      }
    });
    
    if (updated) {
      writeARB(arbPath, updatedARB);
    } else {
      console.log(`✅ ${locale} is up to date`);
    }
  });
  
  console.log('🎉 ARB merge completed!');
}

// Run the merge
if (require.main === module) {
  mergeKeys();
}

module.exports = { mergeKeys }; 