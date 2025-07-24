/** @type {import('next').NextConfig} */
const nextConfig = {
  /* config options here */
  output: 'standalone',
  experimental: {
    serverActions: {
      allowedOrigins: ['localhost:8082', '*.app-oint.com']
    }
  }
};

module.exports = nextConfig;
