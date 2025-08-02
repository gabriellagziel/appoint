const path = require('path');

const nextConfig = {
  reactStrictMode: true,
  images: {
    unoptimized: true
  },
  trailingSlash: true,

  // Completely disable TypeScript
  typescript: {
    ignoreBuildErrors: true,
  },

  // Disable ESLint during build
  eslint: {
    ignoreDuringBuilds: true,
  },

  // Ensure proper path resolution for DigitalOcean build environment
  webpack: (config) => {
    // Add explicit path alias resolution
    config.resolve.alias = {
      ...config.resolve.alias,
      '@': path.resolve(__dirname, 'src'),
    }

    // Ensure modules are resolved correctly
    config.resolve.modules = [
      path.resolve(__dirname, 'src'),
      'node_modules',
      ...config.resolve.modules || []
    ]

    return config
  },

  // Disable experimental features that might cause issues
  experimental: {
    optimizeCss: false
  },

  // Output configuration
  output: 'standalone',

  // Disable telemetry
  telemetry: false,
}

module.exports = nextConfig 