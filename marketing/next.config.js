/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,

  // Production optimizations
  compress: true,
  poweredByHeader: false,

  // Support for DigitalOcean App Platform
  output: 'standalone',

  // Handle trailing slashes
  trailingSlash: false,

  // Environment variables
  env: {
    CUSTOM_KEY: process.env.CUSTOM_KEY,
  },

  // Image optimization
  images: {
    domains: ['localhost', 'app-oint.com'],
    formats: ['image/webp', 'image/avif'],
  },

  // i18n configuration
  i18n: {
    locales: ['en', 'es', 'fr', 'de', 'he', 'ar'],
    defaultLocale: 'en',
    localeDetection: true,
  },

  // Headers for security and performance
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'Referrer-Policy',
            value: 'origin-when-cross-origin',
          },
        ],
      },
    ];
  },
}

module.exports = nextConfig 