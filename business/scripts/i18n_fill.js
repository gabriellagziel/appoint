const fs = require('fs');
const path = require('path');

const localesDir = path.join(process.cwd(), 'public', 'locales');
if (!fs.existsSync(localesDir)) {
  console.log('No locales directory found, exiting.');
  process.exit(0);
}

const langs = fs.readdirSync(localesDir).filter(x => x !== 'en');
console.log(`Found ${langs.length} non-English locales: ${langs.join(', ')}`);

// Get all JSON files from English locale
const enFiles = fs.readdirSync(path.join(localesDir, 'en')).filter(x => x.endsWith('.json'));
console.log(`English locale has ${enFiles.length} files: ${enFiles.join(', ')}`);

for (const lang of langs) {
  console.log(`\nProcessing ${lang}...`);
  
  for (const file of enFiles) {
    const enPath = path.join(localesDir, 'en', file);
    const langPath = path.join(localesDir, lang, file);
    
    if (!fs.existsSync(langPath)) {
      console.log(`  ${file}: Creating new file for ${lang}`);
      // Copy English file as placeholder
      fs.copyFileSync(enPath, langPath);
      continue;
    }
    
    try {
      const enData = JSON.parse(fs.readFileSync(enPath, 'utf8'));
      const langData = JSON.parse(fs.readFileSync(langPath, 'utf8'));
      
      let added = 0;
      let totalKeys = 0;
      
      // Recursively fill missing keys
      const fillMissingKeys = (enObj, langObj, path = '') => {
        for (const key of Object.keys(enObj)) {
          totalKeys++;
          const fullPath = path ? `${path}.${key}` : key;
          
          if (!(key in langObj)) {
            langObj[key] = enObj[key];
            added++;
            console.log(`    + ${fullPath}: "${enObj[key]}"`);
          } else if (typeof enObj[key] === 'object' && enObj[key] !== null && !Array.isArray(enObj[key])) {
            if (typeof langObj[key] !== 'object' || langObj[key] === null || Array.isArray(langObj[key])) {
              langObj[key] = {};
            }
            fillMissingKeys(enObj[key], langObj[key], fullPath);
          }
        }
      };
      
      fillMissingKeys(enData, langData);
      
      if (added > 0) {
        // Write back the updated file
        fs.writeFileSync(langPath, JSON.stringify(langData, null, 2));
        console.log(`  ${file}: +${added} placeholders added (${totalKeys} total keys)`);
      } else {
        console.log(`  ${file}: No missing keys`);
      }
      
    } catch (error) {
      console.error(`  Error processing ${file} for ${lang}:`, error.message);
    }
  }
}

console.log('\n✅ i18n placeholder filling complete!');
console.log('Note: All missing keys have been filled with English placeholders.');
console.log('Translators should replace these with proper translations.');
