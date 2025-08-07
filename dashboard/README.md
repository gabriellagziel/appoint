# APP-OINT Client Portal (Dashboard)

## Getting Started

### Install dependencies
```bash
cd dashboard && npm install
```

### Run locally
```bash
npm run dev
```

### Build and start
```bash
npm run build && npm run start
```

## Deployment

- Deployment is automated via GitHub Actions and DigitalOcean App Platform.
- To deploy manually:
  ```bash
  doctl apps create --spec dashboard_app_spec.yaml
  ```
- Store your DigitalOcean App ID in the `DO_APP_ID` GitHub secret.

## DNS
- Point `dashboard.app-oint.com` to DigitalOcean App Platform as instructed in the DO dashboard.

## Environment Variables
Create a `.env.local` file in `dashboard/` with:
```
NEXTAUTH_URL=https://dashboard.app-oint.com
NEXTAUTH_SECRET=<your-secret>
```

## Features
- Next.js App Router
- NextAuth authentication (role: client)
- Shadcn/ui components
- Protected dashboard routes
- Placeholder pages for Overview, Appointments, New Booking, Reports
- API route stubs for appointments
# Force deployment
