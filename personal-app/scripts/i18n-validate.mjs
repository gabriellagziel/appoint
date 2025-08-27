import fs from 'fs';
import path from 'path';

const root = new URL('../src/messages/', import.meta.url).pathname;
const files = fs.readdirSync(root).filter(f => f.endsWith('.json'));
const ref = JSON.parse(fs.readFileSync(path.join(root, 'en.json'), 'utf8'));

function flat(obj, prefix = '') {
    return Object.entries(obj).reduce((acc, [k, v]) => {
        if (k === '__meta') return acc;
        const nk = prefix ? `${prefix}.${k}` : k;
        if (v && typeof v === 'object') Object.assign(acc, flat(v, nk));
        else acc[nk] = String(v ?? '');
        return acc;
    }, {});
}

const refFlat = flat(ref);
for (const f of files) {
    const j = JSON.parse(fs.readFileSync(path.join(root, f), 'utf8'));
    const cur = flat(j);
    const missing = Object.keys(refFlat).filter(k => !(k in cur));
    const extra = Object.keys(cur).filter(k => !(k in refFlat));
    console.log(`\n— ${f}`);
    console.log(`  Missing: ${missing.length}  Extra: ${extra.length}`);
    if (missing.length) console.log('  e.g.:', missing.slice(0, 5).join(', '));
}
