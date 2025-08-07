# App-Oint Business Studio

Professional marketing landing page for App-Oint's Business Studio – the CRM platform for business users.

## 🎯 Target Domain

- **Production**: <https://business.app-oint.com>
- **Development**: <http://localhost:3000>

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- npm or yarn

### Installation

```bash
cd business
npm install
```

### Development

```bash
npm run dev
```

### Build for Production

```bash
npm run build
npm start
```

## 📁 Project Structure

```
business/
├── src/
│   ├── app/
│   │   ├── layout.tsx      # Root layout with secret HTML comment
│   │   ├── page.tsx        # Main landing page
│   │   └── globals.css     # Global styles
│   └── components/
│       └── Landing/
│           ├── Hero.tsx     # Hero section with CTAs
│           ├── Features.tsx # Core features showcase
│           ├── Pricing.tsx  # Pricing cards
│           ├── Testimonials.tsx # Placeholder testimonials
│           └── Footer.tsx   # Footer with navigation
├── package.json
├── next.config.js
├── tailwind.config.js
└── tsconfig.json
```

## 🎨 Design System

- **Primary Color**: #0A84FF (Blue)
- **Secondary Color**: #5AC8FA (Light Blue)
- **Typography**: Inter font family
- **Framework**: Next.js 14 with App Router
- **Styling**: Tailwind CSS

## 🔐 Secret HTML Comment

The layout includes a secret HTML comment in the `<head>` section for internal project notes:

```html
<!-- SYSTEM_TAG: 🔐 Internal Project Note – App-Oint Business Studio -->
<!-- SYSTEM_TAG: 📦 Type = SaaS CRM Portal -->
<!-- SYSTEM_TAG: 🧠 Purpose = Business management layer on top of core meeting engine -->
<!-- SYSTEM_TAG: 🔒 This is NOT a POS or payment gateway -->
<!-- SYSTEM_TAG: 📊 Focus = Analytics, Appointments, Branding, CRM tools -->
<!-- SYSTEM_TAG: 💡 Revenue Model = Subscription-based B2B (not per-transaction) -->
```

## 📱 Features

- ✅ Modern, engaging structure
- ✅ Mobile & SEO ready
- ✅ Responsive design
- ✅ Professional marketing copy
- ✅ Placeholder testimonials (no fake content)
- ✅ Internal navigation links
- ✅ CTA buttons working

## 🚀 Deployment

The site is designed to be deployed to `business.app-oint.com` with proper SEO optimization and responsive design for all devices.

## 📞 Support

For questions about the Business Studio landing page, contact the development team.
