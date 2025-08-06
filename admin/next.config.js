/** @type {import('next').NextConfig} */
const nextConfig = {
  /* config options here */
  output: 'standalone',
  experimental: {
    serverActions: {
      allowedOrigins: ['localhost:8082', '*.app-oint.com']
    }
  },
  webpack: (config, { isServer }) => {
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

module.exports = nextConfig;
