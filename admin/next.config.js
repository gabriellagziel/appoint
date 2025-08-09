/** @type {import('next').NextConfig} */
const withBundleAnalyzer = require('@next/bundle-analyzer')({ enabled: process.env.ANALYZE === 'true' });
const { withSentryConfig } = require('@sentry/nextjs');

const nextConfig = {
  output: 'standalone',
  compress: true,
  images: {
    formats: ['image/avif', 'image/webp'],
  },
  experimental: {
    serverActions: {
      allowedOrigins: ['localhost:8082', '*.app-oint.com']
    }
  },
  webpack: (config, { isServer }) => {
    config.plugins = config.plugins || [];
    // Inject build time for /version
    const DefinePlugin = require('webpack').DefinePlugin;
    config.plugins.push(new DefinePlugin({ 'process.env.BUILD_TIME': JSON.stringify(new Date().toISOString()) }));
    if (!isServer) {
      config.resolve.fallback = {
        ...config.resolve.fallback,
        fs: false,
        net: false,
        tls: false,
      };
    }

    // Handle Firebase/undici compatibility
    config.resolve.alias = {
      ...config.resolve.alias,
      'undici': false,
    };

    return config;
  },
};

const sentryWebpackPluginOptions = {
  authToken: process.env.SENTRY_AUTH_TOKEN,
  org: process.env.SENTRY_ORG,
  project: process.env.SENTRY_PROJECT,
  silent: true,
  disableServerWebpackPlugin: process.env.NODE_ENV !== 'production',
  disableClientWebpackPlugin: process.env.NODE_ENV !== 'production',
};

module.exports = withSentryConfig(withBundleAnalyzer(nextConfig), sentryWebpackPluginOptions);
