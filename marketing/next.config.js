const { i18n } = require('./next-i18next.config')

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,
  i18n,
  images: {
    formats: ['image/webp', 'image/avif'],
    domains: ['localhost'],
    unoptimized: true
  },
  trailingSlash: true,
  // Remove static export for i18n compatibility
  // output: 'export',
}

module.exports = nextConfig 