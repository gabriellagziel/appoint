# enterprise-app – Environment Variables

## Detected via process.env

## From next.config.* (if any)
- (none)

## From .env.* examples (if any)
- NEXT_PUBLIC_FIREBASE_API_KEY
- REDACTED_TOKEN
- NODE_ENV
- STRIPE_SECRET_KEY

## Notes
- Any **NEXT_PUBLIC_*** must exist in both Preview & Production in Vercel.
- Non-NEXT_PUBLIC keys are server-only; set in Vercel env (not exposed to browser).
- If empty above, this app likely relies on defaults only.
