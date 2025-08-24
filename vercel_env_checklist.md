# Vercel Environment Variables Checklist

## All Projects - NEXT_PUBLIC_* (Preview & Production)

- [ ] NEXT_PUBLIC_API_URL=<https://us-central1-app-oint-core.cloudfunctions.net>
- [ ] NEXT_PUBLIC_FIREBASE_API_KEY=[your-firebase-key]
- [ ] NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=[your-stripe-publishable]

## Marketing Additional (Preview & Production)

- [ ] NEXT_PUBLIC_BUSINESS_URL=<https://business.app-oint.com>
- [ ] NEXT_PUBLIC_ENTERPRISE_URL=<https://enterprise.app-oint.com>
- [ ] NEXT_PUBLIC_REGISTER_ENDPOINT=<https://us-central1-app-oint-core.cloudfunctions.net/registerBusiness>
- [ ] NEXT_PUBLIC_SITE_URL=<https://app-oint.com>

## Dashboard - Server Secrets (Production + Preview if needed)

- [ ] NEXTAUTH_SECRET=GMgdC2vHTB9SoLwMZbTM5yRyHm0YqUUjL2+F+VMFDgc=
- [ ] NEXTAUTH_URL=<https://dashboard.app-oint.com> (Production) / Preview URL (Preview)
- [ ] STRIPE_SECRET_KEY=[your-stripe-secret]

## Business - Server Secrets (Production + Preview if needed)

- [ ] JWT_SECRET=7e82af0cbc1dd6846807316d83c442a8418f6b250bbc705349f7c779b34284a9
- [ ] BUSINESS_SECRET_KEY=+Xpc1ORmOciggTkHK+bWtXBPz+GMyXqUz9z+X5Ob7Xk=
- [ ] STRIPE_SECRET_KEY=[your-stripe-secret]

## Enterprise-app - Server Secrets (Production + Preview if needed)

- [ ] STRIPE_SECRET_KEY=[your-stripe-secret]

## After Setting All Vars

- [ ] Redeploy all Previews in Vercel
- [ ] Verify Preview builds are green
