const path = require("path");

const nextConfig = {
  reactStrictMode: true,
  images: {
    unoptimized: true
  },
  trailingSlash: true,
  typescript: {
    ignoreBuildErrors: true,
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  webpack: (config) => {
    config.resolve.alias = {
      ...config.resolve.alias,
      "@": path.resolve(__dirname, "src"),
    };
    return config;
  },
  output: "standalone",
};

module.exports = nextConfig;
