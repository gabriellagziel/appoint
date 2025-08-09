import type { NextConfig } from 'next';
 
const withBundleAnalyzer = require('@next/bundle-analyzer')({ enabled: process.env.ANALYZE === 'true' });
 
const { withSentryConfig } = require('@sentry/nextjs');

const nextConfig: NextConfig = {
  compress: true,
  images: {
    formats: ['image/avif', 'image/webp'],
  },
  webpack: (config) => {
    // Inject build time for /version endpoint
    const DefinePlugin = require('webpack').DefinePlugin;
    config.plugins = config.plugins || [];
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

export default withSentryConfig(withBundleAnalyzer(nextConfig), sentryWebpackPluginOptions);
