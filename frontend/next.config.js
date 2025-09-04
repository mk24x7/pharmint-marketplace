const checkEnvVariables = require("./check-env-variables")

checkEnvVariables()

/**
 * @type {import('next').NextConfig}
 */
const nextConfig = {
  reactStrictMode: true,
  logging: {
    fetches: {
      fullUrl: true,
    },
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  typescript: {
    ignoreBuildErrors: true,
  },
  // Production cache management
  experimental: {
    // Ensure stable builds in production
    incrementalCacheHandlerPath: process.env.NODE_ENV === 'production' 
      ? require.resolve('./cache-handler.js') 
      : undefined,
  },
  // Cache configuration for production stability
  cacheHandler: process.env.NODE_ENV === 'production' ? './cache-handler.js' : undefined,
  cacheMaxMemorySize: 50 * 1024 * 1024, // 50MB
  // Disable cache when in development to prevent corruption
  ...(process.env.NODE_ENV === 'development' && {
    experimental: {
      isrMemoryCacheSize: 0, // Disable ISR memory cache in development
    }
  }),
  images: {
    remotePatterns: [
      {
        protocol: "http",
        hostname: "localhost",
      },
      {
        protocol: "https",
        hostname: "medusa-public-images.s3.eu-west-1.amazonaws.com",
      },
      {
        protocol: "https",
        hostname: "medusa-server-testing.s3.amazonaws.com",
      },
      {
        protocol: "https",
        hostname: "medusa-server-testing.s3.us-east-1.amazonaws.com",
      },
      {
        protocol: "https",
        hostname: "pharmint.net",
      },
      {
        protocol: "http",
        hostname: "pharmint.net",
      },
    ],
  },
}

module.exports = nextConfig
