const path = require('path');

const nextConfig = {
  reactStrictMode: true,
  images: {
    unoptimized: true
  },
  trailingSlash: true,

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

    // Disable CSS processing
    config.module.rules.forEach((rule) => {
      if (rule.oneOf) {
        rule.oneOf.forEach((oneOfRule) => {
          if (oneOfRule.test && oneOfRule.test.toString().includes('css')) {
            oneOfRule.use = ['style-loader', 'css-loader'];
          }
        });
      }
    });

    return config
  },

  // Disable experimental features that might cause issues
  experimental: {
    optimizeCss: false
  },

  // Completely disable TypeScript and ESLint checking for build
  typescript: {
    ignoreBuildErrors: true,
  },

  eslint: {
    ignoreDuringBuilds: true,
  },

  // Disable source maps for faster builds
  productionBrowserSourceMaps: false,
};

module.exports = nextConfig; 