# App-Oint Infra Audit
**Timestamp:** 2025-08-25_142115

## Repo Sanity
[SANITY] repo structure
OK: marketing exists
OK: business exists
OK: enterprise-app exists

## Vercel Context
=== vercel whoami ===
Vercel CLI 46.0.2
gabriellagziel

=== vercel projects ls (top 30) ===
Vercel CLI 46.0.2
Fetching projects in gabriellagziels-projects
> Projects found under gabriellagziels-projects  [1s]

  Project Name     Latest Production URL                                   Updated   Node Version   
  marketing        https://REDACTED_TOKEN.vercel.app   4h        22.x           
  enterprise-app   https://enterprise.app-oint.com                         13h       22.x           
  business         https://REDACTED_TOKEN.vercel.app    13h       22.x           
  appoint          https://personal.app-oint.com                           15h       22.x           
  admin            https://admin.app-oint.com                              2d        22.x           


## Health (Live Domains)
=== HEALTH 2025-08-25T14:22:00+02:00 ===
--- app-oint.com ---
HTTP: 404
HSTS: MISSING | XFO: MISSING | CSP: MISSING | x-vercel-id: OK
CONTENT: CLEAN
BODY_HASH_8KB: REDACTED_TOKEN
--- www.app-oint.com ---
HTTP: 404
HSTS: MISSING | XFO: MISSING | CSP: MISSING | x-vercel-id: OK
CONTENT: CLEAN
BODY_HASH_8KB: REDACTED_TOKEN
--- business.app-oint.com ---
HTTP: 200
HSTS: MISSING | XFO: OK | CSP: OK | x-vercel-id: OK
CONTENT: CLEAN
BODY_HASH_8KB: REDACTED_TOKEN
--- enterprise.app-oint.com ---
HTTP: 200
HSTS: MISSING | XFO: OK | CSP: OK | x-vercel-id: OK
CONTENT: CLEAN
BODY_HASH_8KB: REDACTED_TOKEN

## Deployments vs Domains (Body Hash Compare)
=== DEPLOYMENT ↔ DOMAIN HASH COMPARISON ===
--- marketing --- https://REDACTED_TOKEN.vercel.app
DEPLOY_HASH_8KB: REDACTED_TOKEN
COMPARE marketing → app-oint.com : NO
COMPARE marketing → www.app-oint.com : NO
--- business --- https://REDACTED_TOKEN.vercel.app
DEPLOY_HASH_8KB: REDACTED_TOKEN
COMPARE business → business.app-oint.com : NO
--- enterprise-app --- https://REDACTED_TOKEN.vercel.app
DEPLOY_HASH_8KB: REDACTED_TOKEN
COMPARE enterprise-app → enterprise.app-oint.com : YES

## Middleware & Shadow Files
=== MIDDLEWARE & SHADOW FILES ===
--- marketing ---
NO SHADOW index.html
FOUND: /Users/a/Desktop/ga/marketing/middleware.backup.ts
FOUND: /Users/a/Desktop/ga/marketing/middleware.ts
--- business ---
NO SHADOW index.html
FOUND: /Users/a/Desktop/ga/business/middleware.ts
--- enterprise-app ---
SHADOW: enterprise-app/public/index.html EXISTS
FOUND: /Users/a/Desktop/ga/enterprise-app/middleware.js

## Domain Drift Evidence
=== DOMAIN DRIFT (same domain in multiple projects?) ===
    app-oint.com       Third Party         Third Party         -                  gabriellagziel      16h    
    app-oint.com       Third Party         Third Party         -                  gabriellagziel      16h    
    app-oint.com       Third Party         Third Party         -                  gabriellagziel      16h    

## Sentry Env Presence (per project)
### marketing
Vercel CLI 46.0.2
Retrieving project…
> Environment Variables found for gabriellagziels-projects/marketing [256ms]
 SENTRY_AUTH_TOKEN                  Encrypted           Production          3d ago     
 NEXT_PUBLIC_SENTRY_DSN             Encrypted           Production          3d ago     

### business
Vercel CLI 46.0.2
Retrieving project…
> Environment Variables found for gabriellagziels-projects/business [293ms]
 SENTRY_AUTH_TOKEN          Encrypted           Production          3d ago     
 NEXT_PUBLIC_SENTRY_DSN     Encrypted           Production          3d ago     

### enterprise-app
Vercel CLI 46.0.2
Retrieving project…
> Environment Variables found for gabriellagziels-projects/enterprise-app [217ms]
 SENTRY_AUTH_TOKEN          Encrypted           Production          3d ago     
 NEXT_PUBLIC_SENTRY_DSN     Encrypted           Production          3d ago     


## vercel.json Presence (per project)
### marketing
FOUND: vercel.json for marketing
{
    "builds": [
        {
            "src": "next.config.js",
            "use": "@vercel/next"
        },
        {
            "src": "package.json",
            "use": "@vercel/next"
        }
    ],
    "headers": [
        {
            "source": "/(.*)",
            "headers": [
                {
                    "key": "Strict-Transport-Security",
                    "value": "max-age=63072000; includeSubDomains; preload"
                },
                {
                    "key": "X-Frame-Options",
                    "value": "DENY"
                },
                {
                    "key": "X-Content-Type-Options",
                    "value": "nosniff"
                },
                {
                    "key": "Referrer-Policy",
                    "value": "no-referrer-when-downgrade"
                },
                {
                    "key": "Permissions-Policy",
                    "value": "geolocation=(), microphone=(), camera=()"
                },
                {
                    "key": "Content-Security-Policy",
                    "value": "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https:; style-src 'self' 'unsafe-inline' https:; img-src 'self' data: blob: https:; font-src 'self' data: https:; connect-src 'self' https: wss:; frame-ancestors 'none'; base-uri 'self'; form-action 'self'"
                }

### business
FOUND: vercel.json for business
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "Strict-Transport-Security",
          "value": "max-age=63072000; includeSubDomains; preload"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "Referrer-Policy",
          "value": "no-referrer-when-downgrade"
        },
        {
          "key": "Permissions-Policy",
          "value": "geolocation=(), microphone=(), camera=()"
        },
        {
          "key": "Content-Security-Policy",
          "value": "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https:; style-src 'self' 'unsafe-inline' https:; img-src 'self' data: blob: https:; font-src 'self' data: https:; connect-src 'self' https: wss:; frame-ancestors 'none'; base-uri 'self'; form-action 'self'"
        }
      ]
    }
  ]
}
### enterprise-app
FOUND: vercel.json for enterprise-app
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "Strict-Transport-Security",
          "value": "max-age=63072000; includeSubDomains; preload"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "Referrer-Policy",
          "value": "no-referrer-when-downgrade"
        },
        {
          "key": "Permissions-Policy",
          "value": "geolocation=(), microphone=(), camera=()"
        },
        {
          "key": "Content-Security-Policy",
          "value": "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' https:; style-src 'self' 'unsafe-inline' https:; img-src 'self' data: blob: https:; font-src 'self' data: https:; connect-src 'self' https: wss:; frame-ancestors 'none'; base-uri 'self'; form-action 'self'"
        }
      ]
    }
  ]
}

## Git Hotfix Hints
=== suspect files (per project) ===
--- marketing ---
has marketing/pages/index.tsx
  marketing/src/components/ui/input.tsx:11:        "file:text-foreground placeholder:text-muted-foreground selection:bg-primary selection:text-primary-foreground dark:bg-input/30 border-input flex h-9 w-full min-w-0 rounded-md border bg-transparent px-3 py-1 text-base shadow-xs transition-[color,box-shadow] outline-none file:inline-flex file:h-7 file:border-0 file:bg-transparent file:text-sm file:font-medium disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 md:text-sm",
  marketing/pages/contact.tsx:110:                        placeholder="John Doe"
  marketing/pages/contact.tsx:118:                        placeholder="john@example.com"
  marketing/pages/contact.tsx:126:                        placeholder="How can we help you?"
  marketing/pages/contact.tsx:134:                        placeholder="Please provide details about your inquiry..."
  marketing/src/components/Hero.tsx:52:                                    placeholder="Enter your email address"
  marketing/public/locales/tr/contact.json:43:    "placeholders": {
  marketing/public/locales/no/contact.json:43:    "placeholders": {
  marketing/scripts/generate-translations.js:13:  // Core translations - will use placeholders for others
  marketing/scripts/generate-translations.js:47:// Create a simple placeholder translation function
  marketing/public/locales/ro/contact.json:43:    "placeholders": {
  marketing/public/locales/am/contact.json:43:    "placeholders": {
  marketing/public/locales/zh_Hant/contact.json:43:    "placeholders": {
  marketing/public/locales/mt/contact.json:43:    "placeholders": {
  marketing/public/locales/fa/contact.json:43:    "placeholders": {
  marketing/public/locales/en/contact.json:43:    "placeholders": {
  marketing/public/locales/ga/contact.json:43:    "placeholders": {
  marketing/public/locales/ca/contact.json:43:    "placeholders": {
  marketing/public/locales/sv/contact.json:43:    "placeholders": {
  marketing/public/locales/fi/contact.json:43:    "placeholders": {
  marketing/public/locales/sq/contact.json:43:    "placeholders": {
  marketing/public/locales/lv/contact.json:43:    "placeholders": {
  marketing/public/locales/ko/contact.json:43:    "placeholders": {
  marketing/public/locales/ja/contact.json:43:    "placeholders": {
  marketing/public/locales/pt_BR/contact.json:43:    "placeholders": {
  marketing/public/locales/bn/contact.json:43:    "placeholders": {
  marketing/public/locales/sk/contact.json:43:    "placeholders": {
  marketing/public/locales/es_419/contact.json:43:    "placeholders": {
  marketing/public/locales/gl/contact.json:43:    "placeholders": {
  marketing/public/locales/sr/contact.json:43:    "placeholders": {
--- business ---
has business/pages/index.tsx
  business/out/index.html:339:                <input type="text" class="search-input" placeholder="Search meetings, people...">
  business/node_modules/istanbul-lib-source-maps/lib/map-store.js:219:     * Disposes temporary resources allocated by this map store
  business/node_modules/istanbul-lib-source-maps/node_modules/debug/src/common.js:280:	* XXX DO NOT USE. This is a temporary stub function.
  business/node_modules/@types/node/fs/promises.d.ts:919:     * Creates a unique temporary directory. A unique directory name is generated by
  business/node_modules/@types/node/fs/promises.d.ts:941:     * characters directly to the `prefix` string. For instance, given a directory `/tmp`, if the intention is to create a temporary directory _within_ `/tmp`, the `prefix` must end with a trailing
  business/node_modules/@types/node/fs/promises.d.ts:945:     * @return Fulfills with a string containing the file system path of the newly created temporary directory.
  business/node_modules/@types/node/fs/promises.d.ts:949:     * Asynchronously creates a unique temporary directory.
  business/node_modules/@types/node/fs/promises.d.ts:950:     * Generates six random characters to be appended behind a required `prefix` to create a unique temporary directory.
  business/node_modules/@types/node/fs/promises.d.ts:955:     * Asynchronously creates a unique temporary directory.
  business/node_modules/@types/node/fs/promises.d.ts:956:     * Generates six random characters to be appended behind a required `prefix` to create a unique temporary directory.
  business/node_modules/@types/node/sqlite.d.ts:491:         * placeholders replaced by the values that were used during the most recent
  business/node_modules/@types/node/fs.d.ts:1831:     * Creates a unique temporary directory.
  business/node_modules/@types/node/fs.d.ts:1833:     * Generates six random characters to be appended behind a required `prefix` to create a unique temporary directory. Due to platform
  business/node_modules/@types/node/fs.d.ts:1858:     * intention is to create a temporary directory _within_`/tmp`, the `prefix`must end with a trailing platform-specific path separator
  business/node_modules/@types/node/fs.d.ts:1865:     * // The parent directory for the new temporary directory
  business/node_modules/@types/node/fs.d.ts:1873:     *   // A new temporary directory is created at the file system root
  business/node_modules/@types/node/fs.d.ts:1883:     *   // A new temporary directory is created within
  business/node_modules/@types/node/fs.d.ts:1895:     * Asynchronously creates a unique temporary directory.
  business/node_modules/@types/node/fs.d.ts:1896:     * Generates six random characters to be appended behind a required prefix to create a unique temporary directory.
  business/node_modules/@types/node/fs.d.ts:1909:     * Asynchronously creates a unique temporary directory.
  business/node_modules/@types/node/fs.d.ts:1910:     * Generates six random characters to be appended behind a required prefix to create a unique temporary directory.
  business/node_modules/@types/node/fs.d.ts:1919:     * Asynchronously creates a unique temporary directory.
  business/node_modules/@types/node/fs.d.ts:1920:     * Generates six random characters to be appended behind a required prefix to create a unique temporary directory.
  business/node_modules/@types/node/fs.d.ts:1928:         * Asynchronously creates a unique temporary directory.
  business/node_modules/@types/node/fs.d.ts:1929:         * Generates six random characters to be appended behind a required prefix to create a unique temporary directory.
  business/node_modules/@types/node/fs.d.ts:1934:         * Asynchronously creates a unique temporary directory.
  business/node_modules/@types/node/fs.d.ts:1935:         * Generates six random characters to be appended behind a required prefix to create a unique temporary directory.
  business/node_modules/@types/node/fs.d.ts:1940:         * Asynchronously creates a unique temporary directory.
  business/node_modules/@types/node/fs.d.ts:1941:         * Generates six random characters to be appended behind a required prefix to create a unique temporary directory.
  business/node_modules/@types/node/fs.d.ts:1958:     * Synchronously creates a unique temporary directory.
  business/node_modules/@types/node/fs.d.ts:1959:     * Generates six random characters to be appended behind a required prefix to create a unique temporary directory.
  business/node_modules/@types/node/fs.d.ts:1964:     * Synchronously creates a unique temporary directory.
  business/node_modules/@types/node/fs.d.ts:1965:     * Generates six random characters to be appended behind a required prefix to create a unique temporary directory.
  business/node_modules/mime-db/db.json:5829:  "application/x-futuresplash": {
  business/node_modules/@types/node/os.d.ts:457:     * Returns the operating system's default directory for temporary files as a
  business/node_modules/chalk-template/index.d.ts:23:export default function chalkTemplate(text: TemplateStringsArray, ...placeholders: unknown[]): string;
  business/node_modules/@noble/hashes/src/legacy.ts:19:// Reusable temporary buffer
  business/node_modules/@noble/hashes/src/legacy.ts:101:// Reusable temporary buffer
  business/node_modules/@noble/hashes/src/legacy.ts:220:// Reusable temporary buffer
  business/node_modules/@types/node/trace_events.d.ts:11: * * `node`: An empty placeholder.
  business/node_modules/jest-diff/README.md:601:Therefore, Jest uses as placeholder the downwards arrow with corner leftwards:
  business/node_modules/@noble/hashes/src/scrypt.ts:37:  // Save state to temporary variables (salsa)
  business/node_modules/@noble/hashes/src/sha2.ts:28:/** Reusable temporary buffer. "W" comes straight from spec. */
  business/node_modules/@noble/hashes/src/sha2.ts:152:// Reusable temporary buffers
  business/node_modules/@noble/hashes/src/blake1.ts:213:// Reusable temporary buffer
  business/node_modules/@noble/hashes/sha2.js:29:/** Reusable temporary buffer. "W" comes straight from spec. */
  business/node_modules/@noble/hashes/sha2.js:149:// Reusable temporary buffers
  business/node_modules/@noble/hashes/blake1.js:182:// Reusable temporary buffer
  business/node_modules/@noble/hashes/legacy.js:20:// Reusable temporary buffer
  business/node_modules/@noble/hashes/legacy.js:99:// Reusable temporary buffer
  business/node_modules/@noble/hashes/legacy.js:224:// Reusable temporary buffer
  business/node_modules/@noble/hashes/esm/sha2.js:26:/** Reusable temporary buffer. "W" comes straight from spec. */
  business/node_modules/@noble/hashes/esm/sha2.js:144:// Reusable temporary buffers
  business/node_modules/serve-handler/node_modules/mime-db/db.json:4727:  "application/x-futuresplash": {
  business/node_modules/serve-handler/node_modules/path-to-regexp/index.js:403: * placeholder key descriptions. For example, using `/user/:id`, `keys` will
  business/node_modules/write-file-atomic/README.md:38:it encounters errors at any of these steps it will attempt to unlink the temporary file and then
  business/node_modules/caniuse-lite/data/features/css-placeholder-shown.js:1:module.exports={A:{A:{"2":"K D E F rC","292":"A B"},B:{"1":"0 Q H R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z AB BB CB DB EB FB GB HB IB JB KB LB MB NB OB PB QB RB SB TB I","2":"C L M G N O P"},C:{"1":"0 sB tB uB vB wB xB yB zB QC 0B RC 1B 2B 3B 4B 5B 6B 7B 8B 9B AC BC CC DC EC FC GC HC Q H R SC S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z AB BB CB DB EB FB GB HB IB JB KB LB MB NB OB PB QB RB SB TB I TC IC UC tC uC","2":"sC PC vC wC","164":"1 2 3 4 5 6 7 8 9 J UB K D E F A B C L M G N O P VB WB XB YB ZB aB bB cB dB eB fB gB hB iB jB kB lB mB nB oB pB qB rB"},D:{"1":"0 oB pB qB rB sB tB uB vB wB xB yB zB QC 0B RC 1B 2B 3B 4B 5B 6B 7B 8B 9B AC BC CC DC EC FC GC HC Q H R S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z AB BB CB DB EB FB GB HB IB JB KB LB MB NB OB PB QB RB SB TB I TC IC UC","2":"1 2 3 4 5 6 7 8 9 J UB K D E F A B C L M G N O P VB WB XB YB ZB aB bB cB dB eB fB gB hB iB jB kB lB mB nB"},E:{"1":"F A B C L M G 1C WC JC KC 2C 3C 4C XC YC LC 5C MC ZC aC bC cC dC 6C NC eC fC gC hC iC 7C OC jC kC lC mC nC oC 8C","2":"J UB K D E xC VC yC zC 0C"},F:{"1":"0 bB cB dB eB fB gB hB iB jB kB lB mB nB oB pB qB rB sB tB uB vB wB xB yB zB 0B 1B 2B 3B 4B 5B 6B 7B 8B 9B AC BC CC DC EC FC GC HC Q H R SC S T U V W X Y Z a b c d e f g h i j k l m n o p q r s t u v w x y z","2":"1 2 3 4 5 6 7 8 9 F B C G N O P VB WB XB YB ZB aB 9C AD BD CD JC pC DD KC"},G:{"1":"JD KD LD MD ND OD PD QD RD SD TD UD VD WD XD XC YC LC YD MC ZC aC bC cC dC ZD NC eC fC gC hC iC aD OC jC kC lC mC nC oC","2":"E VC ED qC FD GD HD ID"},H:{"2":"bD"},I:{"1":"I","2":"PC J cD dD eD fD qC gD hD"},J:{"2":"D A"},K:{"1":"H","2":"A B C JC pC KC"},L:{"1":"I"},M:{"1":"IC"},N:{"2":"A B"},O:{"1":"LC"},P:{"1":"1 2 3 4 5 6 7 8 9 iD jD kD lD mD WC nD oD pD qD rD MC NC OC sD","2":"J"},Q:{"1":"tD"},R:{"1":"uD"},S:{"1":"wD","164":"vD"}},B:5,C:":placeholder-shown CSS pseudo-class",D:true};
  business/node_modules/@noble/hashes/esm/blake1.js:179:// Reusable temporary buffer
  business/node_modules/@types/yargs-parser/index.d.ts:51:        /** Should a placeholder be added for keys not set via the corresponding CLI argument? Default is `false` */
  business/node_modules/@types/yargs-parser/index.d.ts:52:        "set-placeholder-key": boolean;
  business/node_modules/@types/babel__template/index.d.ts:6:     * A set of placeholder names to automatically accept.
  business/node_modules/@types/babel__template/index.d.ts:7:     * Items in this list do not need to match `placeholderPattern`.
  business/node_modules/@types/babel__template/index.d.ts:9:     * This option cannot be used when using `%%foo%%` style placeholders.
  business/node_modules/@types/babel__template/index.d.ts:11:    placeholderWhitelist?: Set<string> | null | undefined;
  business/node_modules/@types/babel__template/index.d.ts:15:     * nodes that should be considered as placeholders.
  business/node_modules/@types/babel__template/index.d.ts:17:     * `false` will disable placeholder searching placeholders, leaving only
  business/node_modules/@types/babel__template/index.d.ts:18:     * the `placeholderWhitelist` value to find replacements.
  business/node_modules/@types/babel__template/index.d.ts:20:     * This option cannot be used when using `%%foo%%` style placeholders.
  business/node_modules/@types/babel__template/index.d.ts:24:    placeholderPattern?: RegExp | false | null | undefined;
  business/node_modules/@types/babel__template/index.d.ts:35:     * Set to `true` to use `%%foo%%` style placeholders, `false` to use legacy placeholders
  business/node_modules/@types/babel__template/index.d.ts:36:     * described by `placeholderPattern` or `placeholderWhitelist`.
  business/node_modules/@types/babel__template/index.d.ts:38:     * When it is not set, it behaves as `true` if there are syntactic placeholders, otherwise as `false`.
  business/node_modules/@types/babel__template/index.d.ts:65:     * Does not allow `%%foo%%` style placeholders.
  business/node_modules/v8-to-istanbul/lib/v8-to-istanbul.js:42:    // Indicate that this report was generated with placeholder data from
  business/node_modules/@noble/hashes/esm/legacy.js:17:// Reusable temporary buffer
  business/node_modules/@noble/hashes/esm/legacy.js:95:// Reusable temporary buffer
  business/node_modules/@noble/hashes/esm/legacy.js:219:// Reusable temporary buffer
  business/node_modules/v8-to-istanbul/lib/range.js:10:    // I consider this a temporary solution until I find an alternaive way to fix the "off by one issue"
  business/node_modules/y18n/README.md:100:in the string, the `count` will replace this placeholder.
  business/node_modules/express/lib/router/index.js:64: * Map the given param placeholder `name`(s) to the given callback.
  business/node_modules/express/lib/router/index.js:67: * which use normalized placeholders. For example a _:user_id_ parameter
  business/node_modules/express/lib/router/index.js:72: * being that the value of the placeholder is passed, in this case the _id_
  business/node_modules/express/lib/request.js:221: *  - Checks route placeholders, ex: _/user/:id_
  business/node_modules/formidable/README.md:624:  // case you are unhappy with the way formidable generates a temporary path for your files.
  business/node_modules/@noble/hashes/esm/scrypt.js:23:    // Save state to temporary variables (salsa)
