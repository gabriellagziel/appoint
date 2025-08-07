# App-Oint Marketing Site

A Next.js marketing site for App-Oint with TypeScript, Tailwind CSS, and shadcn/ui components.

## Features

- Responsive navbar with mobile menu
- Hero section with email capture form
- Static export for deployment
- GitHub Actions deployment to GitHub Pages
- DigitalOcean App Platform ready

## Installation

```bash
cd marketing
npm install
```

## Development

To run the development server:

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

## Building for Production

To build and export the site for static hosting:

```bash
npm run build
npm run export
```

The static files will be generated in the `out/` directory.

## Deployment

### GitHub Pages

The site is automatically deployed to GitHub Pages via GitHub Actions when pushing to the `main` branch.

### DigitalOcean App Platform

1. Make sure you have the [DigitalOcean CLI](https://docs.digitalocean.com/reference/doctl/how-to/install/) (`doctl`) installed and authenticated.
2. At the repo root, run:

   ```bash
   doctl apps create --spec app_spec.yaml
   ```

3. This will provision the static site using the provided spec.
4. To redeploy after changes, you can use:

   ```bash
   doctl apps update <APP_ID> --spec app_spec.yaml
   ```

#### DNS Setup

- Add A/ALIAS records for `www.app-oint.com` in your domain registrar’s DNS, pointing to the addresses provided by DigitalOcean after the app is created.
- Enable Automatic HTTPS in the DigitalOcean App Platform dashboard for SSL.

## Project Structure

```
marketing/
├── src/
│   ├── app/
│   │   ├── layout.tsx        # Root layout
│   │   └── globals.css       # Global styles
│   └── components/
│       ├── Navbar.tsx        # Navigation component
│       ├── Hero.tsx          # Hero section
│       └── ui/               # shadcn/ui components
├── pages/
│   └── index.tsx             # Main page
├── .github/workflows/
│   └── deploy.yml            # GitHub Actions workflow
├── package.json              # Dependencies and scripts
├── next.config.js            # Next.js config
├── .gitignore                # Ignore files
└── README.md                 # This file
app_spec.yaml                 # DigitalOcean App Platform spec
```

## Technologies Used

- [Next.js](https://nextjs.org/) - React framework
- [TypeScript](https://www.typescriptlang.org/) - Type safety
- [Tailwind CSS](https://tailwindcss.com/) - Utility-first CSS
- [shadcn/ui](https://ui.shadcn.com/) - UI components
- [Lucide React](https://lucide.dev/) - Icons
