/* Placeholder: If local emulator configured, implement purge here. */
import fs from 'node:fs';
const out = 'qa/output/clean.txt';
fs.writeFileSync(out, 'CLEAN: SKIPPED (no local DB configured)\n');
console.log('Clean data: SKIPPED');


