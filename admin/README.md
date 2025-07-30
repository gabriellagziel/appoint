# App-Oint Admin Dashboard

A Next.js admin dashboard with authentication, layout components, and full deployment configuration.

## Features

- **Authentication**: NextAuth.js with role-based access control
- **Responsive Layout**: Sidebar navigation with mobile support
- **Admin Pages**: Dashboard, Users, Settings, Analytics
- **Protected Routes**: Middleware protection for admin routes
- **Modern UI**: Built with Tailwind CSS and shadcn/ui components
- **Deployment Ready**: GitHub Actions CI/CD and DigitalOcean App Platform

## Installation

```bash
cd admin
npm install
```

## Development

To run the development server:

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

## Authentication

### Demo Credentials
- **Username**: `admin`
- **Password**: `admin123`

### Protecting Routes
The admin dashboard uses NextAuth.js middleware to protect routes:

```typescript
// middleware.ts
export const config = {
  matcher: ["/admin/:path*"]
}
```

All routes under `/admin` require authentication and admin role.

## Building for Production

To build the application:

```bash
npm run build
npm run start
```

## Deployment

### GitHub Actions

The admin dashboard is automatically deployed via GitHub Actions when changes are pushed to the `main` branch.

### DigitalOcean App Platform

1. Install the DigitalOcean CLI:
   ```bash
   brew install doctl
   ```

2. Authenticate with DigitalOcean:
   ```bash
   doctl auth init
   ```

3. Deploy the admin dashboard:
   ```bash
   doctl apps create --spec admin_app_spec.yaml
   ```

4. Update the app after changes:
   ```bash
   doctl apps update <APP_ID> --spec admin_app_spec.yaml
   ```

### DNS Setup

1. Add A/ALIAS records for `admin.app-oint.com` in your domain registrar's DNS settings
2. Point to the addresses provided by DigitalOcean after app creation
3. Enable Automatic HTTPS in the DigitalOcean App Platform dashboard

## Project Structure

```
admin/
├── src/
│   ├── app/
│   │   ├── admin/
│   │   │   ├── page.tsx              # Dashboard
│   │   │   ├── users/
│   │   │   │   └── page.tsx          # Users management
│   │   │   ├── settings/
│   │   │   │   └── page.tsx          # Settings form
│   │   │   └── analytics/
│   │   │       └── page.tsx          # Analytics dashboard
│   │   ├── auth/
│   │   │   └── signin/
│   │   │       └── page.tsx          # Sign in page
│   │   ├── api/
│   │   │   └── auth/
│   │   │       └── [...nextauth]/
│   │   │           └── route.ts      # NextAuth API
│   │   ├── layout.tsx                # Root layout
│   │   └── globals.css               # Global styles
│   ├── components/
│   │   ├── AdminLayout.tsx           # Main layout wrapper
│   │   ├── Sidebar.tsx               # Navigation sidebar
│   │   ├── TopNav.tsx                # Top navigation
│   │   ├── Providers.tsx             # NextAuth provider
│   │   └── ui/                       # shadcn/ui components
│   ├── lib/
│   │   └── utils.ts                  # Utility functions
│   └── middleware.ts                 # Route protection
├── .github/workflows/
│   └── admin-deploy.yml              # GitHub Actions
├── package.json                      # Dependencies and scripts
├── next.config.js                    # Next.js config
├── .gitignore                        # Ignore files
└── README.md                         # This file
admin_app_spec.yaml                   # DigitalOcean App Platform spec
```

## Technologies Used

- [Next.js](https://nextjs.org/) - React framework
- [TypeScript](https://www.typescriptlang.org/) - Type safety
- [NextAuth.js](https://next-auth.js.org/) - Authentication
- [Tailwind CSS](https://tailwindcss.com/) - Utility-first CSS
- [shadcn/ui](https://ui.shadcn.com/) - UI components
- [Lucide React](https://lucide.dev/) - Icons

## Environment Variables

Create a `.env.local` file in the admin directory:

```env
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=your-secret-key-here
```

For production, set these in your DigitalOcean App Platform environment variables.

## Security Notes

- Replace the mock authentication in `[...nextauth]/route.ts` with real authentication logic
- Use strong, unique secrets for `NEXTAUTH_SECRET`
- Implement proper user management and role assignment
- Add rate limiting and additional security measures for production use
