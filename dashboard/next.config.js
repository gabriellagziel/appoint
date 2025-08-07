/** @type {import('next').NextConfig} */
const nextConfig = {
    output: 'standalone',
    experimental: {
        // Optimize for smaller bundle size
        optimizePackageImports: ['lucide-react', '@radix-ui/react-icons'],
    },
};

module.exports = nextConfig;

