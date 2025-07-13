/** @type {import('next').NextConfig} */
const nextConfig = {
  // Temporarily removed static export to work as a service
  trailingSlash: true,
  images: {
    unoptimized: true
  }
}

module.exports = nextConfig 