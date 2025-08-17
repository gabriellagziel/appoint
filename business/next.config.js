/** @type {import('next').NextConfig} */
const withBundleAnalyzer = require('@next/bundle-analyzer')({ enabled: process.env.ANALYZE === 'true' });
const { withSentryConfig } = require('@sentry/nextjs');

const nextConfig = {
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          {
            key: 'Strict-Transport-Security',
            value: 'max-age=31536000; includeSubDomains; preload',
          },
        ],
      },
    ];
  },
  compress: true,
  images: {
    domains: ['business.app-oint.com'],
    formats: ['image/avif', 'image/webp'],
  },
  webpack: (config) => {
    config.plugins = config.plugins || [];
    const DefinePlugin = require('webpack').DefinePlugin;
    config.plugins.push(new DefinePlugin({ 'process.env.BUILD_TIME': JSON.stringify(new Date().toISOString()) }));
    return config;
  }
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